

import SwiftUI

struct TopBarView: View {
    
    @Binding var currentScreen: AppScreen
    @Binding var showMenu: Bool
    @Binding var refreshTrigger: Bool
    
    var body: some View {
        
        ZStack{
            Color(red: 21/255, green: 0/255, blue: 255/255)
                .edgesIgnoringSafeArea(.top)
                .allowsHitTesting(false)
            
            
            VStack{
                HStack{
                    
                    // MENU ICON
                    Button(action: {
                        withAnimation {
                            showMenu.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3").foregroundColor(.white)
                            .font(.title)
                            .padding()
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    
                    Spacer()
                    
                    
                    // APP LOGO
                    Button(action: {
                        
                        if currentScreen == .home {
                            refreshTrigger.toggle()
                        } else {
                            currentScreen = .home
                        }
                        
                    }) {
                        Image("GSVLogoTransparent").resizable().frame(width: 91, height: 60)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    
                    
                    
                    Spacer()
                    
                    
                    // PROFILE ICON
                    
                    
                    Button(action: {
                        currentScreen = .profile
                    }) {
                        Image(systemName: "person.crop.circle")
                            .foregroundStyle(Color.white)
                            .font(.title)
                            .padding()
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
            }
            
            
        }.frame(height: 65)
 
    }
}

#Preview {
    StatefulPreviewWrapper(AppScreen.home) { screenBinding in
        StatefulPreviewWrapper(false) { showMenuBinding in
            StatefulPreviewWrapper(false) { refreshTriggerBinding in
                TopBarView(currentScreen: screenBinding, showMenu: showMenuBinding, refreshTrigger: refreshTriggerBinding)
            }
        }
    }
}
