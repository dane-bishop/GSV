//
//  Models.swift
//  GSV
//
//  Created by Melanie Bishop on 8/17/25.
//

import Foundation

struct Item: Codable {
    let id: Int
    let name: String
    let created_at: String?
}


// GSV Player
struct GSVPlayer: Codable, Identifiable, Hashable {
    let id: Int
    let name: String?
    let team_name: String?
    let player_link: String?
}


// MARK: - Player stats item used for /games/{id}/player-stats
struct GSVPlayerStat: Codable, Identifiable, Hashable {
    let id: Int
    let playerId: Int
    let statType: String?
    let statValue: Double?
    let statCategory: String?
    let gameDate: String?
    let gameId: Int?
    let playerName: String?
    let teamName: String?
    let playerExternalId: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case playerId = "player_id"
        case statType = "stat_type"
        case statValue = "stat_value"
        case statCategory = "stat_category"
        case gameDate = "game_date"
        case gameId = "game_id"
        case playerName = "player_name"
        case teamName = "team_name"
        case playerExternalId = "player_external_id"
    }
}


extension GSVPlayerStat {
    static func normalizeDateString(_ s: String) -> String {
        // already ISO?
        if s.count == 10, s[s.index(s.startIndex, offsetBy: 4)] == "-" { return s }
        let rfc = DateFormatter()
        rfc.locale = Locale(identifier: "en_US_POSIX")
        rfc.timeZone = TimeZone(secondsFromGMT: 0)
        rfc.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        if let dt = rfc.date(from: s) {
            let iso = DateFormatter()
            iso.locale = Locale(identifier: "en_US_POSIX")
            iso.timeZone = TimeZone(secondsFromGMT: 0)
            iso.dateFormat = "yyyy-MM-dd"
            return iso.string(from: dt)
        }
        return s
    }
}

// MARK: - Header describing the game
struct PlayerStatsGameHeader: Codable, Hashable {
    // make these optional to be robust if aliasing is missing
    let homeExternalId: Int?
    let awayExternalId: Int?
    let gameDate: String?
    let score: String?
    let result: String?
    let homeName: String?
    let awayName: String?
    let sport: String?
}





// GSV Schools
struct GSVSchool: Codable, Identifiable, Hashable {
    let external_id: Int
    let name: String
    let location: String?
    let url: String?

    var id: Int { external_id }
}


// GSV Team Schedules
struct GSVSchedule: Codable, Identifiable, Hashable {
    let id: Int
    let school_id: Int
    let school_name: String?    // ← NEW
    let sport: String
    let year: Int
    let date: String?           // "YYYY-MM-DD"
    let opponent: String
    let opponent_record: String?
    let location: String?
    let result: String?
    let score: String?
    let notes: String?

    enum CodingKeys: String, CodingKey {
        case id, school_id, school_name, sport, year, date, opponent, opponent_record,
             location, result, score, notes
    }
}








struct Paged<T: Codable>: Codable {
    let total: Int
    let limit: Int
    let offset: Int
    let items: [T]
}

struct LoginResponse: Codable {
    let access_token: String
}
