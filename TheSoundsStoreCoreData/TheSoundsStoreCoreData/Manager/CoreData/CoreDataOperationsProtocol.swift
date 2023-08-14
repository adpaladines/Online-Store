//
//  CoreDataOperationsProtocol.swift
//  TheSoundsStoreCoreData
//
//  Created by Andres D. Paladines on 7/24/23.
//

import Foundation

protocol CoreDataOperationsProtocol {
    
    func saveDataIntoDatabase(items: [Product]) async throws
    
}
