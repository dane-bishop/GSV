//
//  PodcastListView.swift
//  MSPN
//
//  Created by Melanie Bishop on 4/28/25.
//

import SwiftUI

struct PodcastListView: View {
    var body: some View {
        ScrollView(.vertical){
            VStack{
                ForEach(PodcastData, id: \.IDNumber) { podcast in
                    PodcastView(podcast: podcast)
                        .frame(width: 300)
                        
                    
                }
            }
        }
            
    }
}

#Preview {
    PodcastListView()
}
