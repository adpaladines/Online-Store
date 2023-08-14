//
//  FakeNetworkManager.swift
//  TheSoundsStore
//
//  Created by Andres D. Paladines on 7/19/23.
//

import Foundation

class FakeNetworkManager: NetworkAbleProtocol {
        
    func getDataFromApi(urlRequest: URLRequest) async throws -> Data {
        let bundle = Bundle(for: FakeNetworkManager.self)
        guard let url = bundle.url(forResource: urlRequest.url!.absoluteString, withExtension: "json") else {
            throw NetworkError.invalidUrlError
        }
        do {
            let data = try Data(contentsOf: url)
            return data
        }catch {
            print(error.localizedDescription)
            throw error
        }
    }
        
}
