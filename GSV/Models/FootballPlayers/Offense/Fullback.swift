

import Foundation


struct Fullback : OffenseFootballPlayer {
    var id = UUID()
    var firstName: String
    var lastName: String
    var height: String
    var weight: Float
    var grade: String
    var age: Int
    var schoolID: UUID
    var offenseDefense = FootballOffenseDefense.offense
    var passingYards: Int = 0
    var passingAttempts: Int = 0
    var passingCompletions: Int = 0
    var avgPerPassAttempt: Float = 0.0
    var passingTouchdowns: Int = 0
    var interceptions: Int = 0
    var carries: Int
    var rushingYards: Int
    var avgPerRush: Float {
        carries != 0 ? Float(rushingYards) / Float(carries) : 0.0
    }
    var rushingTouchdowns: Int
    var rushingLong: Int
    var receptions: Int
    var receivingYards: Int
    var avgPerReception: Float {
        receptions != 0 ? Float(receivingYards) / Float(receptions) : 0.0
    }
    var receivingLong: Int
    var receivingTouchdowns: Int
    var fumbles: Int
    
}
