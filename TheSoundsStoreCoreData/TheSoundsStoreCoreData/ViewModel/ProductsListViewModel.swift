//
//  ProductsListViewModel.swift
//  TheSoundsStore
//
//  Created by Andres D. Paladines on 7/18/23.
//

import Foundation
import PassKit
import SwiftUI

@MainActor //it is similar to work with DispatchQueue.main.async
class ProductsListViewModel: ObservableObject {
    
    @Published var productsResponseList: [String: ProductsResponse] = [:]
    @Published var customErrorList: [String: NetworkError] = [:]
    @Published var defaultList = [Product]()
    @Published var recentsList = [Product]()
    @Published var cartList = [Product]()
    @Published var userInfo: UserInfo?
    @Published var paymentStatus: PaymentStatus = .none
    @Published var paymentFinished: Bool = false

    @Published var subtotalAmount: Int = 0
    @Published var totalDiscountAmount: Int = 0
    @Published var totalAmount: Int = 0
    
    @Published var categoriesList: [String] = []

    @ObservedObject var paymentManager: PaymentManager = PaymentManager()

    let context = PersistenceController.shared.container.newBackgroundContext()

    var networkManager: NetworkAbleProtocol
    
    init(networkManager: NetworkAbleProtocol) {
        self.networkManager = networkManager
    }
    
    func getDevicesResponseList(urlString: String, for newList: ProducResponseKeyName = ProducResponseKeyName.defaultValue) async {
        guard let url = URL(string: urlString) else {
            customErrorList[newList.rawValue] = NetworkError.invalidUrlError
            return
        }
        let urlRequest = URLRequest(url: url)
        do {
            let data = try await networkManager.getDataFromApi(urlRequest: urlRequest)
            let productsResponse = try JSONDecoder().decode(ProductsResponse.self, from: data)
            productsResponseList[newList.rawValue] = productsResponse
            
            defaultList = productsResponse.products
            try await saveProducsListInDB(items: defaultList)
            
            customErrorList[newList.rawValue] = nil
            
        }catch let error {
            customErrorList[newList.rawValue] = NetworkError.getNetwork(error: error)
        }
    }
        
    func getCategoriesList() async {
        let errorContext = ProducResponseKeyName.categories.rawValue
        guard let url = URL(string: ApiManager.api(.list)) else {
            customErrorList[errorContext] = NetworkError.invalidUrlError
            return
        }
        let urlRequest = URLRequest(url: url)
        do {
            let data = try await networkManager.getDataFromApi(urlRequest: urlRequest)
            categoriesList = try JSONDecoder().decode(Category.self, from: data)
            customErrorList[errorContext] = nil
        }catch let error {
            customErrorList[errorContext] = NetworkError.getNetwork(error: error)
        }
    }

    func getProductsList(for category: ProducResponseKeyName = ProducResponseKeyName.defaultValue) -> [Product]? {
        productsResponseList[category.rawValue]?.products
    }
    
    func getProductsError(_ category: ProducResponseKeyName = ProducResponseKeyName.defaultValue) -> NetworkError? {
        customErrorList[category.rawValue]
    }
    
}


//MARK: CoreData
extension ProductsListViewModel {
    
    func saveProducsListInDB(items: [Product]) async throws {
        let coreDataManager: ProductPersistenceManager = ProductPersistenceManager(context: context)
        try await coreDataManager.saveDataIntoDatabase(items: defaultList)
    }
    
    func getProductsListFromGenericDB() async -> [Product] {
        do {
            let coreDataManager = ProductPersistenceManager(context: context)
            let myDBList = try await coreDataManager.fetchDataFromDatabase()

            let productsList = myDBList.compactMap({Product(from: $0)})
            return productsList
        }catch let error {
            print(error.localizedDescription)
            return []
        }
    }
}

//MARK: Transactinos
extension ProductsListViewModel {
    
    func addToCartIfNeeded(_ product: Product) {
        if cartList.firstIndex(where: { $0.id == product.id }) != nil {
            return
        }
        appendNew(product: product, and: 1)
    }
    
    func addToCart(_ product: Product, quantity: Int) {
        if cartList.firstIndex(where: { $0.id == product.id }) != nil {
            updateQuantity(for: product.id, with: quantity)
            recalculateValues()
            return
        }
        appendNew(product: product, and: quantity)
        recalculateValues()
    }
    
    private func appendNew(product: Product, and quantity: Int) {
        var newItem = product
        newItem.quantity = quantity
        cartList.append(newItem)
        print("Add: \(newItem.title) -> \(newItem.quantity ?? 0)")
    }
    
    private func updateQuantity(for itemID: Int, with newvalue: Int) {
        guard let index = cartList.firstIndex(where: {$0.id == itemID}) else {
            return
        }
        var newItem = cartList[index]
        newItem.quantity = newvalue
        cartList[index] = newItem
        print("Update: \(newItem.title) -> \(String(describing: newItem.quantity))")
    }
    
    func deleteFromCart(_ product: Product) {
        guard let index = cartList.firstIndex(where: { $0.id == product.id }) else {
            return
        }
        print("Remove: \(product.title) - index: \(index) -> \(cartList[index])")
        cartList.remove(at: index)
        recalculateValues()
    }
    
    func deleteEntireProductFromCart(_ product: Product) {
        print(product)
    }
    
    func deleteItem(at index: Int) {
        cartList.remove(at: index)
        recalculateValues()
    }

//    func makePayment(completion: @escaping (Bool) -> Void) {
    func makePayment() {
        var paymentItems: [PKPaymentSummaryItem] = []
        var summaryItems: [PKPaymentSummaryItem] = []

        var subtotalAmount = 0
        cartList.forEach { product in
            let quantity = (product.quantity ?? 1)
            let totalByItem = product.price * quantity
            let extraQuantitytext = quantity > 1 ? " x \(quantity)" : ""
            subtotalAmount += totalByItem
            summaryItems.append(
                PKPaymentSummaryItem(
                    label: "\(product.title)\(extraQuantitytext)",
                    amount: NSDecimalNumber(value: totalByItem)
                )
            )
        }
        let totalAmount = subtotalAmount - totalDiscountAmount
        paymentItems.append(contentsOf: summaryItems)
        paymentItems.append(PKPaymentSummaryItem(label: "Subtotal amount", amount: NSDecimalNumber(value: subtotalAmount), type: .final))
        paymentItems.append(PKPaymentSummaryItem(label: "Total Discounts", amount: NSDecimalNumber(value: totalDiscountAmount), type: .final))
        paymentItems.append(PKPaymentSummaryItem(label: "WellShop's Checkout", amount: NSDecimalNumber(value: totalAmount), type: .final))

        paymentManager.payNowButtonTapped(summaryItems: paymentItems) { status in
            
            self.paymentStatus = status
            self.cartList = (status == .success) ? [] : self.cartList

            if status == .success {
                self.paymentFinished = true
            }
            if status == .failure || status == .none || status == .inProcess {
                self.paymentFinished = false
            }
            print("Payment Status:", self.paymentStatus)
            print("Payment Progress:", self.paymentFinished)
        }

    }
    
    private func recalculateValues() {
        calculateStotalAmount()
        calculateTotalDiscount()
        calculateTotalAmount()
    }
    
    private func calculateStotalAmount() {
        var sum = 0
        for item in cartList {
            sum = sum + (item.price * (item.quantity ?? 0))
        }
        subtotalAmount = sum
        print("new subtotal: \(sum)")
    }
    
    private func calculateTotalDiscount() {
        var discount = 0
        cartList.forEach { item in
            discount = discount + Int( Double((item.price * (item.quantity ?? 0))) * (item.discountPercentage / 100) )
        }
        totalDiscountAmount = discount
        print("new discount: \(discount)")
    }
    
    private func calculateTotalAmount() {
        totalAmount = subtotalAmount - totalDiscountAmount
        print("new totalAmount: \(totalAmount)")
    }


}


//MARK: Extra examples of Network data
extension ProductsListViewModel {
    
    func getUserDataFrom(urlString: String, for newList: ProducResponseKeyName = ProducResponseKeyName.defaultValue) async {
            guard let url = URL(string: urlString) else {
                customErrorList[newList.rawValue] = NetworkError.invalidUrlError
                return
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                let jsonData = try JSONEncoder().encode(UserSignInData(user: "exampleUser", password: "1234567890"))
                urlRequest.httpBody = jsonData
                let data = try await networkManager.getDataFromApi(urlRequest: urlRequest)
                userInfo = try JSONDecoder().decode(UserInfo.self, from: data)
                print(userInfo as Any)
                customErrorList[newList.rawValue] = nil
            }catch let error {
                customErrorList[newList.rawValue] = NetworkError.getNetwork(error: error)
            }
        }
}

