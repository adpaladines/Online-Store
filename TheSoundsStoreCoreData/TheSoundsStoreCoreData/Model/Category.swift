//
//  Category.swift
//  TheSoundsStore
//
//  Created by Andres D. Paladines on 7/17/23.
//

import Foundation

typealias Category = [String]


enum CategoryFilt: String {
    case headphone = "Headphones"
    case earphone = "Earphones"
    case headset = "Headset"
    
    case laptop = "lenovo"
    case macbookAir = "macair"
    case macbookPro13 = "macpro-13"
    case macbookPro14_16 = "macpro-14-16"
}

struct CategoryFilter: Identifiable {
    
    var uuid: String = UUID().uuidString
//    var name: String
    var image: String
    var category: CategoryFilt
    
    var id: String {
        return self.uuid
    }
    
    static func getCategories() -> [CategoryFilter] {
        [
            CategoryFilter(image: "headphone-1", category: .headphone),
            CategoryFilter(image: "earphone-1", category: .earphone),
            CategoryFilter(image: "headset-1", category: .headset)
        ]
    }
}
