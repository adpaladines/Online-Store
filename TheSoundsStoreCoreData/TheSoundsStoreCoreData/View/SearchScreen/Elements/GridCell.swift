//
//  GridCell.swift
//  TheSoundsStore
//
//  Created by Andres D. Paladines on 7/17/23.
//

import SwiftUI

struct GridCell: View {
    
    @EnvironmentObject var viewModel: ProductsListViewModel
    
    var item: Product
    
    var body: some View {
        
        NavigationLink {
            DetailsProductScreen(item: item)
        } label: {
            VStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(hex: "F1F1F1", alpha: 1.0))
                        .cornerRadius(16)
                    VStack {
                        if let firstImage = item.images.first  {
                            CachedAsyncImage(url: URL(string: firstImage)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 186, height: 146)
                                //                                .shadow(color: Color.teal, radius: 3)
                                    .padding(0)
                                    .background(.green)
                                    .cornerRadius(16)
                                    .cornerRadius(16, corners: .topLeft)
                                    .cornerRadius(16, corners: .topRight)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 190, height: 86)
                            }
                        }
                    }
                    
                    VStack {
                        Spacer()
                        HStack {
                            Text("Free shipping")
                                .font(Font.system(size: 12, design: .default))
                                .padding([.vertical], 4)
                                .padding([.horizontal], 12)
                                .background(.black)
                                .foregroundColor(.white)
                                .cornerRadius(6)
                            Spacer()
                        }
                        .padding([.vertical], 0)
                        .padding([.horizontal], 8)
                    }
                    .padding([.bottom], 8)
                    .padding([.top], 20)
                }
                .frame(width: 190, height: 150)

                HStack {
                    Text(item.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("$ \(item.price)")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .padding([.horizontal])
                
                Text(item.description)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .frame(
                          minWidth: 0,
                          maxWidth: .infinity,
                          minHeight: 0,
                          maxHeight: .infinity,
                          alignment: .topLeading
                        )
                    .padding([.horizontal])
                
            }
            
        }
        .frame(width: 196, height: 220)
        
    }
}



struct GridCell_Previews: PreviewProvider {
        
    static var previews: some View {
        
        let item = Product(id: 1, title: "Headphones", description: "This is a headphone not from Apple aslf sklfh klsdhf lkasdjhf kasdjf", price: 133, discountPercentage: 14.5, rating: 4.7, stock: 100, brand: "Apple", category: "smartphone", thumbnail: "https://i.dummyjson.com/data/products/12/thumbnail.jpg", images: [
            "https://i.dummyjson.com/data/products/12/1.jpg", "https://i.dummyjson.com/data/products/12/2.jpg", "https://i.dummyjson.com/data/products/12/3.png", "https://i.dummyjson.com/data/products/12/4.jpg"
                                                                                                                                                                                                                                                                                                                                ])
        
        @StateObject var viewModel = ProductsListViewModel(networkManager: NetworkManager())

        GridCell(item: item).environmentObject(viewModel)
    }
}
