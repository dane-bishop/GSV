//
//  Headers.swift
//  GSV
//
//  Created by Melanie Bishop on 8/25/25.
//

import Foundation


@MainActor
final class GSVSchoolHeaderVM: ObservableObject {
    @Published var gsv: GSVSchool?
    @Published var errorText: String?

    func load(externalId: Int) async {
        do {
            gsv = try await APIClient.shared.fetchSchool(id: externalId) // add method below if missing
        } catch {
            errorText = error.localizedDescription
        }
    }
}

