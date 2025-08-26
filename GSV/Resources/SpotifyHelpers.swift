

import Foundation


func getSpotifyAccessToken(completion: @escaping (String?) -> Void) {
    let clientID = ""
    let clientSecret = ""
    let credentials = "\(clientID):\(clientSecret)"
    guard let data = credentials.data(using: .utf8) else { return }
    
    let base64 = data.base64EncodedString()
    var request = URLRequest(url: URL(string: "https://accounts.spotify.com/api/token")!)
    request.httpMethod = "POST"
    request.addValue("Basic \(base64)", forHTTPHeaderField: "Authorization")
    request.httpBody = "grant_type=client_credentials".data(using: .utf8)
    
    URLSession.shared.dataTask(with: request) { data, _, _ in
        if let data = data,
           let tokenData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let token = tokenData["access_token"] as? String {
            completion(token)
        } else {
            completion(nil)
        }
        
    }.resume()
}


