//
//  GSVPlayerDetailView.swift
//  GSV
//
//  Created by Melanie Bishop on 8/24/25.
//

import Foundation
import SwiftUI

struct GSVPlayerDetailView: View {
    let player: GSVPlayer
    @StateObject private var vm: GSVPlayerStatsVM

    init(player: GSVPlayer) {
        self.player = player
        _vm = StateObject(wrappedValue: GSVPlayerStatsVM(playerId: player.id))
    }

    var body: some View {
        List {
            // Header
            Section {
                VStack(alignment: .leading, spacing: 6) {
                    Text(player.name ?? "Unknown")
                        .font(.title2).bold()
                    HStack(spacing: 8) {
                        if let t = player.team_name, !t.isEmpty { Text(t) }
                        if let link = player.player_link,
                           !link.isEmpty,
                           let url = URL(string: link) {
                            Spacer(minLength: 8)
                            Link(link, destination: url)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .font(.subheadline)
                }
                .padding(.vertical, 4)
            }

            // Recent stats
            Section("Recent stats") {
                if let err = vm.errorText {
                    Text("Error: \(err)").foregroundStyle(.red)
                } else if vm.stats.isEmpty {
                    Text("No stats yet")
                } else {
                    ForEach(vm.stats) { s in
                        StatRow(s: s)        // <— uses camelCase stat fields
                    }

                    // Pagination sentinel as its own row (avoids ViewBuilder type issues)
                    if vm.stats.count < vm.total {
                        HStack { Spacer(); ProgressView(); Spacer() }
                            .onAppear { Task { await vm.loadMore() } }
                    }
                }
            }
        }
        .navigationTitle("Player")
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.reload() }
        .refreshable { await vm.reload() }
    }
}

// Simple, reusable row
private struct StatRow: View {
    let s: GSVPlayerStat
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(s.statType ?? "Stat").font(.headline)
                Text(s.statCategory ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(s.statValue.map { String($0) } ?? "-")
                Text(s.gameDate ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
