
import Foundation

import SwiftUI

@MainActor
final class GSVBootstrapVM: ObservableObject {
    @Published var players: [GSVPlayer] = []
    @Published var error: String?

    /// Call this once on app start (e.g., in .task) to log in and pull initial data.
    func bootstrap() async {
        do {
            

            // Pull first page of players
            let page = try await APIClient.shared.fetchPlayers(q: nil, limit: 50, offset: 0)
            players = page.items
        } catch {
            self.error = error.localizedDescription
        }
    }
}
