

import Foundation
import SwiftUICore

struct School: Hashable, Codable, Identifiable {
    var id = UUID()
    var name: String
    var isFavorite: Bool = false
    var location: String
    var yearFounded: String
    var state: String
    var isClosed: Bool = false
   
    var imageName: String { return name + " Logo" }
    
    var schoolFullName: String {
        name + schoolSuffix.displayText
    }
    
    var schoolSuffix: SchoolSuffix
    
    // var schoolSports: [Sports]
    // give all schools a default sports list
    // should be able to edit the list
    
    var schoolSports: [Sports] = [Sports.football, Sports.mensBasketball, Sports.womensBasketball, Sports.baseball, Sports.softball, Sports.mensSoccer, Sports.womensSoccer]
    
    var schoolAbbr: String
    var index: Int
    
    
    
    enum CodingKeys: String, CodingKey {
        case id, name, isFavorite, location, yearFounded, state, isClosed, schoolSuffix, schoolAbbr, index
    }
    
    
    
    // Normal initializer
    init(
        name: String,
        isFavorite: Bool = false,
        location: String,
        yearFounded: String,
        state: String,
        isClosed: Bool = false,
        schoolSuffix: SchoolSuffix,
        schoolAbbr: String,
        index: Int,
        schoolSports: [Sports] = [
            .football, .mensBasketball, .womensBasketball,
            .baseball, .softball, .mensSoccer, .womensSoccer
        ]
    ) {
        self.id = UUID()
        self.name = name
        self.isFavorite = isFavorite
        self.location = location
        self.yearFounded = yearFounded
        self.state = state
        self.isClosed = isClosed
        self.schoolSuffix = schoolSuffix
        self.schoolAbbr = schoolAbbr
        self.index = index
        self.schoolSports = schoolSports
    }
    
    
    
    // Decoder initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.location = try container.decode(String.self, forKey: .location)
        self.yearFounded = try container.decode(String.self, forKey: .yearFounded)
        self.state = try container.decode(String.self, forKey: .state)
        self.schoolSuffix = try container.decode(SchoolSuffix.self, forKey: .schoolSuffix)
        self.schoolAbbr = try container.decode(String.self, forKey: .schoolAbbr)
        self.index = try container.decode(Int.self, forKey: .index)
        
        // Assign default calues to non-decoded properties
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
        self.isClosed = try container.decodeIfPresent(Bool.self, forKey: .isClosed) ?? false
        self.schoolSports = [
            .football, .mensBasketball, .womensBasketball, .baseball, .softball, .mensSoccer, .womensSoccer
        ]
    }
    
    
}



