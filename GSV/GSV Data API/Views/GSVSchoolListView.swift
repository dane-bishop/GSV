//
//  GSVSchoolListView.swift
//  GSV
//
//  Created by Melanie Bishop on 8/25/25.
//

import Foundation

import SwiftUI


struct GSVSchoolsListView: View {
    @EnvironmentObject var favs: FavoritesStore
    @StateObject private var vm = GSVSchoolsVM()
    @State private var showFavoritesOnly = true
    @State private var searchTask: Task<Void, Never>?

    private var filtered: [GSVSchool] {
        showFavoritesOnly ? vm.schools.filter { favs.isFavorite($0.id) } : vm.schools
    }

    var body: some View {
        NavigationSplitView {
            List {
                Toggle("Favorites Only", isOn: $showFavoritesOnly)

                ForEach(filtered) { s in
                    NavigationLink {
                        GSVSchoolDetailViewRemote(externalId: s.id, displayName: s.name)
                    } label: {
                        HStack {
                            Circle()
                                .fill(Color.secondary.opacity(0.15))
                                .frame(width: 36, height: 36)
                                .overlay(Text(initials(s.name)).font(.headline))
                            VStack(alignment: .leading) {
                                Text(s.name)
                                if let loc = s.location { Text(loc).font(.caption).foregroundStyle(.secondary) }
                            }
                            Spacer()
                            StarButton(isOn: favs.isFavorite(s.id)) { favs.toggle(s.id) }
                        }
                    }
                    .onAppear {
                        if s.id == vm.schools.last?.id { Task { await vm.loadMore() } }
                    }
                }

                if vm.schools.count < vm.total && !vm.schools.isEmpty {
                    HStack { Spacer(); ProgressView(); Spacer() }
                        .onAppear { Task { await vm.loadMore() } }
                }
            }
            .navigationTitle("Schools")
            .searchable(text: $vm.q)
            .onChange(of: vm.q) { _, _ in
                searchTask?.cancel()
                searchTask = Task {
                    try? await Task.sleep(nanoseconds: 300_000_000)
                    if !Task.isCancelled { await vm.reload() }
                }
            }
            .task { await vm.initialLoadIfNeeded() }
        } detail: {
            Text("Select a School")
        }
    }

    private func initials(_ name: String) -> String {
        let parts = name.split(separator: " ")
        let take = min(parts.count, 2)
        return parts.prefix(take).compactMap { $0.first }.map(String.init).joined()
    }
}
