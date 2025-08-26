
import Foundation

// MARK: - YouTube API Models

struct PlaylistContentDetailsResponse: Codable {
    let items: [PlaylistVideoItem]
    let nextPageToken: String?
}

struct PlaylistVideoItem: Codable {
    let contentDetails: PlaylistVideoDetails
}

struct PlaylistVideoDetails: Codable {
    let videoId: String
}

struct VideoDetailsResponse: Codable {
    let items: [VideoDetail]
}

struct VideoDetail: Codable {
    let id: String
    let snippet: Snippet
    let statistics: VideoStatistics
}

struct VideoStatistics: Codable {
    let viewCount: String
}

struct PlaylistItemResponse: Codable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Codable {
    let snippet: Snippet
}

struct Snippet: Codable {
    let title: String
    let thumbnails: Thumbnails
    let resourceId: ResourceId?
}

struct Thumbnails: Codable {
    let medium: Thumbnail
}

struct Thumbnail: Codable {
    let url: String
}

struct ResourceId: Codable {
    let videoId: String?
}

// For Playlists
struct PlaylistListResponse: Codable {
    let items: [PlaylistData]
}

struct PlaylistData: Codable {
    let id: String
    let snippet: Snippet
}

// For Channel Uploads
struct ChannelContentResponse: Codable {
    let items: [ChannelContentItem]
}

struct ChannelContentItem: Codable {
    let contentDetails: ContentDetails
}

struct ContentDetails: Codable {
    let relatedPlaylists: RelatedPlaylists
}

struct RelatedPlaylists: Codable {
    let uploads: String
}

// For Popular Videos via Search
struct SearchResponse: Codable {
    let items: [SearchItem]
}

struct SearchItem: Codable {
    let id: SearchVideoId
    let snippet: Snippet
}

struct SearchVideoId: Codable {
    let videoId: String?
}








