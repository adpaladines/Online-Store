//
//  TabBarControllerScreen.swift
//  TheSoundsStore
//
//  Created by Andres D. Paladines on 7/17/23.
//

import SwiftUI
import HidableTabView

struct TabBarControllerScreen: View {
    
    @EnvironmentObject var viewModel: ProductsListViewModel
    @State private var likeCountBadge = 0
//    @State private var selectedTab = 0
    
    var body: some View {
//        TabView(selection: $selectedTab) {
        TabView() {
            SearchScreeen().tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            MyCartScreen().tabItem {
                Image(systemName: "cart")
                Text("Cart")
            }
            .badge( likeCountBadge > 99 ? "99+" : String(likeCountBadge) )
            
            Text("Wallet").tabItem {
                Image(systemName: "wallet.pass")
                Text("Wallet")
                    .onAppear {
                        UITabBar.showTabBar(animated: true)
                    }
            }
            
            OtherCharts().tabItem {
                Image(systemName: "chart.bar.xaxis")
                Text("Statistic")
                    .onAppear {
                        UITabBar.showTabBar(animated: true)
                    }
            }
            
            Text("Profile").tabItem {
                Image(systemName: "gearshape")
                Text("Profile")
            }
        }
        .onAppear {
            
        }
        .onChange(of: viewModel.cartList.count) { newValue in
            likeCountBadge = newValue
        }
        .showTabBar(animated: true)
        
    }
}

struct TabBarControllerScreen_Previews: PreviewProvider {
    
    static var previews: some View {
        TabBarControllerScreen().environmentObject(ProductsListViewModel(networkManager: NetworkManager()))
    }

}
