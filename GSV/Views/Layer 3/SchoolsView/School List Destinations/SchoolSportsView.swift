

import SwiftUI

struct SchoolSportsView: View {
    
    var school: School
    var sport: Sports
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack{
                
                HStack{
                    VStack{
                        Text("\(school.schoolFullName) \(sport.displayName) ")
                            .font(.headline)
                        
                        Image(school.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 100, maxHeight: 100) // Adjust as needed
                            .clipShape(RoundedRectangle(cornerRadius: 12)) // Optional styling
                    }.offset(y: 10)
                    
                }
                
                Spacer()
                // Display logo, school title and sport
                // Display an option to click on the schedule
                //
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

#Preview {
    SchoolSportsView(school: School(name: "Affton", location: "Affton", yearFounded: "1930", state: "MO", schoolSuffix: SchoolSuffix.highSchool, schoolAbbr: "AHS", index: 0), sport: .football)
}
