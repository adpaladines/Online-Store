//
//  ProductsResponse.swift
//  TheSoundsStoreCoreData
//
//  Created by Andres D. Paladines on 7/24/23.
//

import Foundation

struct ProductsResponse: Codable {
    
    let products: [Product]
    let total, skip, limit: Int
    
    static func getTheSound() -> [Product] {
        [
            Product(id: 1, title: "iPhone 4", description: "This is a headphone not from Apple", price: 135, discountPercentage: 5.45, rating: 3.4, stock: 150, brand: "Apple", category: "smartphones", thumbnail: "https://i.dummyjson.com/data/products/2/thumbnail.jpg", images: ["https://i.dummyjson.com/data/products/1/1.jpg", "https://i.dummyjson.com/data/products/1/2.jpg", "https://i.dummyjson.com/data/products/1/3.jpg", "https://i.dummyjson.com/data/products/1/4.jpg", "https://i.dummyjson.com/data/products/1/thumbnail.jpg"]),
            
            Product(id: 2, title: "Iphone 3GS", description: "This is a headphone not from Apple", price: 135, discountPercentage: 5.45, rating: 4.9, stock: 78, brand: "Apple", category: "smartphones", thumbnail: "https://i.dummyjson.com/data/products/3/2.jpg", images: ["https://i.dummyjson.com/data/products/3/1.jpg", "https://i.dummyjson.com/data/products/1/3.jpg", "https://i.dummyjson.com/data/products/3/3.jpg", "https://i.dummyjson.com/data/products/3/4.jpg", "https://i.dummyjson.com/data/products/3/thumbnail.jpg"])
        ]
    }
    
    
    static func getTheProcess() -> [Product] {
        [
            Product(id: 1, title: "iMac 11", description: "This is a headphone not from Apple", price: 135, discountPercentage: 5.45, rating: 5, stock: 10, brand: "Apple", category: "smartphones", thumbnail: "https://i.dummyjson.com/data/products/4/thumbnail.jpg", images: ["https://i.dummyjson.com/data/products/1/1.jpg", "https://i.dummyjson.com/data/products/1/2.jpg", "https://i.dummyjson.com/data/products/1/3.jpg", "https://i.dummyjson.com/data/products/1/4.jpg", "https://i.dummyjson.com/data/products/1/thumbnail.jpg"]),
            Product(id: 2, title: "Macbook Pro 14", description: "This is a headphone not from Apple", price: 135, discountPercentage: 5.45, rating: 5, stock: 65, brand: "Apple", category: "smartphones", thumbnail: "https://i.dummyjson.com/data/products/9/thumbnail.jpg", images: [
                "https://i.dummyjson.com/data/products/9/1.jpg", "https://i.dummyjson.com/data/products/4/2.png", "https://i.dummyjson.com/data/products/9/3.png", "https://i.dummyjson.com/data/products/9/4.jpg", "https://i.dummyjson.com/data/products/9/thumbnail.jpg"])
        ]
    }
    
}

// MARK: - Product
struct Product: Codable, Identifiable, Equatable {
    let id: Int
    let title, description: String
    let price: Int
    let discountPercentage, rating: Double
    let stock: Int
    let brand, category: String
    let thumbnail: String
    let images: [String]
    var quantity: Int?
    
    init(id: Int, title: String, description: String, price: Int, discountPercentage: Double, rating: Double, stock: Int, brand: String, category: String, thumbnail: String, images: [String], quantity: Int? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.discountPercentage = discountPercentage
        self.rating = rating
        self.stock = stock
        self.brand = brand
        self.category = category
        self.thumbnail = thumbnail
        self.images = images
        self.quantity = quantity
    }
    
    init(from productEntity: ProductEntity) {
        self.id = Int(productEntity.id) 
        self.title = productEntity.title  ?? ""
        self.description = productEntity.itemDescription ?? ""
        self.price = Int(productEntity.price)
        self.discountPercentage = productEntity.discountPercentage
        self.rating = productEntity.rating
        self.stock = Int(productEntity.stock)
        self.brand = productEntity.brand ?? ""
        self.category = productEntity.category ?? ""
        self.thumbnail = productEntity.thumbnail ?? ""
        self.images = productEntity.images ?? []
        self.quantity = Int(productEntity.quantity)
    }
    
    
}
