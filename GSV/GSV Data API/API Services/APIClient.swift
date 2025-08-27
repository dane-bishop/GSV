//
//  APIClient.swift
//  GSV
//
//  Created by Melanie Bishop on 8/17/25.
//
import Foundation

struct APIError: LocalizedError {
    let status: Int
    let message: String
    var errorDescription: String? { "HTTP \(status): \(message)" }
}

private func debugPrint(_ items: Any...) {
#if DEBUG
    Swift.print("[API]", items.map { "\($0)" }.joined(separator: " "))
#endif
}

final class APIClient {
    static let shared = APIClient()
    private init() {}

    private let baseURL = URL(string: "https://api.gatewaysportsvenue.com")!

    private let session: URLSession = {
        let cfg = URLSessionConfiguration.default
        cfg.waitsForConnectivity = true
        cfg.timeoutIntervalForRequest = 30
        cfg.httpMaximumConnectionsPerHost = 4
        cfg.httpAdditionalHeaders = [
            "Accept": "application/json",
            "X-API-Key": "sk_ro_5q8VbA0Gz5k2rS3yZt8qW9pLc1uNmX",
        ]
        return URLSession(configuration: cfg)
    }()

    // ⚠️ if you later want to change keys at runtime, centralize here
    private let apiKey = "sk_ro_5q8VbA0Gz5k2rS3yZt8qW9pLc1uNmX"

    private func request(_ path: String,
                         method: String = "GET",
                         query: [URLQueryItem] = [],
                         body: Data? = nil) throws -> URLRequest {
        let clean = path.hasPrefix("/") ? String(path.dropFirst()) : path
        var comps = URLComponents(url: baseURL.appendingPathComponent(clean), resolvingAgainstBaseURL: false)!
        if !query.isEmpty { comps.queryItems = query }
        var req = URLRequest(url: comps.url!)
        req.httpMethod = method
        if let body {
            req.httpBody = body
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        return req
    }

    /// Send with small, bounded retries for transient errors (idempotent GETs).
    private func sendWithRetry(_ req: URLRequest, maxRetries: Int = 2) async throws -> (Data, HTTPURLResponse) {
        var attempt = 0
        var lastError: Error?

        while attempt <= maxRetries {
            do {
                debugPrint("→", req.httpMethod ?? "GET", req.url?.absoluteString ?? "(nil)")
                let (data, resp) = try await session.data(for: req)
                guard let http = resp as? HTTPURLResponse else { throw URLError(.badServerResponse) }
                debugPrint("←", http.statusCode, "bytes:", data.count)

                // If 2xx we're done
                if (200..<300).contains(http.statusCode) { return (data, http) }

                // Retry on common transient upstream codes
                if [502, 503, 504].contains(http.statusCode), attempt < maxRetries {
                    attempt += 1
                    let backoffMs = UInt64(200 * attempt * attempt) // 200ms, 800ms
                    try? await Task.sleep(nanoseconds: backoffMs * 1_000_000)
                    continue
                }

                // Non-retryable
                let body = String(data: data, encoding: .utf8) ?? "(non-utf8)"
                debugPrint("ERR BODY:", body)
                throw APIError(status: http.statusCode, message: body)
            } catch {
                lastError = error
                // Retry on network timeouts / connection lost
                if let urlErr = error as? URLError,
                   [.timedOut, .networkConnectionLost, .cannotConnectToHost, .cannotFindHost, .notConnectedToInternet].contains(urlErr.code),
                   attempt < maxRetries {
                    attempt += 1
                    let backoffMs = UInt64(200 * attempt * attempt)
                    try? await Task.sleep(nanoseconds: backoffMs * 1_000_000)
                    continue
                }
                // Otherwise bubble up immediately
                throw error
            }
        }
        throw lastError ?? URLError(.unknown)
    }

    // Optional quick probe
    func health() async {
        do {
            let req = try request("health")
            let (data, _) = try await sendWithRetry(req)
            debugPrint("HEALTH:", String(data: data, encoding: .utf8) ?? "(ok)")
        } catch {
            debugPrint("HEALTH FAIL:", error.localizedDescription)
        }
    }

    // MARK: Models used in responses
    struct PlayerStatsQuery {
        var playerId: Int?
        var gameId: Int?
        var statCategory: String?
        var statType: String?
        var dateFrom: String?
        var dateTo: String?
        var limit: Int = 100
        var offset: Int = 0
        var sort: String = "game_date"
        var order: String = "desc"
    }

    // MARK: Players (no JWT)
    func fetchPlayers(q: String? = nil, limit: Int = 100, offset: Int = 0) async throws -> Paged<GSVPlayer> {
        var qs = [URLQueryItem(name: "limit", value: String(limit)),
                  URLQueryItem(name: "offset", value: String(offset))]
        if let q, !q.isEmpty { qs.append(.init(name: "q", value: q)) }
        let req = try request("api/v1/players", query: qs)
        let (data, _) = try await sendWithRetry(req)
        return try JSONDecoder().decode(Paged<GSVPlayer>.self, from: data)
    }

    func fetchPlayer(id: Int) async throws -> GSVPlayer {
        let req = try request("api/v1/players/\(id)")
        let (data, _) = try await sendWithRetry(req)
        return try JSONDecoder().decode(GSVPlayer.self, from: data)
    }

    func fetchPlayerStats(_ q: PlayerStatsQuery) async throws -> Paged<GSVPlayerStat> {
        var qs: [URLQueryItem] = [
            .init(name: "limit", value: String(q.limit)),
            .init(name: "offset", value: String(q.offset)),
            .init(name: "sort", value: q.sort),
            .init(name: "order", value: q.order)
        ]
        if let id = q.playerId { qs.append(.init(name: "player_id", value: String(id))) }
        if let gid = q.gameId   { qs.append(.init(name: "game_id", value: String(gid))) }
        if let v = q.statCategory, !v.isEmpty { qs.append(.init(name: "stat_category", value: v)) }
        if let v = q.statType, !v.isEmpty     { qs.append(.init(name: "stat_type", value: v)) }
        if let v = q.dateFrom, !v.isEmpty     { qs.append(.init(name: "date_from", value: v)) }
        if let v = q.dateTo, !v.isEmpty       { qs.append(.init(name: "date_to", value: v)) }

        let req = try request("api/v1/player-stats", query: qs)
        let (data, _) = try await sendWithRetry(req)
        return try JSONDecoder().decode(Paged<GSVPlayerStat>.self, from: data)
    }

    // NEW schedule-based stats (your code looked good — just switch to sendWithRetry)
    func fetchPlayerStatsBySchedule(
        scheduleId: Int,
        limit: Int = 200,
        offset: Int = 0,
        sort: String = "player_id",
        order: String = "asc"
    ) async throws -> PlayerStatsByScheduleResponse {
        let path = "api/v1/games/\(scheduleId)/player-stats"
        let qs: [URLQueryItem] = [
            .init(name: "limit", value: String(limit)),
            .init(name: "offset", value: String(offset)),
            .init(name: "sort", value: sort),
            .init(name: "order", value: order)
        ]
        let req = try request(path, query: qs)
        let (data, _) = try await sendWithRetry(req)

        // First try strict decode
        do {
            let dec = JSONDecoder()
            return try dec.decode(PlayerStatsByScheduleResponse.self, from: data)
        } catch {
            #if DEBUG
            let preview = String(data: data.prefix(800), encoding: .utf8) ?? ""
            debugPrint("[API] decode fallback \(path) first 800 chars:\n", preview)
            #endif

            // Fallback: decode the old/loose shape
            let dec = JSONDecoder()
            let loose = try dec.decode(LooseEnvelope.self, from: data)

            let looseItems: [LooseStat] = loose.items ?? []
            let items: [GSVPlayerStat] = looseItems.map { ls in
                let normalizedDate = ls.game_date.map(GSVPlayerStat.normalizeDateString)
                return GSVPlayerStat(
                    id: ls.id ?? -1,
                    playerId: ls.player_id ?? -1,
                    statType: ls.stat_type,
                    statValue: ls.stat_value,
                    statCategory: ls.stat_category,
                    gameDate: normalizedDate,
                    gameId: ls.game_id,
                    playerName: ls.player_name,
                    teamName: ls.team_name,
                    playerExternalId: ls.player_external_id
                )
            }

            let game: PlayerStatsByScheduleResponse.Game? = loose.game.map {
                PlayerStatsByScheduleResponse.Game(
                    scheduleId: $0.schedule_id,
                    date: $0.date,
                    sport: $0.sport,
                    location: $0.location,
                    schoolId: $0.school_id,
                    opponent: $0.opponent,
                    score: $0.score,
                    result: $0.result,
                    homeExternalId: $0.home_external_id,
                    awayExternalId: $0.away_external_id
                )
            }

            return PlayerStatsByScheduleResponse(
                total: loose.total ?? items.count,
                limit: loose.limit ?? items.count,
                offset: loose.offset ?? 0,
                items: items,
                game: game
            )
        }
    }

    // MARK: Schools
    func fetchSchools(q: String? = nil, limit: Int = 50, offset: Int = 0) async throws -> Paged<GSVSchool> {
        var qs: [URLQueryItem] = [
            .init(name: "limit", value: String(limit)),
            .init(name: "offset", value: String(offset))
        ]
        if let q, !q.isEmpty { qs.append(.init(name: "q", value: q)) }
        let req = try request("api/v1/schools", query: qs)
        let (data, _) = try await sendWithRetry(req)
        return try JSONDecoder().decode(Paged<GSVSchool>.self, from: data)
    }

    // MARK: Team Schedule
    struct ScheduleQuery {
        var schoolId: Int?
        var sport: String?
        var year: Int?
        var dateFrom: String?
        var dateTo: String?
        var q: String?
        var sort: String = "date"   // NEW
        var order: String = "desc"  // NEW
        var limit = 50
        var offset = 0
    }

    func fetchTeamSchedule(_ q: ScheduleQuery) async throws -> Paged<GSVSchedule> {
        var qs: [URLQueryItem] = [
            .init(name: "limit", value: String(q.limit)),
            .init(name: "offset", value: String(q.offset)),
            .init(name: "sort", value: q.sort),     // NEW
            .init(name: "order", value: q.order)    // NEW
        ]
        if let v = q.schoolId { qs.append(.init(name: "school_id", value: String(v))) }
        if let v = q.sport, !v.isEmpty { qs.append(.init(name: "sport", value: v)) }
        if let v = q.year { qs.append(.init(name: "year", value: String(v))) }
        if let v = q.dateFrom, !v.isEmpty { qs.append(.init(name: "date_from", value: v)) }
        if let v = q.dateTo, !v.isEmpty { qs.append(.init(name: "date_to", value: v)) }
        if let v = q.q, !v.isEmpty { qs.append(.init(name: "q", value: v)) }

        let req = try request("api/v1/team-schedule", query: qs)
        let (data, _) = try await perform(req)
        return try JSONDecoder().decode(Paged<GSVSchedule>.self, from: data)
    }
    
    private func perform(_ req: URLRequest) async throws -> (Data, HTTPURLResponse) {
        debugPrint("→", req.httpMethod ?? "GET", req.url?.absoluteString ?? "(nil)")
        let (data, resp) = try await session.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        debugPrint("←", http.statusCode, "bytes:", data.count)
        if !(200..<300).contains(http.statusCode) {
            let body = String(data: data, encoding: .utf8) ?? "(non-utf8)"
            debugPrint("ERR BODY:", body)
            throw APIError(status: http.statusCode, message: body)
        }
        return (data, http)
    }
}



extension APIClient {
    func fetchSchool(id: Int) async throws -> GSVSchool {
        let req = try request("api/v1/schools/\(id)")
        let (data, _) = try await perform(req)
        return try JSONDecoder().decode(GSVSchool.self, from: data)
    }
}

// VERY tolerant stat for fallback parse
private struct LooseStat: Decodable {
    let id: Int?
    let player_id: Int?
    let stat_type: String?
    let stat_value: Double?
    let stat_category: String?
    let game_date: String?
    let game_id: Int?
    let player_name: String?
    let team_name: String?
    let player_external_id: Int?
}

private struct LooseGame: Decodable {
    let schedule_id: Int?
    let date: String?
    let sport: String?
    let location: String?
    let school_id: Int?
    let opponent: String?
    let score: String?
    let result: String?
    let home_external_id: Int?
    let away_external_id: Int?
}

private struct LooseEnvelope: Decodable {
    let total: Int?
    let limit: Int?
    let offset: Int?
    let items: [LooseStat]?
    let game: LooseGame?
}

