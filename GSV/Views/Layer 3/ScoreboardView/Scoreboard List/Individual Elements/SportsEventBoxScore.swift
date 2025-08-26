//
//  SportsEventBoxScore.swift
//  MSPN
//
//  Created by Melanie Bishop on 5/11/25.
//

import SwiftUI

struct SportsEventBoxScore: View {
    var sportsEvent: SportsEvent
    var body: some View {
        ScrollView {
            // Entire Screen Stack
            VStack {
                
                // Header
                BoxScoreHeader(sportsEvent: sportsEvent).padding(8)
               
                
                
                Divider()
                
                //
                
                // Body - Game Leaders View
                HStack(spacing: 10){
                    GameLeadersView(homePassingLeader: gamePlayers[0], homeRushingLeader: gamePlayers[1], homeReceivingLeader: gamePlayers[2], awayPassingLeader: gamePlayers[3], awayRushingLeader: gamePlayers[4], awayReceivingLeader: gamePlayers[5], homeTeam: schoolData[0], awayTeam: schoolData[1])
                }.padding(10).scaleEffect(0.9)
                
                
                
                
            }
        }
        
    }
}

#Preview {
    SportsEventBoxScore(sportsEvent: SportsEvent(homeTeam: "Affton", awayTeam: "Alton Marquette", homeTeamAbbr: "AHS", awayTeamAbbr: "AHS", sport: "basketball", date: "Feb 23, 2025", time: "10:00 AM"))
}
