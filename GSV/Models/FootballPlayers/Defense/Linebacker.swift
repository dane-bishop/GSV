

import Foundation

struct Linebacker : DefenseFootballPlayer {
    var id = UUID()
    var firstName: String
    var lastName: String
    var height: String
    var weight: Float
    var grade: String
    var age: Int
    var schoolID: UUID
    var offenseDefense = FootballOffenseDefense.defense
    var totalTackles: Int
    var soloTackles: Int
    var sacks: Float
    var tacklesForLoss: Int
    var interceptions: Int
    var fumbleRecoveries: Int
    var touchdowns: Int
    
}
