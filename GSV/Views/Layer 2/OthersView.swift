
import SwiftUI

struct OthersView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: StandingsView()) {
                    Label("Standings", systemImage: "list.number")
                }
                        
                NavigationLink(destination: StatsLeadersView()) {
                    Label("Stats Leaders", systemImage: "chart.bar.fill")
                }
                        
                NavigationLink(destination: HighlightsView()) {
                    Label("Highlights", systemImage: "play.rectangle.fill")
                }
                
                
                NavigationLink(destination: GSVPlayersView()) {
                    Label("Players", systemImage: "person.3")
                }
                
                
                
                
                
            }
            .navigationTitle("More Options")
        }
    }
}

#Preview {
    OthersView()
}
