

import Foundation

@Observable
class ModelData {
    var schools: [School] = load("SchoolData.json")
//    var profile = Profile.default
    
//    var features: [Landmark] {
//        landmarks.filter { $0.isFeatured }
//    }
    
//    var categories: [String: [Landmark]] {
//        Dictionary(
//            grouping: landmarks,
//            by: { $0.category.rawValue }
//        )
//            
//    }
    
    init() {
        self.schools = load("SchoolData.json")
        // print("Loaded schools:", schools.map { "\($0.name): \($0.isFavorite)" })
    }
}



func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        print("❌ Decoding error:", error) // <- should appear in Xcode console
        // Throwing a less destructive error to let app still launch for debugging
        return [] as! T  // Force empty array for debugging School array
    }
}





//func load<T: Decodable>(_ filename: String) -> T {
//    let data: Data
//
//
//    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
//    else {
//        fatalError("Couldn't find \(filename) in main bundle.")
//    }
//
//
//    do {
//        data = try Data(contentsOf: file)
//    } catch {
//        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
//    }
//
//
//    do {
//        let decoder = JSONDecoder()
//        return try decoder.decode(T.self, from: data)
//    } catch {
//        print("Decoding error:", error)
//        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
//    }
//}



