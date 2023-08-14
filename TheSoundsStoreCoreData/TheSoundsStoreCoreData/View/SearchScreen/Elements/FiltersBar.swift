//
//  FiltersBar.swift
//  TheSoundsStore
//
//  Created by Andres D. Paladines on 7/17/23.
//

import SwiftUI

struct FiltersBar: View {

    let rows = [GridItem(.flexible())]
    var categories: [String]
    
    var body: some View {
        
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows) {
                
                Image(systemName: "slider.horizontal.3")
                    .frame(width: 6, height: 6)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 26)
                                .inset(by: 1)
                                .stroke(.gray, lineWidth: 1)
                    )
                
                ForEach(categories, id: \.self) { item in
                    HStack {
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color(hex: "f1f1f1", alpha: 1.0))
                                .cornerRadius(16)
                                .frame(width: 24, height: 24)
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                                .padding([.all], 8)
                        }

                        Text(item)
                            .fontWeight(.bold)
                            .foregroundColor(Color(uiColor: .darkGray))
                    }
                    .frame( height: 8)
                    .padding([.leading], 12)
                    .padding([.trailing], 16)
                    .padding([.vertical], 16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 26)
                            .inset(by: 3)
                            .stroke(.gray, lineWidth: 1)
                    )
                }
            }
            .frame(height: 48)
            Divider()
//                .padding([.vertical], 16)
                .padding([.horizontal], 0)
        }
        .frame(height: 48)
        .padding([.horizontal], 16)
        .padding([.vertical], 0)
        .onAppear {
            print(categories)
        }
    }
    
}

struct FiltersBar_Previews: PreviewProvider {
    static var previews: some View {
        FiltersBar(categories: ["headphones", "speakers", "laptops"])
    }
}
