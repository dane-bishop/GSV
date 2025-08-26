

import SwiftUI


struct HomeView: View {

    @Binding var currentScreen: AppScreen
    @State private var showMenu = false
    @Binding var refreshTrigger: Bool
    
    
    var body: some View {
        
        VStack(spacing: 0){
            TopBarView(currentScreen: $currentScreen, showMenu: $showMenu, refreshTrigger: $refreshTrigger)
            
            if showMenu {
                VStack(alignment: .leading, spacing: 12) {
                    Button("Home") {
                        if currentScreen == .home {
                            refreshTrigger.toggle()
                        } else {
                            currentScreen = .home
                        }
                        showMenu = false
                    }
                    Button("Profile") {
                        currentScreen = .profile
                        showMenu = false
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 8)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            Spacer()
                
            BottomBarView()
            
        }.animation(.easeInOut, value: showMenu)
      
    }
        
}

#Preview {
    StatefulPreviewWrapper(AppScreen.home) { screenBinding in
        StatefulPreviewWrapper(false) { refreshTriggerBinding in
            HomeView(currentScreen: screenBinding, refreshTrigger: refreshTriggerBinding)
        }
    }
}
