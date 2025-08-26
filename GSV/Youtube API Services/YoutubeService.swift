

import Foundation

struct YouTubeVideo: Decodable, Identifiable{
    let id = UUID()
    let title: String
    let thumbnailUrl: String
    let videoId: String
    let viewCount: Int?
}

struct YouTubePlaylist: Identifiable {
    let id: String
    let title: String
}


class YouTubeService {
    private let apiKey = "AIzaSyCoDwdpBNsselJatUyaf8YN_52WY1TwpDg"
    private let channelId = "UCvNhrDChEmMVrcTvZvs0J1A" // You can use forUsername logic earlier if needed
    
    // MARK: - 1. Latest Videos (from Uploads Playlist)
    func fetchLatestVideos(completion: @escaping ([YouTubeVideo]) -> Void) {
        getUploadsPlaylistId { uploadsPlaylistId in
            self.fetchPlaylistItems(playlistId: uploadsPlaylistId, completion: completion)
        }
    }
    
    
    
    // MARK: -2. Most Popular Videos (using search endpoint)
    func fetchPopularVideos(completion: @escaping ([YouTubeVideo]) -> Void) {
        let urlStr = "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=\(channelId)&order=viewCount&type=video&maxResults=10&key=\(apiKey)"
        guard let url = URL(string: urlStr) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            do {
                let json = try JSONDecoder().decode(SearchResponse.self, from: data)
                let videos: [YouTubeVideo] = json.items.compactMap { item -> YouTubeVideo? in
                    guard let videoId = item.id.videoId else { return nil }
                    return YouTubeVideo(
                        title: item.snippet.title,
                        thumbnailUrl: item.snippet.thumbnails.medium.url,
                        videoId: videoId,
                        viewCount: nil
                    )
                }
                DispatchQueue.main.async {
                    completion(videos)
                }
            } catch {
                print("Error fetching popular videos: \(error)")
            }
        }.resume()
    }
    
    
    // MARK: - 3. Fetch Playlists on Channel
    func fetchPlaylists(completion: @escaping ([YouTubePlaylist]) -> Void) {
        let urlStr = "https://www.googleapis.com/youtube/v3/playlists?part=snippet&channelId=\(channelId)&maxResults=25&key=\(apiKey)"
        guard let url = URL(string: urlStr) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(PlaylistListResponse.self, from: data)
                let playlists = result.items.map {
                    YouTubePlaylist(id: $0.id, title: $0.snippet.title)
                }
                DispatchQueue.main.async {
                    completion(playlists)
                }
            } catch {
                print("Error fetching playlists: \(error)")
            }
        }.resume()
    }
    
    // MARK: - 4. Fetch Videos from Specific Playlist
    func fetchVideosFromPlaylist(playlistId: String, completion: @escaping ([YouTubeVideo]) -> Void) {
        fetchPlaylistItems(playlistId: playlistId, completion: completion)
    }
    
    // MARK: - 5. Fetch Most popular all time
    func fetchMostPopularAllTime(completion: @escaping ([YouTubeVideo]) -> Void) {
            getUploadsPlaylistId { playlistId in
                self.fetchAllPlaylistVideoIds(playlistId: playlistId) { videoIds in
                    self.fetchVideosDetails(for: videoIds) { videos in
                        let sorted = videos.sorted { ($0.viewCount ?? 0) > ($1.viewCount ?? 0) }
                        DispatchQueue.main.async {
                            completion(sorted)
                        }
                    }
                }
            }
        }
    
    // MARK: - Helper: Get Uploads Playlist ID
    private func getUploadsPlaylistId(completion: @escaping (String) -> Void) {
        let urlStr = "https://www.googleapis.com/youtube/v3/channels?part=contentDetails&id=\(channelId)&key=\(apiKey)"
        guard let url = URL(string: urlStr) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            do {
                let json = try JSONDecoder().decode(ChannelContentResponse.self, from: data)
                if let uploadsId = json.items.first?.contentDetails.relatedPlaylists.uploads {
                    completion(uploadsId)
                }
            } catch {
                print("Error getting uploads playlist ID: \(error)")
            }
        }.resume()
    }
    
    // MARK: - Shared: Fetch Playlist Items
    private func fetchPlaylistItems(playlistId: String, completion: @escaping ([YouTubeVideo]) -> Void) {
        let urlStr = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=10&playlistId=\(playlistId)&key=\(apiKey)"
        guard let url = URL(string: urlStr) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            do {
                let json = try JSONDecoder().decode(PlaylistItemResponse.self, from: data)
                let videos: [YouTubeVideo] = json.items.compactMap { item -> YouTubeVideo? in
                    guard let videoId = item.snippet.resourceId?.videoId else { return nil }
                    return YouTubeVideo(
                        title: item.snippet.title,
                        thumbnailUrl: item.snippet.thumbnails.medium.url,
                        videoId: videoId,
                        viewCount: nil
                    )
                }
                DispatchQueue.main.async {
                    completion(videos)
                }
            } catch {
                print("Error fetching playlist items: \(error)")
            }
        }.resume()
    }
    
    // MARK: Fetch Playlisst Video IDs
    private func fetchAllPlaylistVideoIds(playlistId: String, completion: @escaping ([String]) -> Void) {
            var allVideoIds: [String] = []

            func fetchPage(pageToken: String?) {
                var urlStr = "https://www.googleapis.com/youtube/v3/playlistItems?part=contentDetails&maxResults=50&playlistId=\(playlistId)&key=\(apiKey)"
                if let token = pageToken {
                    urlStr += "&pageToken=\(token)"
                }
                guard let url = URL(string: urlStr) else { return }

                URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data else { return }
                    do {
                        let response = try JSONDecoder().decode(PlaylistContentDetailsResponse.self, from: data)
                        let ids = response.items.map { $0.contentDetails.videoId }
                        allVideoIds.append(contentsOf: ids)

                        if let nextPage = response.nextPageToken {
                            fetchPage(pageToken: nextPage)
                        } else {
                            completion(allVideoIds)
                        }
                    } catch {
                        print("Error fetching playlist video IDs: \(error)")
                    }
                }.resume()
            }

            fetchPage(pageToken: nil)
        }
    
    // MARK: Fetch Video Details
    private func fetchVideosDetails(for videoIds: [String], completion: @escaping ([YouTubeVideo]) -> Void) {
            let chunks = stride(from: 0, to: videoIds.count, by: 50).map {
                Array(videoIds[$0..<min($0 + 50, videoIds.count)])
            }

            var results: [YouTubeVideo] = []
            let group = DispatchGroup()

            for chunk in chunks {
                let joinedIds = chunk.joined(separator: ",")
                let urlStr = "https://www.googleapis.com/youtube/v3/videos?part=snippet,statistics&id=\(joinedIds)&key=\(apiKey)"
                guard let url = URL(string: urlStr) else { continue }

                group.enter()
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    defer { group.leave() }
                    guard let data = data else { return }
                    do {
                        let response = try JSONDecoder().decode(VideoDetailsResponse.self, from: data)
                        let videos = response.items.map { item -> YouTubeVideo in
                            YouTubeVideo(
                                title: item.snippet.title,
                                thumbnailUrl: item.snippet.thumbnails.medium.url,
                                videoId: item.id,
                                viewCount: Int(item.statistics.viewCount) ?? 0
                            )
                        }
                        results.append(contentsOf: videos)
                    } catch {
                        print("Error fetching video details: \(error)")
                    }
                }.resume()
            }

            group.notify(queue: .main) {
                completion(results)
            }
        }
}




