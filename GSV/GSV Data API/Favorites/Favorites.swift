//
//  Favorites.swift
//  GSV
//
//  Created by Melanie Bishop on 8/25/25.
//

import Foundation

import SwiftUI

@MainActor
final class FavoritesStore: ObservableObject {
    @AppStorage("fav_school_ids") private var favCSV: String = ""
    @Published private(set) var ids: Set<Int> = []

    init() { ids = Self.parse(favCSV) }

    private static func parse(_ csv: String) -> Set<Int> {
        Set(csv.split(separator: ",").compactMap { Int($0) })
    }
    private func persist() {
        favCSV = ids.map(String.init).sorted().joined(separator: ",")
        objectWillChange.send()
    }

    func isFavorite(_ id: Int) -> Bool { ids.contains(id) }
    func toggle(_ id: Int) {
        if ids.contains(id) { ids.remove(id) } else { ids.insert(id) }
        persist()
    }
}

struct StarButton: View {
    let isOn: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: isOn ? "star.fill" : "star")
                .foregroundStyle(isOn ? .yellow : .secondary)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isOn ? "Remove Favorite" : "Add Favorite")
    }
}

