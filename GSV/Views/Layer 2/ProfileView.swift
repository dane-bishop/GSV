

import SwiftUI

struct ProfileView: View {
    
    @Binding var currentScreen: AppScreen
    
    var body: some View {
        
        
        VStack{
            
            HStack {
                Button(action: {
                    currentScreen = .home
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
                Spacer()
            }
            .padding(.top, 20)
            
            .padding(.horizontal)
            
            HStack(alignment: .center, spacing: 15){
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 40)
                    .frame(width: 150, height: 150).padding(.bottom, 30)
                    
            }
            
            Spacer()
            
            HStack{
                Text("Profile")
                    .font(.system(size: 28))
                    .fontWeight(.heavy)
                    .underline()
                
            }.offset(y: -250)
            
            Text("Profile Information...")
                .offset(y: -200)
            
            Spacer()
            
            
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(AppScreen.profile) { screenBinding in
            ProfileView(currentScreen: screenBinding)
        }
    }
}
