//
//  NetworkManager.swift
//  MVVMAPICallSwiftUI
//
//  Created by Andres D. Paladines on 7/18/23.
//

import Foundation

class NetworkManager: NetworkAbleProtocol {
    
    var networkDelegate: NetworkResponseProtocol?
    
    func getDataFromApi(urlRequest:URLRequest) async throws -> Data {
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            if let httpResponse = response as? HTTPURLResponse,
               (httpResponse.statusCode > 199 && httpResponse.statusCode < 299) {
                return data
            }else {
                throw NetworkError.responseError
            }
        } catch {
            switch error {
            case NetworkError.responseError:
                throw NetworkError.responseError
            default:
                throw NetworkError.dataNotFoundError
            }
        }
    }
}

