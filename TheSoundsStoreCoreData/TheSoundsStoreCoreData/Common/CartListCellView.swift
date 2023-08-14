//
//  CartListCellView.swift
//  TheSoundsStore
//
//  Created by Andres D. Paladines on 7/17/23.
//

import SwiftUI

struct CartListCellView: View {
    @EnvironmentObject var viewModel: ProductsListViewModel
    
    @State var item: Product
    @State var number: Int = 1
//    @Binding var subTotal: Int
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Rectangle()
                        .frame(width: 96, height: 96)
                        .foregroundColor(Color(hex: "f1f1f1", alpha: 1.0))
                        .cornerRadius(8)
                    
                    if let firstImage = item.images.first  {
                        CachedAsyncImage(url: URL(string: firstImage)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 86, height: 86)
                                .padding([.all], 8)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 86, height: 86)
                        }
                    }
                    
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .font(.caption)
                            .fontWeight(.bold)
                            .lineLimit(1)
                        
                        Text(item.description)
                            .font(.caption)
                            .fontWeight(.none)
                            .lineLimit(2)
                            .foregroundColor(Color(uiColor: .lightGray))
                        
                        Text("$ \(item.price)")
                            .font(.title3)
                            .fontWeight(.heavy)
                            .lineLimit(1)
                            .padding([.top], 4)
                    }
                    
                    Spacer()
                    VStack {
                        Spacer()
                        HStack {
                            if item.quantity == 1 {
                                Button {
//                                    item.quantity = 0
                                    viewModel.deleteFromCart(item)
//                                    itemDeleted.toggle()
//                                    subTotal = viewModel.subtotalAmount
                                } label: {
                                    Image(systemName: "trash.square")
                                }
                                .foregroundColor(.mint)
                            }else {
                                    Image(systemName: "minus.square")
                                        .onTapGesture {
                                            if number > 1 {
                                                number -= 1
                                                item.quantity = number
                                                viewModel.addToCart(item, quantity: number)
//                                                subTotal = viewModel.subtotalAmount
                                            }
                                        }
                                
                                .foregroundColor(.mint)
                            }
                            
                            Text("\(number)")
                                .padding([.vertical])
                                .onChange(of: viewModel.cartList.count) { numberOfItems in
                                    guard let currentitem = viewModel.cartList.first(where: {$0.id == item.id}) else {
                                        number = 0
                                        return
                                    }
                                    number = currentitem.quantity ?? 0
                                }
                            
                            Button { } label: {
                                Image(systemName: "plus.app.fill")
                                    .onTapGesture {
                                        Task {
                                            if number <= item.stock {
                                                number += 1
                                                item.quantity = number
                                                viewModel.addToCart(item, quantity: number)
//                                                subTotal = viewModel.subtotalAmount
                                            }
                                        }
                                        
                                    }
                            }
                            .foregroundColor(.mint)
                        }
                        
                    }
                }
            }
//            Divider()
        }
        .onAppear {            
            guard let currentitem = viewModel.cartList.first(where: {$0.id == item.id}) else {
                number = 0
                return
            }
            number = currentitem.quantity ?? 0
        }
        .onChange(of: viewModel.cartList.count) { numberOfItems in
            guard let currentitem = viewModel.cartList.first(where: {$0.id == item.id}) else {
                number = 0
                return
            }
            number = currentitem.quantity ?? 0
        }
    }
}

struct CartListCellView_Previews: PreviewProvider {
    
    @State static var item = ProductsResponse.getTheSound()[1]
    @State static var subTotal = 100
    
    static var previews: some View {
//        CartListCellView(item: item, itemDeleted: $itemDeleted).environmentObject(ProductsListViewModel(networkManager: NetworkManager()))
        CartListCellView(item: item/*, subTotal: $subTotal*/).environmentObject(ProductsListViewModel(networkManager: NetworkManager()))
    }
    
}
