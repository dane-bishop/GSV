

import SwiftUI

struct ContentView: View {
    @State private var currentScreen: AppScreen = .home
    @State private var refreshTrigger = false

        var body: some View {
            ZStack {
            
                
                switch currentScreen {
                case .menu:
                    Text("Menu View") // Replace with your actual MenuView
                case .profile:
                    ProfileView(currentScreen: $currentScreen) // Replace if needed
                case .home:
                    HomeView(currentScreen: $currentScreen, refreshTrigger: $refreshTrigger).id(refreshTrigger)
                }
            }
            .animation(.easeInOut, value: currentScreen)
        }
}

#Preview {
    ContentView()
}
