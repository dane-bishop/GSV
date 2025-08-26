//
//  SchoolsVM.swift
//  GSV
//
//  Created by Melanie Bishop on 8/24/25.
//

import Foundation


@MainActor
final class GSVSchoolsVM: ObservableObject {
    @Published var q = ""
    @Published var schools: [GSVSchool] = []
    @Published var total = 0
    @Published var isLoading = false
    @Published var errorText: String?

    private var offset = 0
    private let pageSize = 50
    private var loading = false

    func initialLoadIfNeeded() async {
        if schools.isEmpty { await reload() }
    }

    func reload() async {
        offset = 0
        schools = []
        await loadMore()
    }

    func loadMore() async {
        guard !loading else { return }
        loading = true; isLoading = true; defer { loading = false; isLoading = false }
        do {
            let page = try await APIClient.shared.fetchSchools(q: q, limit: pageSize, offset: offset)
            total = page.total
            schools.append(contentsOf: page.items)
            offset += page.items.count
        } catch {
            errorText = error.localizedDescription
        }
    }
}
