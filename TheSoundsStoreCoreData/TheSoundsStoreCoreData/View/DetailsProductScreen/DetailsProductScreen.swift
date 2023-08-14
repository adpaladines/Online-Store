//
//  DetailsProductScreen.swift
//  TheSoundsStore
//
//  Created by Andres D. Paladines on 7/19/23.
//

import SwiftUI
import HidableTabView

struct ItemCaptions: View {
    
    @State var item: Product
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(item.title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .padding([.horizontal])
                .padding([.bottom], 4)

            Text(item.description)
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding([.horizontal])
        }
    }
}

struct ImagePresentation: View {
    
    @State var item: Product
    @Binding var imageSelected: String
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                CachedAsyncImage(url: URL(string: imageSelected)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .padding(0)
                } placeholder: {
                    ProgressView()
                        .frame(height: 200)
                }
                Spacer()
            }
            .background(Color(uiColor: UIColor(Color(hex: "f1f1f1"))))
//            .frame(width: .infinity)
            
            HStack {
                Spacer()
                VStack {
                    ScrollView {
                        ForEach(item.images, id: \.self) { imageUrl in
                            ZStack {
                                CachedAsyncImage(url: URL(string: imageUrl)) { image in
                                    image
                                        .resizable()
                                        .frame(width: 64, height: 64, alignment: .trailing)
                                        .cornerRadius(8)
                                        .opacity(
                                            imageSelected != imageUrl
                                            ? 0.55
                                            : 1.0
                                        )
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 8)
                                                .inset(by: 1)
                                                .stroke(imageSelected != imageUrl ? .clear : .mint, lineWidth: 1)
                                                .shadow(
                                                    color: .mint,
                                                    radius: 2
                                                )
                                        }
                                    
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 64, height: 64, alignment: .trailing)
                                        .cornerRadius(8)
                                }
                                .onTapGesture {
                                    imageSelected = imageUrl
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            
        }
        .onAppear {
            if let first = item.images.first {
                imageSelected = first
            }
        }
        .frame(height: 200)
    }
    
}

struct ImageDetails: View {
    
    @State var item: Product
    @State var isFavorite: Bool = false
    @State var imageSelected: String = ""

    
    var body: some View {
        
        let favoriteColor: Color = isFavorite ? .red : .gray
        VStack {
            
            ImagePresentation(item: item, imageSelected: $imageSelected)
            
            Group {
                HStack {
                    Text("Free shipping")
                        .font(Font.system(size: 14, design: .default))
                        .padding([.vertical], 4)
                        .padding([.horizontal], 12)
                        .background(.mint)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                    Spacer()
                    Image(systemName: "heart.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding([.horizontal])
                        .foregroundColor(favoriteColor)
                        .onTapGesture {
                            isFavorite.toggle()
                        }
                }
                .padding([.vertical], 0)
                .padding([.horizontal], 8)
            }
            
        }
        .padding([.bottom], 8)
        .padding([.top], 0)
    }
}

struct SelectedCircle: View {
    
    @State var color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 32, height: 32)
            Circle()
                .frame(width: 28, height: 28)
                .foregroundColor(color)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .inset(by: 1)
                        .stroke(.white, lineWidth: 2)
                }
        }
    }
}

struct NotSelectedCircle: View {
    
    @State var color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 28, height: 28)
                .foregroundColor(color)
        }
        .frame(width: 32, height: 32)
    }
}

struct DetailsProductScreen: View {
    
    @EnvironmentObject var viewModel: ProductsListViewModel
    
    @State var selectedColor: Color = .clear
    @State var coupon = "MXFTHE"
    @State var isCouponAvailable: Bool = true
    @State var number: Int = 1
    @State var item: Product
    @State var loading: Bool = true
    
    var colors: [Color] = [
        Color(hex: "555555"),
        Color(hex: "999999"),
        Color(hex: "bbbbbb")
    ]
    
    func saveItemToRecents() {
        if !viewModel.recentsList.contains(where: {$0.id == item.id}) {
            viewModel.recentsList.append(item)
        }
    }
    
    func addToCart(_ item: Product) {
        viewModel.addToCart(item, quantity: number)
    }
        
    var body: some View {
        let availableText = isCouponAvailable ? "Available" : "Unavailable"
        let couponImage = isCouponAvailable ? "checkmark.circle.fill" : "x.circle.fill"
        let couponColor = isCouponAvailable ? Color.mint : Color.red
        
        VStack {
            HeaderBarView(title: item.title)
            UserInfoBarView()
            ScrollView {
                ImageDetails(item: item)
                ItemCaptions(item: item)
                
                HStack {
                    Text("$ \(item.price)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                    Spacer()
                    
                    HStack {
                        ForEach(colors, id: \.self) { color in
                            if selectedColor == color {
                                SelectedCircle(color: color)
                                    .onTapGesture {
                                        selectedColor = color
                                    }
                            }else {
                                NotSelectedCircle(color: color)
                                    .onTapGesture {
                                        selectedColor = color
                                    }
                            }
                        }
                    }
                    .padding([.horizontal])
                }
                
                HStack {
                    Text("Have a coupon code? enter here 👇")
                        .font(.caption)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    Spacer()
                }
                .padding([.horizontal])
                .padding([.top])
                .padding([.bottom], 4)
                
                VStack {
                    HStack {
                        Text(coupon)
                            .font(Font.system(size: 16, weight: .bold))
                        Spacer()
                        Text(availableText)
                            .bold()
                            .foregroundColor(couponColor)
                        Image(systemName: couponImage)
                            .foregroundColor(couponColor)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .inset(by: 1)
                            .stroke(Color(uiColor: .lightGray), lineWidth: 1)
                    )
                }
                Spacer()
            }
            .onAppear {
                saveItemToRecents()
                selectedColor = colors[0]
            }
            .toolbar(.hidden)
            //MARK: - End of ScrollView
            
            VStack {
                HLine().doted(lineWidth: 1, dash: [0.1])
                    .frame(height: 2)
                    .foregroundColor(.gray)
                HStack {
                    Group {
                        HStack {
                            Button {
                                if number > 1 {
                                    number -= 1
                                    item.quantity = number
                                    viewModel.addToCart(item, quantity: number)
                                }
                            } label: {
                                Image(systemName: "minus.square")
                                    .resizable()
                            }
                            .foregroundColor(.mint)
                            .frame(width: 24, height: 24)
                            
                            Text("\(number)")
                                .padding([.vertical])
                                .font(.title3)
                                .bold()
                            
                            Button {
                                if number <= item.stock {
                                    number += 1
                                    item.quantity = number
                                    viewModel.addToCart(item, quantity: number)
                                }
                            } label: {
                                Image(systemName: "plus.app.fill")
                                    .resizable()
                            }
                            .foregroundColor(.mint)
                            .frame(width: 24, height: 24)
                        }
                    }
                    Spacer()
                    WideButton(text: "Add to Cart") {
                        addToCart(item)
                    }
                    .frame(width: 200)
                }
                .padding()
            }
            
        }
        .redacted(reason: loading ? .placeholder: [])
        .onAppear {
            UITabBar.hideTabBar(animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                loading = false
            }
        }
        
    }
}

struct DetailsProductScreen_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let item = Product(
            id: 1,
            title: "Headphones for the guy next to the door",
            description: "This is a headphone not from Apple aslf sklfh klsdhf lkasdjhf kasdjf",
            price: 133,
            discountPercentage: 14.5,
            rating: 4.7,
            stock: 100,
            brand: "Apple",
            category: "smartphone",
            thumbnail: "https://i.dummyjson.com/data/products/12/thumbnail.jpg",
            images:
                [
                    "https://i.dummyjson.com/data/products/12/4.jpg",
                    "https://i.dummyjson.com/data/products/12/1.jpg",
                    "https://i.dummyjson.com/data/products/12/2.jpg",
                    "https://i.dummyjson.com/data/products/12/3.png"
                ]
        )
        
        DetailsProductScreen(item: item).environmentObject(ProductsListViewModel(networkManager: NetworkManager()))
    }
}
