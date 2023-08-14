//
//  ProductPersistenceManager.swift
//  TheSoundsStoreCoreData
//
//  Created by Andres D. Paladines on 7/24/23.
//

import Foundation
import CoreData

class ProductPersistenceManager: CoreDataOperationsProtocol {
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveDataIntoDatabase(items: [Product]) async throws {
        try await deleteAllRecords()
                
        await PersistenceController.shared.container.performBackgroundTask { privateContext in
            items.forEach { item in
                let productEntity = ProductEntity(context: privateContext)
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
                try privateContext.save()
            }catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteAllRecords() async throws {
        do {
            let coreDataGenericManager: GenericPersistenceManager = GenericPersistenceManager()
            let productEntity = ProductEntity(context: PersistenceController.shared.container.viewContext)
            try await coreDataGenericManager.clearData(entity: productEntity)
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
}

