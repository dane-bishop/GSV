//
//  ScheduleVM.swift
//  GSV
//
//  Created by Melanie Bishop on 8/24/25.
//

import Foundation

@MainActor
final class GSVScheduleVM: ObservableObject {
    @Published var q = ""
    @Published var items: [GSVSchedule] = []
    @Published var total = 0
    @Published var isLoading = false
    @Published var errorText: String?

    // optional filters
    @Published var schoolId: Int?
    @Published var sport: String = ""
    @Published var year: String = ""   // keep as string for a simple TextField

    private var offset = 0
    private let pageSize = 50
    private var loading = false

    func initialLoadIfNeeded() async {
        if items.isEmpty { await reload() }
    }

    func reload() async {
        offset = 0
        items = []
        await loadMore()
    }

    func loadMore() async {
        guard !loading else { return }
        loading = true; isLoading = true; defer { loading = false; isLoading = false }
        do {
            let qobj = APIClient.ScheduleQuery(
                schoolId: schoolId,
                sport: sport.isEmpty ? nil : sport,
                year: Int(year),
                dateFrom: nil,
                dateTo: nil,
                q: q.isEmpty ? nil : q,
                limit: pageSize,
                offset: offset
            )
            let page = try await APIClient.shared.fetchTeamSchedule(qobj)
            total = page.total
            items.append(contentsOf: page.items)
            offset += page.items.count
        } catch {
            errorText = error.localizedDescription
        }
    }
}
