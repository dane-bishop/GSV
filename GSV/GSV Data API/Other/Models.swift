//
//  Models.swift
//  GSV
//
//  Created by Melanie Bishop on 8/17/25.
//

import Foundation

struct Item: Codable {
    let id: Int
    let name: String
    let created_at: String?
}


// GSV Player
struct GSVPlayer: Codable, Identifiable, Hashable {
    let id: Int
    let name: String?
    let team_name: String?
    let player_link: String?
}


// GSV Player Stat
struct GSVPlayerStat: Codable, Identifiable, Hashable {
    let id: Int
    let player_id: Int
    let playerName: String?     // ← NEW (maps from player_name)
    let teamName: String?       // ← optional; maps from team_name
    let stat_type: String?
    let stat_value: Double?
    let stat_category: String?
    let game_date: String?
    let game_id: Int?

    enum CodingKeys: String, CodingKey {
        case id, player_id, stat_type, stat_value, stat_category, game_date, game_id
        case playerName = "player_name"
        case teamName   = "team_name"
    }
}


// GSV Schools
struct GSVSchool: Codable, Identifiable, Hashable {
    let external_id: Int
    let name: String
    let location: String?
    let url: String?

    var id: Int { external_id }
}


// GSV Team Schedules
struct GSVSchedule: Codable, Identifiable, Hashable {
    let id: Int
    let school_id: Int
    let school_name: String?    // ← NEW
    let sport: String
    let year: Int
    let date: String?           // "YYYY-MM-DD"
    let opponent: String
    let opponent_record: String?
    let location: String?
    let result: String?
    let score: String?
    let notes: String?

    enum CodingKeys: String, CodingKey {
        case id, school_id, school_name, sport, year, date, opponent, opponent_record,
             location, result, score, notes
    }
}








struct Paged<T: Codable>: Codable {
    let total: Int
    let limit: Int
    let offset: Int
    let items: [T]
}

struct LoginResponse: Codable {
    let access_token: String
}
