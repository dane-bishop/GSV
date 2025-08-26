//
//  PlayersVM.swift
//  GSV
//
//  Created by Melanie Bishop on 8/24/25.
//

import Foundation

@MainActor
final class GSVPlayersVM: ObservableObject {
    @Published var q = ""
    @Published var players: [GSVPlayer] = []
    @Published var total = 0
    @Published var isLoading = false
    @Published var errorText: String? = nil

    private var offset = 0
    private let pageSize = 100
    private var didLoadOnce = false
    private var isFetching = false

    func initialLoadIfNeeded() async {
        guard !didLoadOnce else { return }
        didLoadOnce = true
        await reload()
    }

    func reload() async {
        errorText = nil
        isLoading = true
        offset = 0
        players = []
        await loadMore()
        isLoading = false
    }

    func loadMore() async {
        guard !isFetching else { return }
        isFetching = true
        defer { isFetching = false }

        do {
            let page = try await APIClient.shared.fetchPlayers(
                q: q.isEmpty ? nil : q,
                limit: pageSize,
                offset: offset
            )
            total = page.total
            players.append(contentsOf: page.items)
            offset += page.items.count
        } catch {
            errorText = error.localizedDescription
            Swift.print("[VM] players load error:", error.localizedDescription)
        }
    }
}
