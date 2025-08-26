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
            Section {
                VStack(alignment: .leading, spacing: 6) {
                    Text(player.name ?? "Unknown").font(.title2).bold()
                    HStack {
                        if let t = player.team_name { Text(t) }
                        if let link = player.player_link, !link.isEmpty {
                            Text(link).foregroundStyle(.secondary)
                        }
                    }.font(.subheadline)
                }.padding(.vertical, 4)
            }
                
            Section("Recent stats") {
                if vm.stats.isEmpty {
                    Text("No stats yet")
                } else {
                    ForEach(vm.stats) { s in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(s.stat_type ?? "stat").font(.headline)
                                Text(s.stat_category ?? "").font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(s.stat_value.map { String($0) } ?? "-")
                                Text(s.game_date ?? "").font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onAppear {
                        if vm.stats.count >= 5 { Task { await vm.loadMore() } }
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
