//
//  NetworkProtocolDelegate.swift
//  MVVMAPICallSwiftUI
//
//  Created by Andres D. Paladines on 7/18/23.
//

import Foundation

protocol NetworkAbleProtocol {
        
    func getDataFromApi(urlRequest:URLRequest) async throws -> Data 
    
}
