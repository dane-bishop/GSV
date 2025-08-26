

import Foundation


struct OffensiveLine : OffenseFootballPlayer {
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
    var carries: Int = 0
    var rushingYards: Int = 0
    var avgPerRush: Float = 0.0
    var rushingTouchdowns: Int = 0
    var rushingLong: Int = 0
    var receptions: Int = 0
    var receivingYards: Int = 0
    var avgPerReception: Float = 0
    var receivingLong: Int = 0
    var receivingTouchdowns: Int = 0
    var fumbles: Int = 0
    
}
