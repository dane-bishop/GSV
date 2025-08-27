//
//  GSVGameDetailView.swift
//  GSV
//
//  Created by Melanie Bishop on 8/24/25.
//

import Foundation
import SwiftUI

struct GSVGameDetailView: View {
    let gameId: Int
    let titleText: String
    @StateObject private var vm: GSVGameDetailVM

    init(gameId: Int, titleText: String) {
        self.gameId = gameId
        self.titleText = titleText
        _vm = StateObject(wrappedValue: GSVGameDetailVM(gameId: gameId))
    }

    var body: some View {
        List {
            if let err = vm.errorText {
                Text("Error: \(err)").foregroundStyle(.red)
            }

            if let _ = vm.header {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        //Text(vm.headerLine()).font(.headline)
                        //Text(vm.subHeader()).font(.caption).foregroundStyle(.secondary)
                    }.padding(.vertical, 4)
                }
            }

            Section("Away team") {
                if vm.awayStats.isEmpty { Text("No stats") }
                ForEach(vm.awayStats) { StatRow(s: $0) }
            }

            Section("Home team") {
                if vm.homeStats.isEmpty { Text("No stats") }
                ForEach(vm.homeStats) { StatRow(s: $0) }
            }

            if !vm.unknownStats.isEmpty {
                Section("Unclassified") {
                    ForEach(vm.unknownStats) { StatRow(s: $0) }
                }
            }

            if (vm.awayStats.count + vm.homeStats.count + vm.unknownStats.count) < vm.total {
                HStack { Spacer(); ProgressView(); Spacer() }
                    .onAppear { Task { await vm.loadMore() } }
            }
        }
        .navigationTitle(titleText)
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.reload() }
        .refreshable { await vm.reload() }
    }
}

private struct StatRow: View {
    let s: GSVPlayerStat
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text(s.playerName ?? "Player").font(.headline)
                HStack(spacing: 8) {
                    Text(s.statType ?? "Stat")
                    if let cat = s.statCategory, !cat.isEmpty {
                        Text("· \(cat)").foregroundStyle(.secondary)
                    }
                }.font(.subheadline)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(s.statValue.map { String($0) } ?? "-")
                    .font(.title3).monospacedDigit()
                Text(s.gameDate ?? "")
                    .font(.caption).foregroundStyle(.secondary)
            }
        }
    }
}
