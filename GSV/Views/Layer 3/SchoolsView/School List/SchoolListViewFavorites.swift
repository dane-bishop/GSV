

import SwiftUI

struct SchoolListViewFavorites: View {
    
    @Environment(ModelData.self) var modelData
    @State private var showFavoritesOnly = true
    
    var filteredSchools: [School] {
        modelData.schools.filter { school in
            !school.isClosed && (!showFavoritesOnly || school.isFavorite)
        }
    }
    
    
    var body: some View {
        NavigationSplitView {
            
            List {
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites Only")
                }
                
                ForEach(filteredSchools) { school in
                    NavigationLink { GSVSchoolDetailView(school: school) } label: {
                        SchoolRow(school: school)
                    }
                    
                }
            }
            // .animation(.default, value: filteredSchools)
            .navigationTitle("Schools")
        } detail: {
            Text("Select a School")
        }
    }
}

#Preview {
    SchoolListViewFavorites().environment(ModelData())
}
