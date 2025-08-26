//
//  HomeView.swift
//  MSPN
//
//  Created by Melanie Bishop on 4/28/25.
//

import SwiftUI

struct HomeButtonView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(alignment: .leading, spacing: 12){
                
                
                
                
//                Text("Latest Videos")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                    .padding(.horizontal)
                
                TestYoutubeView()
                
                
                Text("Latest Podcasts")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                
                ScrollView(.horizontal, showsIndicators: false){
                    
                    HStack(spacing: 16){
                         
                        PodcastView(podcast: PodcastData[0])
                        
                        PodcastView(podcast: PodcastData[1])
                        
                        PodcastView(podcast: PodcastData[2])
                        
                        PodcastView(podcast: PodcastData[3])
                        
                        PodcastView(podcast: PodcastData[4])
                        
                    }.padding()
                }
                    
            }
        }.padding(.top, 30)
        
    }
}

#Preview {
    HomeButtonView()
}
