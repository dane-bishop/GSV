
import Foundation

enum SchoolSuffix: String, Codable {
    case highSchool
    case academy
    case school
    case jesuit
    case collegePreparatory
    case none
    
    var displayText: String {
        switch self {
        case .highSchool:
            return " High School"
        case .academy:
            return " Academy"
        case .school:
            return " School"
        case .jesuit:
            return " Jesuit"
        case .collegePreparatory:
            return " College Preparatory"
        case .none:
            return ""
        }
    }
}
