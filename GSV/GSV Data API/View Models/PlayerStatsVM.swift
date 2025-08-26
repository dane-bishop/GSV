//
//  PlayerStats.swift
//  GSV
//
//  Created by Melanie Bishop on 8/24/25.
//

import Foundation

@MainActor
final class GSVPlayerStatsVM: ObservableObject {
    @Published var stats: [GSVPlayerStat] = []
    @Published var total = 0
    private var offset = 0
    private let pageSize = 100
    private var loading = false
    let playerId: Int
        
    init(playerId: Int) { self.playerId = playerId }
        
    func reload() async { offset = 0; stats = []; await loadMore() }
        
    func loadMore() async {
        guard !loading else { return }
        loading = true; defer { loading = false }
        do {
            let q = APIClient.PlayerStatsQuery(playerId: playerId, limit: pageSize, offset: offset, sort: "game_date", order: "desc")
            let page = try await APIClient.shared.fetchPlayerStats(q)
            total = page.total
            stats.append(contentsOf: page.items)
            offset += page.items.count
        } catch { print("stats load error:", error) }
    }
}
