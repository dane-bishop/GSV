


import SwiftUI



struct GameLeadersView: View {
    
    var homePassingLeader: OffenseFootballPlayer
    var homeRushingLeader: OffenseFootballPlayer
    var homeReceivingLeader: OffenseFootballPlayer
    
    var awayPassingLeader: OffenseFootballPlayer
    var awayRushingLeader: OffenseFootballPlayer
    var awayReceivingLeader: OffenseFootballPlayer
    
    var homeTeam: School
    var awayTeam: School
    
    var body: some View {
        
        
    

        
        
        VStack(alignment: .leading, spacing: 0) {
            
            // TITLE
            Text("Game Leaders").font(.system(size: 15, weight: .heavy, design: .default)).padding(.bottom, 18)
            
            
            // TOP LINE
            Line().stroke(style: StrokeStyle(lineWidth: 1.2))
                .frame(width: 310, height: 1.2)
                  .foregroundColor(Color(hue: 0, saturation: 0, brightness: 0.87) )

            
            // PASSING YARDS SECTION
            VStack(alignment: .center) {
                Text("Passing Yards").font(.system(size: 14.5, weight: .semibold, design: .rounded)).padding(.top, 12)

                
                
                // PASSING YARDS HSTACK
                HStack(alignment: .top) {
                    VStack(alignment: .center) {
                        
                        // HOME PASSING LEADER IMAGE
                        Image("\(homePassingLeader.firstName) \(homePassingLeader.lastName)").resizable().aspectRatio(contentMode: .fit).frame(width: 45, height: 45, alignment: .bottom).clipShape(Circle()).overlay(Circle().stroke(Color(hue: 0.0, saturation: 0.0, brightness: 0.9), lineWidth: 1.5))
                        
                        // HOME TEAM ABBR
                        Text("\(homeTeam.schoolAbbr)").font(.system(size: 10, weight: .heavy)).foregroundColor(Color.gray)
                    }
                    VStack(alignment: .trailing) {
                        
                        
                        // HOME PASSING LEADER NAME
                        Text("\(homePassingLeader.firstName) \(homePassingLeader.lastName)  ").font(.system(size: 14)).bold()
                        
                        // HOME PASSING STATS
                        Text("\(homePassingLeader.passingCompletions)-\(homePassingLeader.passingAttempts),").font(.system(size: 12)).foregroundColor(Color.gray).bold()
                        Text("\(homePassingLeader.passingYards) YDS, \(homePassingLeader.passingTouchdowns) TD").font(.system(size: 12)).foregroundColor(Color.gray).bold()
                        Text("\(homePassingLeader.interceptions) INT").font(.system(size: 12)).foregroundColor(Color.gray).bold()
                    }.frame(width: 90)
                    
                    Divider()
                    
                    // AWAY PASSING LEADER NAME
                    VStack(alignment: .leading) {
                        Text("\(awayPassingLeader.firstName) \(awayPassingLeader.lastName)").font(.system(size: 14)).bold()
                        
                        // AWAY PASSING STATS
                        Text("\(awayPassingLeader.passingCompletions)-\(awayPassingLeader.passingAttempts),").font(.system(size: 12)).foregroundColor(Color.gray).bold()
                        Text("\(awayPassingLeader.passingYards) YDS, \(awayPassingLeader.passingTouchdowns) TD,").font(.system(size: 12)).foregroundColor(Color.gray).bold()
                        Text("\(awayPassingLeader.interceptions) INT").font(.system(size: 12)).foregroundColor(Color.gray).bold()
                    }.frame(width: 90)
                    
                    VStack(alignment: .center) {
                        
                        // AWAY PASSING LEADER IMAGE
                        Image("\(awayPassingLeader.firstName) \(awayPassingLeader.lastName)").resizable().aspectRatio(contentMode: .fit).frame(width: 45, height: 45, alignment: .bottom).clipShape(Circle()).overlay(Circle().stroke(Color(hue: 0.0, saturation: 0.0, brightness: 0.9), lineWidth: 1.5))
                        
                        // AWAY TEAM ABBR
                        Text("\(awayTeam.schoolAbbr)").font(.system(size: 10, weight: .heavy)).foregroundColor(Color.gray)
                    }
                }.padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))

            
                // DIVIDING HORIZONTAL LINE
                Line().stroke(style: StrokeStyle(lineWidth: 1, dash: [1]))
                      .frame(width: 310, height: 1)
                      .foregroundColor(Color(hue: 0, saturation: 0, brightness: 0.85) )
                
                
                
                Text("Rushing Yards").font(.system(size: 14, weight: .semibold, design: .rounded)).padding(.top, 5)
                
                
                // RUSHING YARDS HSTACK
                HStack(alignment: .top) {
                    VStack(alignment: .center) {
                        
                        // HOME RUSHING LEADER IMAGE
                        Image("\(homeRushingLeader.firstName) \(homeRushingLeader.lastName)").resizable().aspectRatio(contentMode: .fit).frame(width: 45, height: 45, alignment: .bottom).clipShape(Circle()).overlay(Circle().stroke(Color(hue: 0.0, saturation: 0.0, brightness: 0.9), lineWidth: 1.5))
                        
                        // HOME TEAM ABBR
                        Text("\(homeTeam.schoolAbbr)").font(.system(size: 10, weight: .heavy)).foregroundColor(Color.gray)
                    }
                    VStack(alignment: .trailing) {
                        
                        // HOME RUSHING LEADER NAME
                        Text("\(homeRushingLeader.firstName) \(homeRushingLeader.lastName)  ").font(.system(size: 13)).bold()
                        
                        // HOME RUSHING STATS
                        Text("\(homeRushingLeader.carries) CAR,").font(.system(size: 12)).foregroundColor(Color.gray).bold()
                        Text("\(homeRushingLeader.rushingYards) YDS, \(homeRushingLeader.rushingTouchdowns) TD").font(.system(size: 12)).foregroundColor(Color.gray).bold()
                    }.frame(width: 90)
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        
                        // AWAY RUSHING LEADER NAME
                        Text("\(awayRushingLeader.firstName) \(awayRushingLeader.lastName)  ").font(.system(size: 13)).bold()
                        
                        // AWAY RUSHING STATS
                        Text("\(awayRushingLeader.carries) CAR,").font(.system(size: 12)).foregroundColor(Color.gray).bold()
                        Text("\(awayRushingLeader.rushingYards) YDS, \(awayRushingLeader.rushingTouchdowns) TD").font(.system(size: 12)).foregroundColor(Color.gray).bold()
                    }.frame(width: 90)
                    VStack(alignment: .center) {
                        
                        // AWAY RUSHING LEADER IMAGE
                        Image("\(awayRushingLeader.firstName) \(awayRushingLeader.lastName)").resizable().aspectRatio(contentMode: .fit).frame(width: 45, height: 45, alignment: .bottom).clipShape(Circle()).overlay(Circle().stroke(Color(hue: 0.0, saturation: 0.0, brightness: 0.9), lineWidth: 1.5))
                        
                        // AWAY TEAM ABBR
                        Text("\(awayTeam.schoolAbbr)").font(.system(size: 10, weight: .heavy)).foregroundColor(Color.gray)
                    }
                }
                    
                
                
                // DIVIDING HORIZONTAL LINE
                Line().stroke(style: StrokeStyle(lineWidth: 1, dash: [1]))
                      .frame(width: 310, height: 1)
                      .foregroundColor(Color(hue: 0, saturation: 0, brightness: 0.85) )
                
                Text("Receiving Yards").font(.system(size: 14, weight: .semibold, design: .rounded)).padding(.top, 5)
                
                
                // RECEIVING YARDS HSTACK
                HStack(alignment: .top) {
                    VStack(alignment: .center) {
                        
                        // HOME RECEIVING LEADER IMAGE
                        Image("\(homeReceivingLeader.firstName) \(homeReceivingLeader.lastName)").resizable().aspectRatio(contentMode: .fit).frame(width: 45, height: 45, alignment: .bottom).clipShape(Circle()).overlay(Circle().stroke(Color(hue: 0.0, saturation: 0.0, brightness: 0.9), lineWidth: 1.5))
                        
                        // HOME TEAM ABBR
                        Text("\(homeTeam.schoolAbbr)").font(.system(size: 10, weight: .heavy)).foregroundColor(Color.gray)
                    }
                    VStack(alignment: .trailing) {
                        
                        // HOME RECEIVING LEADER NAME
                        Text("\(homeReceivingLeader.firstName) \(homeReceivingLeader.lastName)  ").font(.system(size: 13)).bold()
                        
                        // HOME RECEIVING STATS
                        Text("\(homeReceivingLeader.receptions) REC,").font(.system(size: 12)).foregroundColor(Color.gray).bold()
                        Text("\(homeReceivingLeader.receivingYards) YDS, \(homeReceivingLeader.receivingTouchdowns) TD").font(.system(size: 12)).foregroundColor(Color.gray).bold()
                    }.frame(width: 90)
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        
                        // AWAY RECEIVING LEADER NAME
                        Text("\(awayReceivingLeader.firstName) \(awayReceivingLeader.lastName)").font(.system(size: 13)).bold()
                        
                        // AWAY RECEIVING STATS
                        Text("\(awayReceivingLeader.receptions) REC,").font(.system(size: 12)).foregroundColor(Color.gray).bold()
                        Text("\(awayReceivingLeader.receivingYards) YDS, \(awayReceivingLeader.receivingTouchdowns) TD").font(.system(size: 12)).foregroundColor(Color.gray).bold()
                    }.frame(width: 90)
                    VStack(alignment: .center) {
                        
                        // AWAY RECEIVING LEADER IMAGE
                        Image("\(awayReceivingLeader.firstName) \(awayReceivingLeader.lastName)").resizable().aspectRatio(contentMode: .fit).frame(width: 45, height: 45, alignment: .bottom).clipShape(Circle()).overlay(Circle().stroke(Color(hue: 0.0, saturation: 0.0, brightness: 0.9), lineWidth: 1.5))
                        
                        // AWAY TEAM ABBR
                        Text("\(awayTeam.schoolAbbr)").font(.system(size: 10, weight: .heavy)).foregroundColor(Color.gray)
                    }
                }
                
                
                // DIVIDING HORIZONTAL LINE
                Line().stroke(style: StrokeStyle(lineWidth: 1.2))
                    .frame(width: 310, height: 1.2)
                      .foregroundColor(Color(hue: 0, saturation: 0, brightness: 0.87) )
            }
            
        }.frame(width: 310, height: 400, alignment: .top)
        }
}


#Preview {
    GameLeadersView(homePassingLeader: gamePlayers[0], homeRushingLeader: gamePlayers[1], homeReceivingLeader: gamePlayers[2], awayPassingLeader: gamePlayers[3], awayRushingLeader: gamePlayers[4], awayReceivingLeader: gamePlayers[5], homeTeam: schoolData[0], awayTeam: schoolData[1])
}




