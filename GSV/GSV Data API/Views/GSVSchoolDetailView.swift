//
//  GSVSchoolDetailView.swift
//  GSV
//
//  Created by Melanie Bishop on 8/25/25.
//

import Foundation
import SwiftUI

struct GSVSchoolDetailView: View {
    @EnvironmentObject var favs: FavoritesStore     // ← use API-side favorites
    let school: School                               // you can keep your local School for images/name
    @StateObject private var headerVM = GSVSchoolHeaderVM()

    private var externalId: Int? {
        GSVSchoolMapper.externalId(for: school)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Logo
                Image(school.imageName)
                    .resizable().scaledToFit()
                    .frame(maxWidth: 200, maxHeight: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                // Title + Favorite (API-backed)
                HStack {
                    Text(school.schoolFullName)
                        .font(.largeTitle).fontWeight(.semibold)

                    if let x = externalId {
                        StarButton(isOn: favs.isFavorite(x)) { favs.toggle(x) }
                    }
                }

                Divider()

                // Remote header (location / url) when we have a mapping
                if let x = externalId {
                    if let g = headerVM.gsv {
                        VStack(spacing: 4) {
                            if let loc = g.location, !loc.isEmpty {
                                Label(loc, systemImage: "mappin.and.ellipse")
                            }
                            if let url = g.url, !url.isEmpty, let u = URL(string: url) {
                                Link(destination: u) {
                                    Label(url, systemImage: "link").foregroundStyle(.blue)
                                }
                            }
                        }
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    } else if let err = headerVM.errorText {
                        Text("Info failed to load: \(err)")
                            .font(.footnote).foregroundStyle(.red)
                    } else {
                        ProgressView().frame(maxWidth: .infinity, alignment: .leading)
                    }
                } else {
                    Text("No GSV mapping for this school yet.")
                        .font(.footnote).foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                // School picture (your original)
                Image(school.schoolFullName)
                    .resizable().scaledToFit()
                    .frame(maxWidth: 300, maxHeight: 300)
                    .shadow(color: .gray.opacity(0.6), radius: 10, x: 0, y: 8)

                // Bio placeholder
                Text("School Bio...").frame(maxWidth: .infinity, alignment: .leading)

                Divider()

                // Sports list → GSV schedules
                VStack(alignment: .leading, spacing: 8) {
                    Text("School Sports:").font(.headline)
                    ForEach(school.schoolSports, id: \.self) { sport in
                        NavigationLink {
                            // Uses the API-only sport schedules view we made
                            GSVSchoolSportView(
                                schoolDisplayName: school.schoolFullName,
                                externalId: externalId ?? -1,     // pass a valid int
                                sportDisplayName: sport.displayName
                            )
                        } label: {
                            HStack {
                                sport.image
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text(" \(sport.displayName)")
                                    .foregroundStyle(.blue)
                                    .padding(.leading, 15)
                            }
                        }
                        .disabled(externalId == nil)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            if let x = externalId { await headerVM.load(externalId: x) }
        }
    }
}

