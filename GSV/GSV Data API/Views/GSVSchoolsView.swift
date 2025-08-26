//
//  GSVSchoolsView.swift
//  GSV
//
//  Created by Melanie Bishop on 8/24/25.
//

import Foundation
import SwiftUI



struct GSVSchoolsView: View {
    @StateObject private var vm = GSVSchoolsVM()
    @State private var searchTask: Task<Void, Never>?

    var body: some View {
        List {
            if let err = vm.errorText {
                Text("Error: \(err)").foregroundStyle(.red)
            }

            ForEach(vm.schools) { s in
                VStack(alignment: .leading, spacing: 4) {
                    Text(s.name).font(.headline)
                    HStack {
                        if let loc = s.location { Text(loc) }
                        if let url = s.url, !url.isEmpty { Text(url).foregroundStyle(.secondary) }
                    }.font(.caption)
                }
                .onAppear { if s.id == vm.schools.last?.id { Task { await vm.loadMore() } } }
            }

            if vm.schools.count < vm.total && !vm.schools.isEmpty {
                HStack { Spacer(); ProgressView(); Spacer() }
                    .onAppear { Task { await vm.loadMore() } }
            }
        }
        .navigationTitle("Schools")
        .searchable(text: $vm.q)
        .onChange(of: vm.q) { old, new in
            searchTask?.cancel()
            searchTask = Task {
                try? await Task.sleep(nanoseconds: 300_000_000)
                if !Task.isCancelled, new == vm.q { await vm.reload() }
            }
        }
        .task { await vm.initialLoadIfNeeded() }
    }
}
