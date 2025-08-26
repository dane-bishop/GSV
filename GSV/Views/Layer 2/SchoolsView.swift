

import SwiftUI

struct SchoolsView: View {
    @StateObject private var favs = FavoritesStore()
    var body: some View {
        GSVSchoolsListView()
            .environmentObject(favs)
    }
}

#Preview {
    SchoolsView()
}
