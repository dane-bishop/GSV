//
//  GSVSchoolDetailViewRemote.swift
//  GSV
//
//  Created by Melanie Bishop on 8/27/25.
//

import Foundation
import SwiftUI

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
        return (max(now-17, 2008)...now).reversed()
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
