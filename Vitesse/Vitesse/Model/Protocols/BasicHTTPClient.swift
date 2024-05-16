//
//  BasicHTTPClient.swift
//  Vitesse
//
//  Created by KEITA on 14/05/2024.
//

import Foundation

final class BasicHTTPClient: HTTPService {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    private enum AuthenticationFailure: Swift.Error {
        case invalidRequest
    }
    
    func request(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthenticationFailure.invalidRequest
        }
        
        return (data, httpResponse)
    }
}
