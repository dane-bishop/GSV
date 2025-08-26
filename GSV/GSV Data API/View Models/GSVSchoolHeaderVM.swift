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

struct GSVSchoolDetailViewRemote: View {
    @EnvironmentObject var favs: FavoritesStore
    let externalId: Int
    let displayName: String

    @StateObject private var headerVM = GSVSchoolHeaderVM()
    @StateObject private var sportsVM = GSVSchoolSportsVM()

    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())

    // Show current + previous 9 years
    private var years: [Int] {
        let now = Calendar.current.component(.year, from: Date())
        return (max(now-9, 2010)...now).reversed()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title + favorite
                HStack {
                    Text(displayName).font(.largeTitle).fontWeight(.semibold)
                    Spacer()
                    StarButton(isOn: favs.isFavorite(externalId)) { favs.toggle(externalId) }
                }

                // Remote header
                Group {
                    if let s = headerVM.gsv {
                        VStack(alignment: .leading, spacing: 4) {
                            if let loc = s.location, !loc.isEmpty {
                                Label(loc, systemImage: "mappin.and.ellipse")
                            }
                            if let url = s.url, let u = URL(string: url), !url.isEmpty {
                                Link(destination: u) {
                                    Label(url, systemImage: "link")
                                        .foregroundStyle(.blue)
                                }
                            }
                        }
                        .font(.subheadline)
                    } else if let err = headerVM.errorText {
                        Text("Info failed to load: \(err)").font(.footnote).foregroundStyle(.red)
                    } else {
                        ProgressView()
                    }
                }

                Divider()

                // Year picker
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

                // Sports list for selected year
                if let err = sportsVM.errorText {
                    Text("Sports failed to load: \(err)").foregroundStyle(.red)
                } else if sportsVM.sports.isEmpty {
                    ContentUnavailableView("No schedules found", systemImage: "sportscourt")
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Sports").font(.headline)
                        ForEach(sportsVM.sports, id: \.self) { sport in
                            NavigationLink {
                                GSVSchoolSportView(
                                    schoolDisplayName: displayName,
                                    externalId: externalId,
                                    sportDisplayName: sport
                                )
                            } label: {
                                HStack {
                                    Image(systemName: "sportscourt")
                                    Text(sport).foregroundStyle(.blue)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await headerVM.load(externalId: externalId)
            await sportsVM.load(externalId: externalId, year: selectedYear)
        }
        .onChange(of: selectedYear) { _, newYear in
            Task { await sportsVM.load(externalId: externalId, year: newYear) }
        }
    }
}
