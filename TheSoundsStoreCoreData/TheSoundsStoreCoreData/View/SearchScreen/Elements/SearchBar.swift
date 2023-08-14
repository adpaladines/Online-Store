//
//  SearchBar.swift
//  TheSoundsStore
//
//  Created by Andres D. Paladines on 7/17/23.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
//            Image(systemName: "chevron.backward")
//                .padding()
//                .imageScale(.large)
//                .frame(width: 24, height: 24)
            
            Spacer()
            
            HStack {
                TextField("Search for a product, cloth, etc.", text: $searchText)
                    .fontWeight(.semibold)
                    .font(Font.system(size: 16, design: .default))
//                    .textFieldStyle(.roundedBorder)
                    .padding([.trailing], 0)
                    .padding([.leading], 16)
                    .padding([.vertical], 8)
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
//                    .padding([.trailing], 12)
                    .foregroundColor(.gray)
                    .frame(width: 16, height: 16)
                    .padding([.trailing], 12)
                
            }
            .background(Color(hex: "f1f1f1"))
            .cornerRadius(8)
            .frame(height: 24)
        }
        .frame(height: 24)
//        .padding([.horizontal])
        
    }
}

//struct SearchBar_Previews: PreviewProvider {
//
//    @State static var searchText: String =  "Custom Text"
//
//    static var previews: some View {
//        SearchBar(searchText: $searchText)
//    }
//}

struct SearchBar_Previews: PreviewProvider {
    
    @State static var searchText: String =  "Custom Text"
    
    static var previews: some View {
        SearchBar(searchText: $searchText)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
