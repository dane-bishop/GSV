//
//  GSVSchoolMapper.swift
//  GSV
//
//  Created by Melanie Bishop on 8/25/25.
//

import Foundation

enum GSVSchoolMapper {
    /// Fill this gradually. Key however you like; below uses your `schoolFullName`.
    static let byFullName: [String: Int] = [
        "Fort Zumwalt North": 63,
        // "Jackson": 69,
        // ...
    ]

    static func externalId(for school: School) -> Int? {
        byFullName[school.schoolFullName]
    }
}
