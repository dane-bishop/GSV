import SwiftUI
import YouTubeiOSPlayerHelper

struct YouTubePlayerHelperView: UIViewRepresentable {
    let videoId: String
    
    func makeUIView(context: Context) -> YTPlayerView {
        let playerView = YTPlayerView()
        return playerView
    }
    
    func updateUIView(_ uiView: YTPlayerView, context: Context) {
        let playerVars: [String: Any] = [
            "playsinline": 1,
            "controls": 1,
            "autoplay": 1
        ]
        uiView.load(withVideoId: videoId, playerVars: playerVars)
    }
}
