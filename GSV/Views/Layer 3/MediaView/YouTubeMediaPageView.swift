

import SwiftUI


struct YouTubeMediaPageView: View {
    @StateObject private var viewModel = YouTubeViewModel()
    @State private var selectedCategory: VideoCategory = .latest
    @State private var selectedVideoId: String?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    
                    // Title
                    Text("Gateway Sports Venue")
                        .font(.largeTitle.bold())
                        .padding(.horizontal)
                        .padding(.top)

                    // Picker
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(VideoCategory.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)

                    // Playlist selection buttons
                    if selectedCategory == .playlists {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(viewModel.playlists) { playlist in
                                    Button(action: {
                                        viewModel.loadVideosFromPlaylist(playlistId: playlist.id)
                                    }) {
                                        Text(playlist.title)
                                            .font(.subheadline)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(Color.blue.opacity(0.2))
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // Horizontal video list
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.videos) { video in
                                VStack(alignment: .leading, spacing: 6) {
                                    // Thumbnail
                                    AsyncImage(url: URL(string: video.thumbnailUrl)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 200, height: 120)
                                            .clipped()
                                            .cornerRadius(10)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 200, height: 120)
                                    }

                                    // Title
                                    Text(video.title)
                                        .font(.caption)
                                        .lineLimit(1)               // Limit to 1 line
                                        .truncationMode(.tail)      // Add "..." at the end
                                        .frame(width: 200, alignment: .leading) // Match thumbnail width
                                }
                                .onTapGesture {
                                    selectedVideoId = video.videoId
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadVideos(category: selectedCategory)
            }
            .onChange(of: selectedCategory) { newCategory in
                viewModel.loadVideos(category: newCategory)
            }
            // Full screen player sheet
            .sheet(item: $selectedVideoId) { videoId in
                YouTubePlayerHelperView(videoId: videoId)
            }
        }
    }
}


#Preview {
    YouTubeMediaPageView()
}
