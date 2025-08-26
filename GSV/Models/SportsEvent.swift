

import Foundation

struct SportsEvent: Identifiable {
    var id = UUID()
    var homeTeam: String
    var awayTeam: String
    var homeTeamAbbr: String
    var awayTeamAbbr: String
    var sport: String
    var date: String
    var time: String
    
    var homeTeamImageName: String { return homeTeam + " Logo" }
    var awayTeamImageName: String { return awayTeam + " Logo" }

    
    
}


let liveData = [
    SportsEvent(homeTeam: "Affton", awayTeam: "Alton", homeTeamAbbr: "AHS", awayTeamAbbr: "AHS", sport: "basketball", date: "Feb 23, 2025", time: "10:00 AM"),
    SportsEvent(homeTeam: "Bayless", awayTeam: "Borgia", homeTeamAbbr: "BHS", awayTeamAbbr: "BHS", sport: "basketball", date: "Feb 23, 2025", time: "11:00 AM"),
    SportsEvent(homeTeam: "Brentwood", awayTeam: "Cahokia", homeTeamAbbr: "BHS", awayTeamAbbr: "CHS", sport: "basketball", date: "Feb 23, 2025", time: "12:00 PM"),
    SportsEvent(homeTeam: "CBC", awayTeam: "Chaminade", homeTeamAbbr: "CBC", awayTeamAbbr: "CCP", sport: "basketball", date: "Feb 23, 2025", time: "2:00 PM"),
    SportsEvent(homeTeam: "Hazelwood East", awayTeam: "Jennings", homeTeamAbbr: "HEHS", awayTeamAbbr: "JHS", sport: "basketball", date: "Feb 23, 2025", time: "2:00 PM"),
    SportsEvent(homeTeam: "Ladue", awayTeam: "Lutheran North", homeTeamAbbr: "LHS", awayTeamAbbr: "LNHS", sport: "basketball", date: "Feb 23, 2025", time: "2:00 PM"),
    SportsEvent(homeTeam: "Marquette", awayTeam: "MICDS", homeTeamAbbr: "MHS", awayTeamAbbr: "MICDS", sport: "basketball", date: "Feb 23, 2025", time: "4:00 PM"),
    SportsEvent(homeTeam: "Oakville", awayTeam: "Parkway North", homeTeamAbbr: "OHS", awayTeamAbbr: "PNHS", sport: "basketball", date: "Feb 23, 2025", time: "4:00 PM"),
    SportsEvent(homeTeam: "Ritenour", awayTeam: "Cardinal Ritter", homeTeamAbbr: "RHS", awayTeamAbbr: "CRCP", sport: "basketball", date: "Feb 23, 2025", time: "6:00 PM"),
    SportsEvent(homeTeam: "Seckmann", awayTeam: "SLUH", homeTeamAbbr: "SHS", awayTeamAbbr: "SLUH", sport: "basketball", date: "Feb 23, 2025", time: "7:00 PM"),
    SportsEvent(homeTeam: "Westminster", awayTeam: "Fort Zumwalt East", homeTeamAbbr: "WCA", awayTeamAbbr: "FZE", sport: "basketball", date: "Feb 23, 2025", time: "4:00 PM"),
  
]

