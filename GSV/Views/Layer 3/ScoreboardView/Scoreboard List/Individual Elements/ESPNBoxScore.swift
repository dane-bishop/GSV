
import SwiftUI

struct ESPNBoxScore: View {
    
    // Intake a sports event, and home team and away team
    
    var sportsEvent: SportsEvent
    
    var body: some View {
        
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            let fontScale = width / 200
            
            
            VStack(spacing: height * 0.02) {
                
                // GSV
                Text("GSV")
                    .font(.system(size: 10 * fontScale, weight: .bold))
                    .foregroundStyle(Color.gray)
                
                
                
                // Game Clock
                Text("1:27 - 3rd")
                    .font(.system(size: 10 * fontScale, weight: .bold))
                    .foregroundStyle(Color.red)
                
                
                // Quarter Headers
                HStack(spacing: width * 0.05) {
                    
                    VStack{
                        Text("").frame(width: width * 0.107)
                    }
                    VStack{
                        Text("").frame(width: width * 0.107)
                    }
                    
                    // Spacer().frame(width: width * 0.25)
                    
                    // Quarter labels
                    ForEach(["1", "2", "3", "4", "T"], id: \.self) { quarter in
                        
                        VStack(spacing: 0) {
                            
                            Text(quarter)
                                .font(.system(size: 10 * fontScale, weight: .bold))
                                .foregroundStyle(Color.black)
                        }.frame(width: width * 0.07)
                        
                        
                        
                        
                        
                        
                    }
                    
                }
                
                
                
                
                
                
                
                // Scores HStack
                HStack(spacing: width * 0.05) {
                    
                    
                    // Team logos
                    // Team names
                    VStack(alignment: .leading, spacing: height * 0.01) {
                        Image("\(sportsEvent.homeTeam) Logo").resizable().aspectRatio(contentMode: .fit).frame(height: height * 0.17)
                            
                        Image("\(sportsEvent.awayTeam) Logo").resizable().aspectRatio(contentMode: .fit).frame(height: height * 0.17)
                    }

                    // Team names
                    VStack(alignment: .leading, spacing: height * 0.01) {
                        Text("\(sportsEvent.homeTeamAbbr)")
                        Text("\(sportsEvent.awayTeamAbbr)")
                    }
                    .font(.system(size: 10 * fontScale, weight: .bold))
                    .foregroundStyle(Color.black.opacity(0.8))
                    
                    
                    
                    
                    
                    // Scores for each quarter
                    ForEach(["1", "2", "3", "4", "T"], id: \.self) { quarter in
                        
                        
                        VStack(spacing: height * 0.01) {
    
                            // Scores
                            Group {
                                if quarter == "1" {
                                    Text("7")
                                    Text("0")
                                }
                                else if quarter == "2" {
                                    Text("6")
                                    Text("14")
                                }
                                else if quarter == "3" {
                                    Text("7")
                                    Text("3")
                                }
                                else if quarter == "4" {
                                    Text("0")
                                    Text("0")
                                }
                                else if quarter == "T" {
                                    Text("20").foregroundStyle(Color.black.opacity(0.9))
                                    Text("17").foregroundStyle(Color.black.opacity(0.9))
                                }
                            }
                            .font(.system(size: 10 * fontScale, weight: .bold))
                            .foregroundStyle(Color.black.opacity(0.35))
                            .frame(width: width * 0.07)
                            
                            
                            
                            
                        }
                        
                    }
                    
                }
                
                // Divider()
                    // .background(Color.gray.opacity(0.6))
                
            }
            .frame(width: width, height: height)
     
        }
        .aspectRatio(2.5, contentMode: .fit)
  
    }
}

#Preview {
    ESPNBoxScore(sportsEvent: SportsEvent(homeTeam: "Affton", awayTeam: "Alton Marquette", homeTeamAbbr: "AHS", awayTeamAbbr: "AMHS", sport: "basketball", date: "Feb 23, 2025", time: "10:00 AM"))
}
