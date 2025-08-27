//
//  GSVSchoolHeaderVM.swift
//  GSV
//
//  Created by Melanie Bishop on 8/25/25.
//

import Foundation

import SwiftUI


@MainActor
final class GSVSchoolSportsVM: ObservableObject {
    @Published var sports: [String] = []
    @Published var errorText: String?

    func load(externalId: Int, year: Int) async {
        do {
            var q = APIClient.ScheduleQuery(
                schoolId: externalId, sport: nil, year: year,
                dateFrom: nil, dateTo: nil, q: nil,
                sort: "date", order: "desc", limit: 200, offset: 0
            )
            var seen = Set<String>()
            var out: [String] = []
            var fetched = 0

            repeat {
                let page = try await APIClient.shared.fetchTeamSchedule(q)
                for it in page.items where seen.insert(it.sport).inserted {
                    out.append(it.sport)
                }
                fetched += page.items.count
                if fetched >= page.total || page.items.isEmpty { break }
                q.offset += page.items.count
            } while true

            sports = out.sorted()
            errorText = nil
        } catch {
            errorText = error.localizedDescription
        }
    }
}

