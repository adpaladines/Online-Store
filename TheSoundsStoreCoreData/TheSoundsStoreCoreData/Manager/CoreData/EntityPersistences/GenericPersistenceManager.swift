//
//  GenericPersistenceManager.swift
//  TheSoundsStoreCoreData
//
//  Created by Andres D. Paladines on 7/25/23.
//

import Foundation
import CoreData

protocol CoreDataGenericOperationsProtocol {
//    var context: NSManagedObjectContext { get }
    
//    init(context: NSManagedObjectContext)
    func fetchDataFromDatabase<T: NSManagedObject>(entity: T) async throws -> [T]
    func clearData<T: NSManagedObject>(entity: T) async throws
//    func saveDataIntoDatabase<T>(items: [T], type: T.Type) async throws
}

class GenericPersistenceManager: CoreDataGenericOperationsProtocol {
    
//    let context: NSManagedObjectContext
//
//    required init(context: NSManagedObjectContext) {
//        self.context = context
//    }
    
    func fetchDataFromDatabase<T: NSManagedObject>(entity: T) async throws -> [T] {
//        try await PersistenceController.shared.container.performBackgroundTask { privateContext in
            guard let entityName = T.entity().name else {
                throw NSError(domain: "Invalid entity name", code: 0, userInfo: nil)
            }
            let request: NSFetchRequest<T> = NSFetchRequest<T>(entityName: entityName)
            let result = try privateContext.fetch(request)
            let newResult = result.filter({ $0.isFault })
            return newResult
//        }
    }
    
    func clearData<T: NSManagedObject>(entity: T) async throws {
        guard let entityName = T.entity().name else {
            throw NSError(domain: "Invalid entity name", code: 0, userInfo: nil)
        }
        try await PersistenceController.shared.container.performBackgroundTask { privateContext in
            let request: NSFetchRequest<T> = NSFetchRequest<T>(entityName: entityName)
            let results = try privateContext.fetch(request)
            results.forEach { entity in
                privateContext.delete(entity)
            }
            try privateContext.save()
        }
    }
    
}
