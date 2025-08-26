

import SwiftUI

struct SchoolDetail: View {
    
    @Environment(ModelData.self) var modelData
    
    var school: School
    
    var schoolIndex: Int? {
        modelData.schools.firstIndex(where: { $0.id == school.id })
    }

    var body: some View {
        
        @Bindable var modelData = modelData
        
        ScrollView {
            VStack {
                Image(school.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200, maxHeight: 200) // Adjust as needed
                    .clipShape(RoundedRectangle(cornerRadius: 12)) // Optional styling
                
                
                HStack{
                    Text(school.schoolFullName)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding(.top, 10)
                    
                    // Make schoolData Binding (mutable)
                    
                    if let index = schoolIndex {
                        FavoriteButton(isSet: $modelData.schools[index].isFavorite)
                    }
                    
                    
                
                }
                
                
                
                // hr line
                Line().stroke(style: StrokeStyle(lineWidth: 1.2))
                    .frame(width: 310, height: 1.2)
                    .foregroundColor(Color(hue: 0, saturation: 0, brightness: 0.87) ).offset(y: -15)
                
                
                
                // School Picture
                Image(school.schoolFullName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300, maxHeight: 300) // Adjust as needed
                    .offset(y: 0)
                    .shadow(color: .gray.opacity(0.6), radius: 10, x: 0, y: 8)
                
                
                // School Bio
                Text("School Bio...").offset(y: 20)
                
                
                // hr line
                Line().stroke(style: StrokeStyle(lineWidth: 1.2))
                    .frame(width: 310, height: 1.2)
                    .foregroundColor(Color(hue: 0, saturation: 0, brightness: 0.87) ).offset(y: 30)
                
                // List of school sports
                // destination -> SchoolSportsView
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("School Sports:")
                        .font(.headline)
                        .padding(.top, 30.0)
                    
                    ForEach(school.schoolSports, id: \.self) { sport in
                        NavigationLink(destination: SchoolSportsView(school: school, sport: sport)) {
                            HStack{
                                
                                sport.image
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.black)
                                
                                Text(" \(sport.displayName)")
                                    .foregroundColor(.blue)
                                    .padding(.leading, 15)
                            }
                            
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading).offset(y: 15)
                
                
                
                Spacer() // Pushes content to the top
            }
            .padding()
            //.navigationTitle(school.schoolFullName)
            .navigationBarTitleDisplayMode(.inline)
        } // Title for navigation bar
    }
}

#Preview {
    let modelData = ModelData()
    SchoolDetail(school: modelData.schools[0]).environment(modelData)
}
