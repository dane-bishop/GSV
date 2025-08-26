//
//  PodcastView.swift
//  MSPN
//
//  Created by Melanie Bishop on 4/28/25.
//

import SwiftUI
import WebKit

struct PodcastPlayer: UIViewRepresentable {
    let spotifyEmbedURL: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.contentMode = .scaleAspectFit
        webView.isOpaque = false
        webView.backgroundColor = .clear
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let embedHTML = """
        <html>
        <body style="margin:0;padding:0;">
        <iframe src="\(spotifyEmbedURL)" width="100%" height="80" frameborder="0" allowtransparency="true" allow="encrypted-media"></iframe>
        </body>
        </html>
        """
        webView.loadHTMLString(embedHTML, baseURL: nil)
    }
}

struct PodcastView: View {
    
    let podcast: Podcast
    
    var body: some View {
        VStack(alignment: .leading) {
            
            
            Text("\(podcast.podcastName) - \(podcast.date)")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.black.opacity(0.7))
                .multilineTextAlignment(.leading)
                .padding(.leading, 3)
                
            
            PodcastPlayer(spotifyEmbedURL: podcast.podcastEmbedID)
                .id(podcast.podcastEmbedID)
                .frame(height: 50)
                .cornerRadius(12)
                .shadow(radius: 4)
                
        }
    }
}

#Preview {
    PodcastView(podcast: Podcast(IDNumber: 0, podcastName: "District Basketball Preview", podcastEmbedID: "https://open.spotify.com/embed/episode/5cCGG6J5LEdQwhCPGtgDKj?si=77b48e9905e04660", sport: .mensBasketball, date: "03/04/2025"))
}
