//
//  GSVScheduleView.swift
//  GSV
//
//  Created by Melanie Bishop on 8/24/25.
//

import Foundation
import SwiftUI

struct GSVScheduleView: View {
    @StateObject private var vm = GSVScheduleVM()
    @State private var searchTask: Task<Void, Never>?
    @FocusState private var focusedField: Field?
    @State private var didScrollToToday = false
    @State private var isEnsuringCoverage = false
    @State private var cachedSorted: [GSVSchedule] = []   // ← cache

    enum Field { case schoolId, sport, year }

    // Quick range helpers for currently loaded items
    private var minLoadedDate: Date? { cachedSorted.last?.dateAsDate }
    private var maxLoadedDate: Date? { cachedSorted.first?.dateAsDate }

    private func hasCoverage(for target: Date) -> Bool {
        guard let minD = minLoadedDate, let maxD = maxLoadedDate else { return false }
        return (minD <= target && target <= maxD)
    }

    private func anchorID(for target: Date) -> Int? {
        // exact day match
        let cal = Calendar.current
        if let exact = cachedSorted.first(where: {
            guard let d = $0.dateAsDate else { return false }
            return cal.isDate(d, inSameDayAs: target)
        }) { return exact.id }

        // otherwise closest
        return cachedSorted.min(by: {
            let d0 = $0.dateAsDate ?? .distantPast
            let d1 = $1.dateAsDate ?? .distantPast
            return abs(d0.timeIntervalSince(target)) < abs(d1.timeIntervalSince(target))
        })?.id
    }

    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                FiltersBar(
                    schoolText: Binding(
                        get: { vm.schoolId.map(String.init) ?? "" },
                        set: { vm.schoolId = Int($0) }
                    ),
                    sport: $vm.sport,
                    year: $vm.year
                )
                .focused($focusedField, equals: .schoolId)
                .padding(.horizontal)
                .onChange(of: vm.schoolId) { _, _ in debouncedReload() }
                .onChange(of: vm.sport)    { _, _ in debouncedReload() }
                .onChange(of: vm.year)     { _, _ in debouncedReload() }

                List {
                    if let err = vm.errorText {
                        Text("Error: \(err)").foregroundStyle(.red)
                    }

                    ForEach(cachedSorted) { it in
                        NavigationLink {
                            GSVGameDetailView(
                                gameId: it.id,
                                titleText: "\(it.sport) • \(it.opponent)"
                            )
                        } label: {
                            ScheduleRowView(item: it)
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
                    // cache once when data changes (newest first)
                    cachedSorted = new.sorted { lhs, rhs in
                        let l = lhs.dateAsDate ?? .distantPast
                        let r = rhs.dateAsDate ?? .distantPast
                        if l != r { return l > r }
                        return lhs.id > rhs.id
                    }

                    // auto-jump to today when we first have coverage
                    Task {
                        let today = Calendar.current.startOfDay(for: Date())
                        if !didScrollToToday, hasCoverage(for: today), let anchor = anchorID(for: today) {
                            withAnimation(.easeInOut) { proxy.scrollTo(anchor, anchor: .center) }
                            didScrollToToday = true
                        }
                    }
                }
            }
            .navigationTitle("Team Schedule")
            .searchable(text: $vm.q)
            .onChange(of: vm.q) { _, _ in debouncedReload() }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Today") {
                        Task { await ensureCoverageAndScroll(to: Date(), proxy: proxy) }
                    }
                    Button("Reset") {
                        didScrollToToday = false
                        vm.q = ""
                        vm.schoolId = nil
                        vm.sport = ""
                        vm.year = ""
                        Task { await vm.reload() }
                    }
                }
            }
            .task {
                didScrollToToday = false
                await vm.initialLoadIfNeeded()
                await ensureCoverageAndScroll(to: Date(), proxy: proxy, jumpIfCovered: false)
            }
            .refreshable {
                didScrollToToday = false
                await vm.reload()
            }
        }
    }

    private func ensureCoverageAndScroll(to rawDate: Date,
                                         proxy: ScrollViewProxy,
                                         jumpIfCovered: Bool = true) async {
        if isEnsuringCoverage { return }
        isEnsuringCoverage = true
        defer { isEnsuringCoverage = false }

        let target = Calendar.current.startOfDay(for: rawDate)
        var attempts = 0
        let maxAttempts = 12

        while !hasCoverage(for: target),
              vm.items.count < vm.total,
              attempts < maxAttempts {
            await vm.loadMore()
            attempts += 1
        }

        if hasCoverage(for: target), let anchor = anchorID(for: target) {
            withAnimation(.easeInOut) { proxy.scrollTo(anchor, anchor: .center) }
            didScrollToToday = true
        } else if jumpIfCovered, let anchor = anchorID(for: target) {
            withAnimation(.easeInOut) { proxy.scrollTo(anchor, anchor: .center) }
        }
    }

    private func debouncedReload() {
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            if !Task.isCancelled {
                didScrollToToday = false
                await vm.reload()
            }
        }
    }
}

// MARK: Small subviews (reduce body complexity)

private struct FiltersBar: View {
    @Binding var schoolText: String
    @Binding var sport: String
    @Binding var year: String

    var body: some View {
        HStack {
            TextField("School ID", text: $schoolText)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
            TextField("Sport", text: $sport)
                .textFieldStyle(.roundedBorder)
            TextField("Year", text: $year)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
        }
    }
}

private struct ScheduleRowView: View {
    let item: GSVSchedule
    var body: some View {
        let names = homeAwayNames(for: item)
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("\(names.home) vs \(names.away)")
                    .font(.headline)
                Spacer()
                if let s = item.score, !s.isEmpty {
                    Text(s).font(.headline)
                }
            }
            HStack(spacing: 8) {
                Text(item.date ?? "—")
                Text("•")
                Text(item.sport)
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                if let loc = item.location, !loc.isEmpty { Text(loc.capitalized) }
                if let r = item.result, !r.isEmpty { Text(r) }
                if let n = item.notes, !n.isEmpty { Text(n).font(.caption2) }
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
    }

    private func homeAwayNames(for it: GSVSchedule) -> (home: String, away: String) {
        let loc = (it.location ?? "").lowercased()
        let our = it.school_name ?? "School \(it.school_id)"
        let opp = it.opponent
        if ["home","h","host","vs","v"].contains(loc) { return (home: our, away: opp) }
        if ["away","a","@"].contains(loc)               { return (home: opp, away: our) }
        return (home: our, away: opp)
    }
}





extension GSVSchedule {
    /// Parses `date` ("yyyy-MM-dd") into a Date for sorting.
    var dateAsDate: Date? {
        guard let s = date, !s.isEmpty else { return nil }
        struct DF {
            static let f: DateFormatter = {
                let f = DateFormatter()
                f.calendar = Calendar(identifier: .iso8601)
                f.locale = Locale(identifier: "en_US_POSIX")
                f.timeZone = TimeZone(secondsFromGMT: 0)
                f.dateFormat = "yyyy-MM-dd"
                return f
            }()
        }
        return DF.f.date(from: s)
    }
}


