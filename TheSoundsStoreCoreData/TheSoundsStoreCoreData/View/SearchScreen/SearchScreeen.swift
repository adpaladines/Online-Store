//
//  ContentView.swift
//  TheSoundsStore
//
//  Created by Andres D. Paladines on 7/17/23.
//

import SwiftUI
import CoreData
import HidableTabView

struct SearchScreeen: View {
    
    @EnvironmentObject var viewModel: ProductsListViewModel
    
    //    @FetchRequest(entity: ProductEntity.entity(), sortDescriptors: [])
    //    var results: FetchedResults<ProductEntity>
    //    var request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
    
    @State var searchText: String = ""
    @State var hasError1: Bool = false
    @State var hasError2: Bool = false
    @State var loading: Bool = true
    @State var productList: [Product] = []
    
    @ViewBuilder
    func generateProductsListFromDB() -> some View {
        
        SectionHeader(leftText: "Hot Sales", rightText: "See all")
        if productList.count != 0 {
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.flexible())]) {
                    ForEach(productList) { item in
                        GridCell(item: item)
                    }
                    .padding([.horizontal], 4)
                }
            }
            .padding([.bottom])
        }
        else {
            VStack {
                Image("no-data-found")
                    .resizable()
                    .frame(width: 128, height: 100)
                    .cornerRadius(25, corners: .topLeft)
                    .cornerRadius(25, corners: .bottomRight)
                Text(viewModel.getProductsError()?.localizedDescription ?? "Something went wrong.")
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .padding([.bottom], 20)
            }
        }
    }
    
    func getUserData() async {
        await viewModel.getUserDataFrom(urlString: ApiManager.userInfo())
    }
    
    func getCategories() async {
        guard viewModel.categoriesList.count == 0 else {
            return
        }
        
        await viewModel.getCategoriesList()
        print("cats: \(viewModel.categoriesList.count)")
        if viewModel.customErrorList[ProducResponseKeyName.categories.rawValue] != nil {
            hasError1 = true
        }
    }
    
    func getProducts() async {
        guard viewModel.productsResponseList.count == 0 else {
            return
        }
        await refreshProduct()
        
    }
    
    func refreshProduct() async {
        await viewModel.getDevicesResponseList(urlString: ApiManager.api(), for: .defaultValue)
        
        if viewModel.customErrorList[ProducResponseKeyName.defaultValue.rawValue] != nil {
            hasError1 = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            loading = false
        }
        
        productList = await viewModel.getProductsListFromGenericDB()
        
    }
    
    //    func getDBDirectory() {
    //        guard let url = FileManager.default.urls(for: .applicationDirectory, in: .userDomainMask).first
    //        else {
    //            return
    //        }
    //        let sqlitepath = url.appendingPathComponent("TheSoundsStoreCoreData")
    //        print(sqlitepath)
    //    }
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(searchText: $searchText)
                    .padding()
                
                FiltersBar(categories: viewModel.categoriesList)
                    .task {
                        await getCategories()
                    }
                
                ScrollView {
                    generateProductsListFromDB()
                        .task {
                            await getProducts()
                        }
                    //                    .refreshable {
                    //                        await refreshProduct()
                    //                        await getCategories()
                    //                    }
                    
                    SectionHeader(leftText: "Viewed Items", rightText: "See all")
                    if viewModel.recentsList.count > 0 {
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: [GridItem(.flexible())]) {
                                ForEach(viewModel.recentsList) { item in
                                    ProductCellWithButton(item: item)
                                    
                                }.padding([.horizontal], 4)
                            }
                        }
                        .padding([.bottom])
                    } else {
                        VStack {
                            Image("no-data-found")
                                .resizable()
                                .frame(width: 128, height: 100)
                                .cornerRadius(25, corners: .topLeft)
                                .cornerRadius(25, corners: .bottomRight)
                            Text("No items viewed")
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .padding([.bottom], 20)
                        }
                    }
                }
                .redacted(reason: loading ? .placeholder: [])
                .onAppear {
                    UITabBar.showTabBar(animated: true)
                    
                    guard let url = FileManager.default.urls(for: .applicationDirectory, in: .userDomainMask).first
                    else {
                        return
                    }
                    let sqlitepath = url.appendingPathComponent("TheSoundsStoreCoreData")
                    print(sqlitepath)
                }
                .alert(isPresented: $hasError1) {
                    Alert(
                        title: Text("Error in Hot Sales!"),
                        message: Text(viewModel.customErrorList["default"]?.localizedDescription ?? ""),
                        dismissButton: Alert.Button.default(Text("Ok")))
                }
                .refreshable {
                    Task {
                        await refreshProduct()
                        await getCategories()
                    }
                }
                Spacer()
            }
            
        }
    }
}

struct SearchScreeen_Previews: PreviewProvider {
    
    static var previews: some View {
        @StateObject var viewModel = ProductsListViewModel(networkManager: NetworkManager())
        SearchScreeen().environmentObject(viewModel)
    }
}
