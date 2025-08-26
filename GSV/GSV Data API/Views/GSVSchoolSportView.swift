//
//  GSVSchoolSportView.swift
//  GSV
//
//  Created by Melanie Bishop on 8/25/25.
//

import Foundation

import SwiftUI

struct GSVSchoolSportView: View {
    let schoolDisplayName: String
    let externalId: Int
    let sportDisplayName: String

    @StateObject private var vm = GSVScheduleVM()
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var didInitialLoad = false

    private var years: [Int] {
        let now = Calendar.current.component(.year, from: Date())
        return (max(now-9, 2010)...now).reversed()
    }

    private var sortedItems: [GSVSchedule] {
        vm.items.sorted {
            let l = $0.dateAsDate ?? .distantPast
            let r = $1.dateAsDate ?? .distantPast
            if l != r { return l > r }
            return $0.id > $1.id
        }
    }

    var body: some View {
        VStack {
            
            
            // Year chips + quick "This Year" action
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Year").font(.headline)
                    Spacer()
                    Button {
                        selectedYear = Calendar.current.component(.year, from: Date())
                    } label: {
                        Label("This Year", systemImage: "calendar")
                    }
                    .buttonStyle(.bordered)
                }
                YearChips(years: years, selected: $selectedYear)
            }
            .padding([.horizontal, .top])

            List {
                if let err = vm.errorText {
                    Text("Error: \(err)").foregroundStyle(.red)
                }

                ForEach(sortedItems) { it in
                    NavigationLink {
                        GSVGameDetailView(
                            gameId: it.id,
                            titleText: "\(it.sport) • \(headlineForGame(it))"
                        )
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(headlineForGame(it)).font(.headline)
                                Spacer()
                                if let s = it.score, !s.isEmpty { Text(s).font(.headline) }
                            }
                            HStack(spacing: 8) {
                                Text(it.date ?? "—"); Text("•"); Text(it.sport)
                            }
                            .font(.caption).foregroundStyle(.secondary)

                            HStack(spacing: 12) {
                                if let loc = it.location, !loc.isEmpty { Text(loc.capitalized) }
                                if let r = it.result, !r.isEmpty { Text(r) }
                                if let n = it.notes, !n.isEmpty { Text(n).font(.caption2) }
                            }
                            .font(.caption2).foregroundStyle(.secondary)
                        }
                    }
                    .id(it.id)
                    .onAppear {
                        if it.id == vm.items.last?.id { Task { await vm.loadMore() } }
                    }
                }

                if vm.items.count < vm.total && !vm.items.isEmpty {
                    HStack { Spacer(); ProgressView(); Spacer() }
                        .onAppear { Task { await vm.loadMore() } }
                }
            }
        }
        .navigationTitle("\(sportDisplayName)")
        .task {
            guard !didInitialLoad else { return }
            didInitialLoad = true
            await reload()
        }
        .onChange(of: selectedYear) { _, _ in Task { await reload() } }
    }

    private func reload() async {
        vm.schoolId = externalId
        vm.sport    = sportDisplayName
        vm.year     = String(selectedYear)
        await vm.reload()
    }

    private func headlineForGame(_ it: GSVSchedule) -> String {
        let loc = (it.location ?? "").lowercased()
        let our = it.school_name ?? schoolDisplayName
        let opp = it.opponent
        if ["home","h","host","vs","v"].contains(loc) { return "\(our) vs \(opp)" }
        if ["away","a","@"].contains(loc)             { return "\(opp) vs \(our)" }
        return "\(our) vs \(opp)"
    }
}
