//
//  YearChips.swift
//  GSV
//
//  Created by Melanie Bishop on 8/25/25.
//

import Foundation

import SwiftUI

private struct YearChip: View {
    let year: Int
    let isSelected: Bool

    var body: some View {
        Text(verbatim: String(year))   // ← no numeric formatting ever
            .font(.body)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(isSelected ? Color.accentColor.opacity(0.15)
                                   : Color.secondary.opacity(0.08))
            .foregroundColor(isSelected ? .accentColor : .primary)
            .clipShape(Capsule())
    }
}

struct YearChips: View {
    let years: [Int]
    @Binding var selected: Int

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(years, id: \.self) { y in
                    let isSel = (y == selected)        // break up expression
                    Button(action: { selected = y }) {
                        YearChip(year: y, isSelected: isSel)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
        .animation(.default, value: selected)
    }
}

