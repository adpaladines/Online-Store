//
//  UserData.swift
//  TheSoundsStore
//
//  Created by Andres D. Paladines on 7/23/23.
//

import Foundation

// MARK: - UserInfo
struct UserInfo: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let fullName, firstName, middleName, lastName: String
    let message: String
    let accounts: [Account]
}

// MARK: - Account
struct Account: Codable {
    let type: String
    let balance: Double
    let number: String
}
