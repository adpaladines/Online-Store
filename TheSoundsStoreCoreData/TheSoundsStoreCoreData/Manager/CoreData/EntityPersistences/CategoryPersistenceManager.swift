//
//  CategoryPersistenceManager.swift
//  TheSoundsStoreCoreData
//
//  Created by Andres D. Paladines on 7/24/23.
//

import Foundation
import CoreData

class CategoryPersistenceManager: CoreDataOperationsProtocol {
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveDataIntoDatabase(items: [Product]) async throws {
        try await deleteAllRecords()
        
        items.forEach { item in
            let productEntity = ProductEntity(context: context)
            productEntity.id = Int32(item.id)
            productEntity.title = item.title
            productEntity.itemDescription = item.description
            productEntity.price = Int64(item.price)
            productEntity.discountPercentage = item.discountPercentage
            productEntity.rating = item.rating
            productEntity.stock = Int64(item.stock)
            productEntity.brand = item.brand
            productEntity.category = item.category
            productEntity.thumbnail = item.thumbnail
            productEntity.images = item.images
            productEntity.quantity = Int64(item.quantity ?? 0)
        }
        
        do {
            try context.save()
        }catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    func deleteAllRecords() async throws {
        do {
            let dbList = try await getDataFromDatabase()
            dbList.forEach { entity in
                context.delete(entity)
            }
            try context.save()
            print("All records were deleted.")
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getDataFromDatabase() async throws -> [ProductEntity] {
        let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        let result = try context.fetch(request)
        return result
    }
}

