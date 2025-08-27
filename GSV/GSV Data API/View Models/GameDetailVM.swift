//
//  GameDetailVM.swift
//  GSV
//
//  Created by Melanie Bishop on 8/24/25.
//

import Foundation


@MainActor
final class GSVGameDetailVM: ObservableObject {
    @Published var header: PlayerStatsByScheduleResponse.Game?
    @Published var awayStats: [GSVPlayerStat] = []
    @Published var homeStats: [GSVPlayerStat] = []
    @Published var unknownStats: [GSVPlayerStat] = []
    @Published var errorText: String?

    private(set) var total = 0
    private var offset = 0
    private let pageSize = 200
    private var loading = false

    let gameId: Int

    // Optional, used only for display + string-fallback bucketing
    private let homeNameL: String
    private let awayNameL: String

    init(gameId: Int, homeName: String? = nil, awayName: String? = nil) {
        self.gameId = gameId
        self.homeNameL = (homeName ?? "").lowercased()
        self.awayNameL = (awayName ?? "").lowercased()
    }

    func reload() async {
        offset = 0
        total = 0
        header = nil
        awayStats.removeAll()
        homeStats.removeAll()
        unknownStats.removeAll()
        await loadMore()
    }

    func loadMore() async {
        guard !loading else { return }
        loading = true
        defer { loading = false }

        do {
            let resp = try await APIClient.shared.fetchPlayerStatsBySchedule(
                scheduleId: gameId,
                limit: pageSize,
                offset: offset,
                sort: "player_id",
                order: "asc"
            )

            if offset == 0 { header = resp.game }

            bucket(items: resp.items, header: resp.game)
            offset += resp.items.count
            total = resp.total

            #if DEBUG
            print("[GameDetailVM] scheduleId:", gameId,
                  "items:", resp.items.count,
                  "total:", resp.total,
                  "homeId:", resp.game?.homeExternalId ?? -1,
                  "awayId:", resp.game?.awayExternalId ?? -1,
                  "score:", resp.game?.score ?? "nil")
            print("[GameDetailVM] bucketed — away:", awayStats.count,
                  "home:", homeStats.count, "unknown:", unknownStats.count)
            #endif

        } catch {
            errorText = error.localizedDescription
        }
    }

    private func bucket(items: [GSVPlayerStat], header: PlayerStatsByScheduleResponse.Game?) {
        let homeId = header?.homeExternalId
        let awayId = header?.awayExternalId

        for s in items {
            // Prefer explicit school mapping
            if let ext = s.playerExternalId {
                if let h = homeId, ext == h { homeStats.append(s); continue }
                if let a = awayId, ext == a { awayStats.append(s); continue }
            }
            // Fallback: teamName string match against names passed in from caller
            if let tn = s.teamName?.lowercased(), !tn.isEmpty {
                if !homeNameL.isEmpty, tn.contains(homeNameL) { homeStats.append(s); continue }
                if !awayNameL.isEmpty, tn.contains(awayNameL) { awayStats.append(s); continue }
            }
            unknownStats.append(s)
        }
    }

    // Simple helpers the View can use
    var scoreText: String { header?.score ?? "" }
    var resultText: String { header?.result ?? "" }
    var dateText: String { header?.date ?? "" }
    var sportText: String { header?.sport ?? "" }

    
    
}



