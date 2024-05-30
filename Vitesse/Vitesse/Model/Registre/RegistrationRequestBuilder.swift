//
//  RegistrationRequestBuilder.swift
//  Vitesse
//
//  Created by KEITA on 16/05/2024.
//

import Foundation

class RegistrationRequestBuilder {
    
    let httpService : HTTPService
    
    init(httpService: URLSessionHTTPClient) {
        self.httpService = httpService
    }
    
    enum HTTPResponseError: Error {
        case invalidResponse(statusCode: Int)
        case networkError(Error)
    }

    
    func buildRegistrationURLRequest(email: String, password: String, firstName: String, lastName: String) -> URLRequest {
        
        let url = URL(string: "http://127.0.0.1:8080/user/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let data = RegistrationRequestBody(email: email, password: password, firstName: firstName, lastName: lastName)
        let body = try? JSONEncoder().encode(data)
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    func buildRegistrationRequest(email: String, password: String, firstName: String, lastName: String) async throws -> HTTPURLResponse {
        let (_,response) = try await httpService.request(buildRegistrationURLRequest(email: email, password: password, firstName: firstName, lastName: lastName))
        
        guard response.statusCode == 201  else {
            throw HTTPResponseError.invalidResponse(statusCode: response.statusCode)
            
        }
        return response
    }
    
}
