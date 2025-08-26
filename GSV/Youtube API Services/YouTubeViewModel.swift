import Foundation

enum VideoCategory: String, CaseIterable, Identifiable {
    case latest = "Latest"
    case popular = "Popular"
    case playlists = "Playlists"
    
    var id: String { self.rawValue }
}

class YouTubeViewModel: ObservableObject {
    @Published var videos: [YouTubeVideo] = []
    @Published var playlists: [YouTubePlaylist] = []
    @Published var selectedPlaylistId: String?
    
    private let service = YouTubeService()
    
    /// Load based on selected category
    func loadVideos(category: VideoCategory) {
        switch category {
        case .latest:
            service.fetchLatestVideos { [weak self] videos in
                self?.videos = videos
            }
        case .popular:
            service.fetchMostPopularAllTime { [weak self] videos in
                self?.videos = videos
            }
        case .playlists:
            service.fetchPlaylists { [weak self] playlists in
                self?.playlists = playlists
                self?.videos = [] // clear video list until a playlist is selected
            }
        }
    }
    
    
    /// Load videos from a selected playlist
    func loadVideosFromPlaylist(playlistId: String) {
        selectedPlaylistId = playlistId
        service.fetchVideosFromPlaylist(playlistId: playlistId) { [weak self] videos in
            self?.videos = videos
        }
    }
    
    
}
