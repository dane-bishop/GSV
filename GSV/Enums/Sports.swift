
import Foundation
import SwiftUICore

enum Sports: Codable{
    case football
    case mensBasketball
    case womensBasketball
    case baseball
    case softball
    case mensSoccer
    case womensSoccer
    case wrestling
    
    var displayName: String {
            switch self {
            case .football: return "Football"
            case .mensBasketball: return "Men's Basketball"
            case .womensBasketball: return "Women's Basketball"
            case .baseball: return "Baseball"
            case .softball: return "Softball"
            case .mensSoccer: return "Men's Soccer"
            case .womensSoccer: return "Women's Soccer"
            case .wrestling: return "Wrestling"
            }
        }
    
    
    var image: Image {
            switch self {
            case .baseball:
                return Image("baseball")
            case .football:
                return Image("football")
            case .mensBasketball, .womensBasketball:
                return Image("basketball")
            case .softball:
                return Image(systemName: "baseball.fill")
            case .wrestling:
                return Image(systemName: "figure.wrestling")
            case .mensSoccer, .womensSoccer:
                return Image("soccer")
            }
        
        }
}




