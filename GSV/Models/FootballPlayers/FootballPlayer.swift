

import Foundation

protocol FootballPlayer : Player {
    var offenseDefense: FootballOffenseDefense { get set }
}


protocol OffenseFootballPlayer : FootballPlayer {
    var passingYards: Int { get set }
    var passingAttempts: Int { get set }
    var passingCompletions: Int { get set }
    var avgPerPassAttempt: Float { get }
    var passingTouchdowns: Int { get set }
    var interceptions: Int { get set }
    var carries: Int { get set }
    var rushingYards: Int { get set }
    var avgPerRush: Float { get }
    var rushingTouchdowns: Int { get set }
    var rushingLong: Int { get set }
    var receptions: Int { get set }
    var receivingYards: Int { get set }
    var avgPerReception: Float { get }
    var receivingLong: Int { get set }
    var receivingTouchdowns: Int { get set }
    var fumbles: Int { get set }
}



protocol DefenseFootballPlayer : FootballPlayer {
    var totalTackles: Int { get set }
    var soloTackles: Int { get set }
    var sacks: Float { get set }
    var tacklesForLoss: Int { get set }
    var interceptions: Int { get set }
    var fumbleRecoveries: Int { get set }
    var touchdowns: Int { get set }
}



