//
//  NetworkingService.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 12.12.23.
//

import Foundation

enum NetworkingError: Error {
    case badUrl, badData
}

class NetworkingService {
    static let shared = NetworkingService(); private init() {}
    
    
    
    private func createURL() -> URL? {
        let tunnel = "https://"
        let server = "catfact.ninja"
        let endPoint = "/fact"
        let getParams = ""
        
        let urlStr = tunnel + server + endPoint + getParams
        let url = URL(string: urlStr)
        return url
    }
    
    func fetchData() async throws -> Data {
        guard let url = createURL() else { throw NetworkingError.badUrl }
        
        guard let response = try? await URLSession.shared.data(from: url) else { throw NetworkingError.badData }
        return response.0
    }
    
}
