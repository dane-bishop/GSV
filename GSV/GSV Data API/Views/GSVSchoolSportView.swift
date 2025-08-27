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
    @State private var cachedSorted: [GSVSchedule] = []

    private var years: [Int] {
        let now = Calendar.current.component(.year, from: Date())
        return Array((max(now-17, 2008)...now).reversed())
    }

    var body: some View {
        VStack {
            YearBar(
                title: "Year",
                years: years,
                selectedYear: $selectedYear,
                onThisYear: { selectedYear = Calendar.current.component(.year, from: Date()) }
            )
            .padding([.horizontal, .top])

            List {
                if let err = vm.errorText {
                    Text("Error: \(err)").foregroundStyle(.red)
                }

                ForEach(cachedSorted) { it in
                    NavigationLink {
                        GSVGameDetailView(
                            gameId: it.id,
                            titleText: "\(it.sport) • \(headlineForGame(it))"
                        )
                    } label: {
                        GameRow(it: it, headline: headlineForGame(it))
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
            .onChange(of: vm.items) { _, new in
                cachedSorted = new.sorted { l, r in
                    let ld = l.dateAsDate ?? .distantPast
                    let rd = r.dateAsDate ?? .distantPast
                    if ld != rd { return ld > rd }
                    return l.id > r.id
                }
            }
        }
        .navigationTitle("\(sportDisplayName)")
        .task {
            guard !didInitialLoad else { return }
            didInitialLoad = true
            await reload()
        }
        .onChange(of: selectedYear) { _, _ in
            Task { await reload() }
        }
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

// Small subviews

private struct YearBar: View {
    let title: String
    let years: [Int]
    @Binding var selectedYear: Int
    let onThisYear: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title).font(.headline)
                Spacer()
                Button {
                    onThisYear()
                } label: {
                    Label("This Year", systemImage: "calendar")
                }
                .buttonStyle(.bordered)
            }
            YearChips(years: years, selected: $selectedYear)
        }
    }
}

private struct GameRow: View {
    let it: GSVSchedule
    let headline: String
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(headline).font(.headline)
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
}
