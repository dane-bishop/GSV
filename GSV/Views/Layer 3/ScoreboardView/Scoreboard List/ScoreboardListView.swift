


import SwiftUI



// struct for actual implementation of list with values
struct ScoreboardListView: View {
   
    var sportsEvents: [SportsEvent] = []
    
    
    var body: some View {
        
    
        NavigationView {
            
            
           
            List(liveData) { sportsEvent in
                SportsEventCellDesign(sportsEvent: sportsEvent)
            }
            .navigationTitle("Scoreboard")
        }
    }
}





// Create struct for in-depth game detail
// This will be the destination





#Preview {
    ScoreboardListView()
}
