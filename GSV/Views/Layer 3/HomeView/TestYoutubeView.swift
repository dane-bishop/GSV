
import SwiftUI

struct TestYoutubeView: View {
    
    @State private var videos: [YouTubeVideo] = []
    @State private var selectedVideoId: String? = nil
    private let service = YouTubeService()
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 22) { // small spacing between title and videos
                Text("Latest Videos")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 8) // closer to the top
                    .padding(.horizontal, 12)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) { // smaller spacing between videos
                        ForEach(videos, id: \.videoId) { video in
                            Button(action: {
                                selectedVideoId = video.videoId
                            }) {
                                VStack(alignment: .leading, spacing: 4) {
                                    AsyncImage(url: URL(string: video.thumbnailUrl)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 180, height: 100)
                                    .clipped()
                                    .cornerRadius(8)

                                    Text(video.title)
                                        .font(.subheadline)
                                        .lineLimit(2)
                                        .frame(width: 180, alignment: .leading)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 12)
                }

                Spacer()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onAppear {
                service.fetchLatestVideos { fetchedVideos in
                    self.videos = fetchedVideos
                }
            }
            .sheet(item: $selectedVideoId) { videoId in
                YouTubePlayerHelperView(videoId: videoId)
                    .edgesIgnoringSafeArea(.all)
            }
        }

    }
}



extension String: Identifiable {
    public var id: String { self }
}

#Preview {
    TestYoutubeView()
}
