//
//  MediaView.swift
//  MSPN
//
//  Created by Melanie Bishop on 4/28/25.
//

import SwiftUI

struct MediaView: View {
    
    @Binding var selectedView: MediaSelection
    
    var body: some View {
        VStack{
            
            
            // Title Buttons (Videos/Podcasts)
            HStack {
                Button(action: {
                    selectedView = .videos
                }) {
                    Text("Videos")
                        .foregroundColor(selectedView == .videos ? .blue : .gray)
                        .fontWeight(selectedView == .videos ? .bold : .regular)
                    
                        .padding(.leading, 55)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                Button(action: {
                    selectedView = .podcasts
                }) {
                    Text("Podcasts")
                        .foregroundColor(selectedView == .podcasts ? .blue : .gray)
                        .fontWeight(selectedView == .podcasts ? .bold : .regular)
                        
                        .padding(.trailing, 55)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            
            Line().stroke(style: StrokeStyle(lineWidth: 1.2))
                .frame(width: 310, height: 1.2)
                  .foregroundColor(Color(hue: 0, saturation: 0, brightness: 0.87) )
            
            Spacer()
            
            // Switch between the two views
            if selectedView == .videos {
                YouTubeMediaPageView()
            } else {
                PodcastListView()
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    MediaView(selectedView: .constant(.videos))
}
