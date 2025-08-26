//
//  GameDetailVM.swift
//  GSV
//
//  Created by Melanie Bishop on 8/24/25.
//

import Foundation

@MainActor
final class GSVGameDetailVM: ObservableObject {
    @Published var stats: [GSVPlayerStat] = []
    @Published var total = 0
    @Published var errorText: String?

    private var offset = 0
    private let pageSize = 100
    private var loading = false
    let gameId: Int

    init(gameId: Int) { self.gameId = gameId }

    private var canLoadMore: Bool { offset < total || total == 0 }

    func reload() async { offset = 0; stats = []; await loadMore() }

    func loadMore() async {
        guard !loading, canLoadMore else { return }
        loading = true; defer { loading = false }
        do {
            let page = try await APIClient.shared.fetchPlayerStatsBySchedule(
                scheduleId: gameId,
                limit: pageSize,
                offset: offset,
                sort: "player_id",
                order: "asc"
            )
            total = page.total
            stats.append(contentsOf: page.items)
            offset += page.items.count
        } catch {
            errorText = error.localizedDescription
        }
    }
}


