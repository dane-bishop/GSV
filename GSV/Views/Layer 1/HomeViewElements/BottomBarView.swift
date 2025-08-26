
import SwiftUI

// Bottom Tab Bar
struct BottomBarView : View {
    
    // Active selected tab
    @State private var selectedTab: TabViewSelection = .home
    
    // Track the media view selections
    @State private var mediaSelectedView: MediaSelection = .videos
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            HomeButtonView()
                .tabItem{
                    Label("Home", systemImage: "house.fill")
                }
                .tag(TabViewSelection.home)
            
            
            SchoolsView()
                .tabItem {
                    Label("Schools", systemImage: "building.2.fill")
                }
                .tag(TabViewSelection.schools)
            
            ScoreBoardView()
                .tabItem {
                    Label("Scores", systemImage: "sportscourt.fill")
                }
                .tag(TabViewSelection.scores)
            
            
            
            MediaView(selectedView: $mediaSelectedView)
                .tabItem {
                    Label("Media", systemImage: "play.rectangle.fill")
                }
                .tag(TabViewSelection.media)
            
            
            OthersView()
                .tabItem {
                    Label("Others", systemImage: "list.bullet")
                }
                .tag(TabViewSelection.others)
            
            
        }.overlay(
            VStack {
                Spacer()
                Divider()
                    .padding(.bottom, 90) //
            }
        )
        
        .edgesIgnoringSafeArea(.bottom)
       
        
    }
}

#Preview {
    BottomBarView()
}
