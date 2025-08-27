//
//  ResponseWrappers.swift
//  GSV
//
//  Created by Melanie Bishop on 8/26/25.
//

import Foundation

struct GameStatsMeta: Codable, Hashable {
    let date: String?
    let sport: String?
    let home_external_id: Int
    let away_external_id: Int
    let home_name: String?
    let away_name: String?
    let result: String?
    let score: String?
    let location: String?
}

// MARK: - Full response for /games/{id}/player-stats
struct PlayerStatsByScheduleResponse: Codable {
    let total: Int
    let limit: Int
    let offset: Int
    let items: [GSVPlayerStat]
    let game: Game?

    struct Game: Codable {
        let scheduleId: Int?
        let date: String?
        let sport: String?
        let location: String?
        let schoolId: Int?
        let opponent: String?
        let score: String?
        let result: String?
        let homeExternalId: Int?
        let awayExternalId: Int?

        enum CodingKeys: String, CodingKey {
            case scheduleId = "schedule_id"
            case date, sport, location
            case schoolId = "school_id"
            case opponent, score, result
            case homeExternalId = "home_external_id"
            case awayExternalId = "away_external_id"
        }
    }
}


