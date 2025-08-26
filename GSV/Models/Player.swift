
import Foundation


protocol Player {
    var id: UUID { get set }
    var firstName: String { get set }
    var lastName: String { get set }
    var height: String { get set }
    var weight: Float { get set }
    var grade: String { get set }
    var age: Int { get set }
    var schoolID: UUID { get set }

}





var gamePlayers: [OffenseFootballPlayer] = [
    Quarterback(firstName: "John", lastName: "Smith", height: "6'3", weight: 215, grade: "Junior", age: 17, schoolID: schoolData[0].id, passingYards: 189, passingAttempts: 23, passingCompletions: 18, passingTouchdowns: 2, interceptions: 0, carries: 4, rushingYards: 14, rushingTouchdowns: 0, rushingLong: 6, fumbles: 0),
    Runningback(firstName: "Jeff", lastName: "Smith", height: "5'11", weight: 200, grade: "Senior", age: 18, schoolID: schoolData[0].id, carries: 15, rushingYards: 101, rushingTouchdowns: 2, rushingLong: 35, receptions: 2, receivingYards: 10, receivingLong: 7, receivingTouchdowns: 0, fumbles: 1),
    WideReceiver(firstName: "Jake", lastName: "Smith", height: "6'4", weight: 210, grade: "Sophomore", age: 15, schoolID: schoolData[0].id, carries: 0, rushingYards: 0, rushingTouchdowns: 0, rushingLong: 0, receptions: 6, receivingYards: 94, receivingLong: 52, receivingTouchdowns: 2, fumbles: 0),
    Quarterback(firstName: "John", lastName: "Wilson", height: "6'1", weight: 215, grade: "Junior", age: 17, schoolID: schoolData[0].id, passingYards: 336, passingAttempts: 33, passingCompletions: 24, passingTouchdowns: 4, interceptions: 1, carries: 2, rushingYards: -13, rushingTouchdowns: 0, rushingLong: 0, fumbles: 0),
    Runningback(firstName: "Jeff", lastName: "Wilson", height: "5'11", weight: 200, grade: "Senior", age: 18, schoolID: schoolData[0].id, carries: 6, rushingYards: 22, rushingTouchdowns: 1, rushingLong: 7, receptions: 2, receivingYards: 15, receivingLong: 7, receivingTouchdowns: 0, fumbles: 1),
    WideReceiver(firstName: "Jake", lastName: "Wilson", height: "6'4", weight: 210, grade: "Sophomore", age: 15, schoolID: schoolData[0].id, carries: 0, rushingYards: 0, rushingTouchdowns: 0, rushingLong: 0, receptions: 10, receivingYards: 143, receivingLong: 57, receivingTouchdowns: 3, fumbles: 0)
    
]
