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

    enum Field { case schoolId, sport, year }

    // Newest first (future at top, past at bottom)
    private var sortedItems: [GSVSchedule] {
        vm.items.sorted { lhs, rhs in
            let l = lhs.dateAsDate ?? .distantPast
            let r = rhs.dateAsDate ?? .distantPast
            if l != r { return l > r }  // newer first
            return lhs.id > rhs.id      // tie-breaker
        }
    }

    // Quick range helpers for currently loaded items
    private var minLoadedDate: Date? { sortedItems.last?.dateAsDate }
    private var maxLoadedDate: Date? { sortedItems.first?.dateAsDate }

    private func hasCoverage(for target: Date) -> Bool {
        guard let minD = minLoadedDate, let maxD = maxLoadedDate else { return false }
        return (minD <= target && target <= maxD)
    }

    private func anchorID(for target: Date) -> Int? {
        // exact match for day
        let cal = Calendar.current
        if let exact = sortedItems.first(where: {
            guard let d = $0.dateAsDate else { return false }
            return cal.isDate(d, inSameDayAs: target)
        }) { return exact.id }

        // otherwise, closest by absolute distance
        return sortedItems.min(by: {
            let d0 = $0.dateAsDate ?? .distantPast
            let d1 = $1.dateAsDate ?? .distantPast
            return abs(d0.timeIntervalSince(target)) < abs(d1.timeIntervalSince(target))
        })?.id
    }

    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                // Filters
                HStack {
                    TextField("School ID", text: Binding(
                        get: { vm.schoolId.map(String.init) ?? "" },
                        set: { vm.schoolId = Int($0) }
                    ))
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .schoolId)
                    .onChange(of: vm.schoolId) { _, _ in debouncedReload() }

                    TextField("Sport", text: $vm.sport)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .sport)
                        .onChange(of: vm.sport) { _, _ in debouncedReload() }

                    TextField("Year", text: $vm.year)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .year)
                        .onChange(of: vm.year) { _, _ in debouncedReload() }
                }
                .padding(.horizontal)

                List {
                    if let err = vm.errorText {
                        Text("Error: \(err)").foregroundStyle(.red)
                    }

                    ForEach(sortedItems) { it in
                        NavigationLink {
                            GSVGameDetailView(
                                gameId: it.id,
                                titleText: "\(it.sport) • \(it.opponent)"
                            )
                        } label: {
                            let names = homeAwayNames(for: it)
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("\(names.home) vs \(names.away)")
                                        .font(.headline)
                                    Spacer()
                                    if let s = it.score, !s.isEmpty {
                                        Text(s).font(.headline)
                                    }
                                }
                                HStack(spacing: 8) {
                                    Text(it.date ?? "—")
                                    Text("•")
                                    Text(it.sport)
                                }
                                .font(.caption)
                                .foregroundStyle(.secondary)

                                HStack(spacing: 12) {
                                    if let loc = it.location, !loc.isEmpty { Text(loc.capitalized) }
                                    if let r = it.result, !r.isEmpty { Text(r) }
                                    if let n = it.notes, !n.isEmpty { Text(n).font(.caption2) }
                                }
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            }
                        }
                        .id(it.id) // for programmatic scroll
                    }

                    // Footer pagination
                    if vm.items.count < vm.total && !vm.items.isEmpty {
                        HStack { Spacer(); ProgressView(); Spacer() }
                            .onAppear { Task { await vm.loadMore() } }
                    }
                }
                .onChange(of: vm.items) { _, _ in
                    // After any load, first time we have coverage, jump to today
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
                        Task {
                            await ensureCoverageAndScroll(to: Date(), proxy: proxy)
                        }
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
                // proactively ensure coverage once on first load
                await ensureCoverageAndScroll(to: Date(), proxy: proxy, jumpIfCovered: false)
            }
            .refreshable {
                didScrollToToday = false
                await vm.reload()
            }
        }
    }

    // MARK: - Coverage + Scroll

    private func ensureCoverageAndScroll(to rawDate: Date,
                                         proxy: ScrollViewProxy,
                                         jumpIfCovered: Bool = true) async {
        if isEnsuringCoverage { return }
        isEnsuringCoverage = true
        defer { isEnsuringCoverage = false }

        let target = Calendar.current.startOfDay(for: rawDate)
        var attempts = 0
        let maxAttempts = 12 // ~12 pages max safety

        // Load more pages until the loaded min/max date range contains target
        while !hasCoverage(for: target),
              vm.items.count < vm.total,
              attempts < maxAttempts {
            await vm.loadMore()
            attempts += 1
        }

        // Scroll if covered
        if hasCoverage(for: target), let anchor = anchorID(for: target) {
            withAnimation(.easeInOut) { proxy.scrollTo(anchor, anchor: .center) }
            didScrollToToday = true
        } else if jumpIfCovered {
            // If not covered (e.g., no games near today), still scroll to closest
            if let anchor = anchorID(for: target) {
                withAnimation(.easeInOut) { proxy.scrollTo(anchor, anchor: .center) }
            }
        }
    }

    // MARK: - Misc

    private func debouncedReload() {
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000) // 300ms
            if !Task.isCancelled {
                didScrollToToday = false
                await vm.reload()
            }
        }
    }

    private func homeAwayNames(for it: GSVSchedule) -> (home: String, away: String) {
        let loc = (it.location ?? "").lowercased()
        let our = it.school_name ?? "School \(it.school_id)"
        let opp = it.opponent
        if ["home","h","host","vs","v"].contains(loc) { return (home: our, away: opp) }
        if ["away","a","@"].contains(loc)               { return (home: opp, away: our) }
        return (home: our, away: opp) // neutral/unknown
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


