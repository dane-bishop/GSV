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
            if vm.stats.isEmpty {
                ContentUnavailableView("No player stats", systemImage: "person.crop.circle.badge.questionmark")
            } else {
                ForEach(vm.stats) { s in
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(s.playerName ?? "Player")
                                .font(.headline)
                            HStack(spacing: 8) {
                                Text(s.stat_type ?? "Stat")
                                if let cat = s.stat_category, !cat.isEmpty {
                                    Text("· \(cat)").foregroundStyle(.secondary)
                                }
                            }
                            .font(.subheadline)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(s.stat_value.map { String($0) } ?? "-")
                                .font(.title3).monospacedDigit()
                            Text(s.game_date ?? "")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
                .onAppear {
                    if vm.stats.count >= 20 { Task { await vm.loadMore() } }
                }
            }
        }
        .navigationTitle(titleText)
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.reload() }
        .refreshable { await vm.reload() }
    }
}
