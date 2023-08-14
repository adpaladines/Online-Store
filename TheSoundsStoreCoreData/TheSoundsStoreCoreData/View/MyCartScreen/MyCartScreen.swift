//
//  MyCartScreen.swift
//  TheSoundsStore
//
//  Created by Andres D. Paladines on 7/17/23.
//

import SwiftUI
import HidableTabView

struct CartAmounts: View {
    
    var leftText: String
    var rightText: String
    
    var body: some View {
        HStack {
            Text(leftText)
                .fontWeight(.bold)
            Spacer()
            Text(rightText)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
        }
        .padding([.horizontal])
    }
}

struct MyCartScreen: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: ProductsListViewModel
    
    @State var coupon = "MXFTHE"
    @State var isCouponAvailable: Bool = true
    @State var hasError: Bool = false
    @State var deletedRow: Bool = false
    @State var loading: Bool = true
    
    @State var totalDiscount: Int = 0
    @State var subTotal: Int = 0
    @State var total: Int = 0
    
    private func delete(at offsets: IndexSet) {
        guard let index = offsets.first else {
            return
        }
        viewModel.deleteItem(at: index)
    }
    
    var body: some View {
        let availableText = isCouponAvailable ? "Available" : "Unavailable"
        let couponImage = isCouponAvailable ? "checkmark.circle.fill" : "x.circle.fill"
        let couponColor = isCouponAvailable ? Color.mint : Color.red
        
        VStack {
            HeaderBarView(title: "My Cart", letftButtonHidden: true, rightButtonHidden: true)
            if viewModel.cartList.count != 0 {
                List() {
                    Section {
                        
                        UserInfoBarView()
                            .padding([.top], 8)
                    }
                    Section {
                        ForEach(viewModel.cartList) { item in
                            CartListCellView(item: item)
                        }
                        .onDelete(perform: { indexSet in
                            delete(at: indexSet)
                        })
                        .onChange(of: viewModel.cartList.count) { newValue in
                            
                        }
                    }
                    
                    Section {
                        HStack {
                            Text("Have a coupon code? enter here 👇")
                                .font(.caption)
                                .fontWeight(.bold)
                                .lineLimit(1)
                            Spacer()
                        }
//                        .padding([.horizontal])
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
                            CartAmounts(leftText: "Subtotal:", rightText: "$ \(subTotal)")
                            CartAmounts(leftText: "Delivery Fee:", rightText: "Free")
                            CartAmounts(leftText: "Discount:", rightText: "$ \(totalDiscount)")
                            
                            HLine().stroked()
                                .frame(height: 2)
                            CartAmounts(leftText: "Total", rightText: "$ \(total)")
                        }
//                        .padding([.horizontal])
                    }
                    
                }
                .background(Color.gray)
//                .edgesIgnoringSafeArea(.horizontal)
            }else {
                VStack(alignment: .center) {
                    Spacer()
                    Image("no-data-found")
                        .resizable()
                        .frame(width: 128, height: 100)
                        .cornerRadius(25, corners: .topLeft)
                        .cornerRadius(25, corners: .bottomRight)
                    Text(viewModel.getProductsError()?.localizedDescription ?? "Add something to the cart.")
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .padding([.bottom], 20)
                    Spacer()
                }
            }
            
            
            if viewModel.cartList.count == 0 {
                WideButton(text: "Add new items", disabled: true) {
                    
                }
                .padding([.horizontal])
                .padding([.bottom])
                .foregroundColor(.gray)

            }else {
                WideButton(text: "Proceed to checkout") {
                    print("Continue no checkout.")
                }
                .padding([.horizontal])
                .padding([.bottom])
            }
            

        }
        .redacted(reason: loading ? .placeholder: [])
        .onAppear {
            subTotal = viewModel.subtotalAmount
            total = viewModel.totalAmount
            totalDiscount = viewModel.totalDiscountAmount
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                loading = false
            }
            UITabBar.showTabBar(animated: true)
        }
        .onChange(of: viewModel.subtotalAmount) { newValue in
            subTotal = viewModel.subtotalAmount
            total = viewModel.totalAmount
            totalDiscount = viewModel.totalDiscountAmount
        }
    }
}

struct MyCartScreen_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = ProductsListViewModel(networkManager: NetworkManager())
        
//        MyCartScreen()
//            .environmentObject(ProductsListViewModel(networkManager: NetworkManager()))
//            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
//                        .previewDisplayName("iPhone SE (3rd generation)")
        MyCartScreen()
            .environmentObject(viewModel)
                        .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
                                    .previewDisplayName("iPhone 14 Pro")
    }
    
}
