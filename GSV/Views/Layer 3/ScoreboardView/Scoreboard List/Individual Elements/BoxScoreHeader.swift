

import SwiftUI

struct BoxScoreHeader: View {
    
    
    var sportsEvent: SportsEvent
    
    
    var body: some View {
        
        
        // Replace score with actual sports event score
        // Replace ESPN picture with actual design
        
        
        
        // Top Layer - Teams and Score
        // --------------------------------------
        
        
        ZStack{
            
            HStack {
                Spacer()
                ESPNBoxScore(sportsEvent: sportsEvent).scaleEffect(0.40)
                Spacer()
            }
            
            
            // Overlay Home and Away Team Info
            HStack (spacing: 0) {
                
                
                // Home Team Name
                VStack{
                    
                    Text(sportsEvent.homeTeam).font(.system(size: 12, weight: .bold)).lineLimit(1) // Ensures it stays on a single line
                        .minimumScaleFactor(0.5)
                    
                    Text(sportsEvent.homeTeamAbbr).font(.system(size: 10, weight: .heavy)).foregroundColor(Color.gray)
                }.frame(maxWidth: 50)
                
                
                // Home Team Logo
                Image(sportsEvent.homeTeamImageName).resizable().aspectRatio(contentMode: .fit).frame(width: 40, height: 40, alignment: .bottom)
                
                // Home Team Score
                Text("45").font(.system(size: 18, weight: .heavy)).lineLimit(1) // Ensures it stays on a single line
                    .minimumScaleFactor(0.5)
                
                
                Spacer()
                
                
                
                // Away Team Score
                Text("53").font(.system(size: 18, weight: .heavy)).lineLimit(1) // Ensures it stays on a single line
                    .minimumScaleFactor(0.5)
                
                // Away Team Logo
                // Away Team Logo
                Image(sportsEvent.awayTeamImageName).resizable().aspectRatio(contentMode: .fit).frame(width: 40, height: 40, alignment: .bottom)
                
                // Away Team Name
                VStack{
                    
                    Text(sportsEvent.awayTeam).font(.system(size: 12, weight: .bold)).lineLimit(1) // Ensures it stays on a single line
                        .minimumScaleFactor(0.5)
                    // Home Team Name right under in grey
                    Text(sportsEvent.awayTeamAbbr).font(.system(size: 10, weight: .heavy)).foregroundColor(Color.gray)
                    
                    
                }.frame(maxWidth: 50)
            }
        }
        
        
    }
}


 #Preview {
 BoxScoreHeader(sportsEvent: SportsEvent(homeTeam: "Affton", awayTeam: "Alton Marquette", homeTeamAbbr: "AHS", awayTeamAbbr: "AMHS", sport: "basketball", date: "Feb 23, 2025", time: "10:00 AM"))
 }
 

