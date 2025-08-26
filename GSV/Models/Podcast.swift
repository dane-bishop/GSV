//
//  Podcast.swift
//  MSPN
//
//  Created by Melanie Bishop on 4/28/25.
//

import Foundation

struct Podcast {
    
    let podcastID = UUID()
    
    // Eventually change this to UUID()
    let IDNumber: Int
    
    let podcastName: String
    let podcastEmbedID: String
    let sport: Sports
    let date: String
    
    
    // other video properties
}


let PodcastData = [
    Podcast(IDNumber: 4, podcastName: "FOOTBALL COACHING CAROUSEL", podcastEmbedID: "https://open.spotify.com/embed/episode/1V53oSjSQ8VGvMQRHT1bvN?si=4641af8fd542407a", sport: .baseball, date: "05/15/25"),
    Podcast(IDNumber: 3, podcastName: "St. Louis High School Baseball Overview", podcastEmbedID: "https://open.spotify.com/embed/episode/0TIgoObPF3Jg8RvCIUkvlD?si=bf9530e5fd844fbb", sport: .baseball, date: "05/12/25"),
    Podcast(IDNumber: 2, podcastName: "District Basketball Preview", podcastEmbedID: "https://open.spotify.com/embed/episode/5cCGG6J5LEdQwhCPGtgDKj?si=77b48e9905e04660", sport: .mensBasketball, date: "03/04/2025"),
    Podcast(IDNumber: 1, podcastName: "Metro East Basketball Playoffs", podcastEmbedID: "https://open.spotify.com/embed/episode/5zKuUfiTmPRRTAbGYCt3Ey?si=d3393cfd7ea24aac", sport: .mensBasketball, date: "03/03/2025"),
    Podcast(IDNumber: 0, podcastName: "FOOTBALL COACHING CAROUSEL", podcastEmbedID: "https://open.spotify.com/embed/episode/5cCGG6J5LEdQwhCPGtgDKj?si=rWYXehwYQ625i1TTE95kuw", sport: .mensBasketball, date: "03/03/2025"),
    
    
]
