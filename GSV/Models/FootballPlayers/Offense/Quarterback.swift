

import Foundation

struct Quarterback : OffenseFootballPlayer {
    var id = UUID()
    var firstName: String
    var lastName: String
    var height: String
    var weight: Float
    var grade: String
    var age: Int
    var schoolID: UUID
    var offenseDefense = FootballOffenseDefense.offense
    var passingYards: Int
    var passingAttempts: Int
    var passingCompletions: Int
    var avgPerPassAttempt: Float {
        passingAttempts != 0 ? Float(passingYards) / Float(passingAttempts) : 0.0
    }
    var passingTouchdowns: Int
    var interceptions: Int
    var carries: Int
    var rushingYards: Int
    var avgPerRush: Float {
        carries != 0 ? Float(rushingYards) / Float(carries) : 0.0
    }
    var rushingTouchdowns: Int
    var rushingLong: Int
    var receptions: Int = 0
    var receivingYards: Int = 0
    var avgPerReception: Float {
        receptions != 0 ? Float(receivingYards) / Float(receptions) : 0.0
    }
    var receivingLong: Int = 0
    var receivingTouchdowns: Int = 0
    var fumbles: Int
    
}
