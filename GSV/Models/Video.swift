//
//  Video.swift
//  MSPN
//
//  Created by Melanie Bishop on 4/28/25.
//

import Foundation

struct Video: Identifiable {
    
    let id = UUID()
    let IDNumber: Int
    
    let videoName: String
    let videoID: String
    let sport: Sports
    
    // other video properties
    // video date
}


let VideoData = [
    Video(IDNumber: 5, videoName: "Ft. Zumwalt West vs Francis Howell", videoID: "tSM1-ytHBBo", sport: .baseball),
    Video(IDNumber: 4, videoName: "De Smet vs CBC", videoID: "6myHp8Vi9Ak", sport: .baseball),
    Video(IDNumber: 3, videoName: "Alton v Quincy", videoID: "9SeGOnwyXLM", sport: .mensBasketball),
    Video(IDNumber: 2, videoName: "Vianney v SLUH", videoID: "1LGuq5yce8U", sport: .baseball),
    Video(IDNumber: 1, videoName: "East St. Louis v Cary Grove", videoID: "aqKxhu5hkQQ", sport: .football),
    Video(IDNumber: 0, videoName: "Zumwalt North v Timberland", videoID: "U4184xWroYk", sport: .baseball)
]
