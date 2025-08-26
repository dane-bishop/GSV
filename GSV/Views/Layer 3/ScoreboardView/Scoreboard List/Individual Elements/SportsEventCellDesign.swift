
import SwiftUI

struct SportsEventCellDesign: View {
    
    var sportsEvent: SportsEvent
    
    var body: some View {
        NavigationLink(destination: SportsEventBoxScore(sportsEvent: sportsEvent)) {
            Image(sportsEvent.sport)
                .cornerRadius(8)
            
            
            
            VStack(alignment: .leading) {
                Text("\(sportsEvent.awayTeam) at \(sportsEvent.homeTeam)")
                Text("\(sportsEvent.date) at \(sportsEvent.time)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
            }
            .padding()
        }
    }
}

#Preview {
    SportsEventCellDesign(sportsEvent: SportsEvent(homeTeam: "Affton", awayTeam: "Alton", homeTeamAbbr: "AHS", awayTeamAbbr: "AHS", sport: "basketball", date: "Feb 23, 2025", time: "10:00 AM"))
}
