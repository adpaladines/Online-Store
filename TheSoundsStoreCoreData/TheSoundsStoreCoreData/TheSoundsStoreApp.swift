//
//  TheSoundsStoreApp.swift
//  TheSoundsStore
//
//  Created by Andres D. Paladines on 7/17/23.
//

import SwiftUI

@main
struct TheSoundsStoreApp: App {
    
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
//            TabBarControllerScreen()
            TabBarControllerScreen()
                .environmentObject(ProductsListViewModel(networkManager: NetworkManager()))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

//@UIApplicationDelegateAdaptor
//class AppDelegate {
//
//}
