//
//  GSVPlayersView.swift
//  GSV
//
//  Created by Melanie Bishop on 8/24/25.
//

import Foundation
import SwiftUI


struct GSVPlayersView: View {
    @StateObject private var vm = GSVPlayersVM()
    @State private var searchTask: Task<Void, Never>?

    var body: some View {
        NavigationView {
            Group {
                if vm.isLoading && vm.players.isEmpty {
                    ProgressView("Loading players…")
                } else {
                    List {
                        if let err = vm.errorText {
                            Text("Error: \(err)")
                                .foregroundStyle(.red)
                        }
                        
                        if vm.players.isEmpty {
                            ContentUnavailableView("No players found", systemImage: "person.3")
                        } else {
                            ForEach(vm.players) { p in
                                NavigationLink(destination: GSVPlayerDetailView(player: p)) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(p.name ?? "Unknown").font(.headline)
                                        HStack {
                                            if let team = p.team_name { Text(team) }
                                            if let link = p.player_link, !link.isEmpty {
                                                Text(link).foregroundStyle(.secondary)
                                            }
                                        }.font(.caption)
                                    }
                                }
                                .onAppear {
                                    if p.id == vm.players.last?.id {
                                        Task { await vm.loadMore() }
                                    }
                                }
                            }

                            if vm.players.count < vm.total {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                                .onAppear { Task { await vm.loadMore() } }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Players")
            .searchable(text: $vm.q)
            .onChange(of: vm.q) { old, new in
                searchTask?.cancel()
                searchTask = Task {
                    try? await Task.sleep(nanoseconds: 350_000_000) // 350ms
                    if !Task.isCancelled, new == vm.q {
                        await vm.reload()
                    }
                }
            }
        }
        // first page (100) with no query
        .task {
                    await APIClient.shared.health()        // ← see connectivity in console
                    await vm.initialLoadIfNeeded()        // ← loads first 100
                }
    }
}
