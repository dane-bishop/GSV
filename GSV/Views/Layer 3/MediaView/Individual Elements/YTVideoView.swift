//
//  YTVideoView.swift
//  MSPN
//
//  Created by Melanie Bishop on 4/28/25.
//

import SwiftUI
import WebKit

struct YoutubePlayer: UIViewRepresentable {
    
    let videoID: String
    
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
                <body style="margin:0px;padding:0px;overflow:hidden;">
                <iframe width="100%" height="100%" src="https://www.youtube.com/embed/\(videoID)?playsinline=1&modestbranding=1&showinfo=0&rel=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
                </body>
                </html>
                """
                webView.loadHTMLString(embedHTML, baseURL: nil)
    }
}


struct YTVideoView: View {
    
    let videoID: String
    
    var body: some View {
        VStack {
            
            YoutubePlayer(videoID: videoID)
                .id(videoID)
                .frame(height: 250)
                .cornerRadius(12)
                .shadow(radius: 5)
        }
    }
}

struct YTVideoView_Previews: PreviewProvider {
    static var previews: some View {
        YTVideoView(videoID: "9SeGOnwyXLM")
    }
}
