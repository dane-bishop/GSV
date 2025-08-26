//
//  SchoolRow.swift
//  GSV
//
//  Created by Melanie Bishop on 5/21/25.
//

import SwiftUI

struct SchoolRow: View {
    
    var school: School
    
    var body: some View {
        HStack{
            Image(school.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            
            Text("\(school.schoolFullName)")
            
            Spacer()
            
            if school.isFavorite {
                Image(systemName: "star.fill").foregroundStyle(.yellow)
            }
                
        }
    }
}

#Preview {
    let schools = ModelData().schools
    Group {
        SchoolRow(school: schools[0])
        SchoolRow(school: schools[1])
    }
    
}
