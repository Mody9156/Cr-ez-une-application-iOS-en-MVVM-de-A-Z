// RegisterUserModel.swift
// Vitesse
//
// Created by KEITA on 14/05/2024.
//

import Foundation

enum AuthenticationError: Error ,Equatable {
  
  
    static func == (lhs:AuthenticationError, rhs: AuthenticationError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.encodingFailed, .encodingFailed),
             (.unknownError, .unknownError):
            return true
        case (.requestFailed(let lhsError), .requestFailed(let rhsError)):
            return (lhsError as NSError).domain == (rhsError as NSError).domain && (lhsError as NSError).code == (rhsError as NSError).code
        case (.decodingFailed(let lhsError), .decodingFailed(let rhsError)):
            return (lhsError as NSError).domain == (rhsError as NSError).domain && (lhsError as NSError).code == (rhsError as NSError).code
        default:
            return false
        }
    }
    
    case invalidURL
    case encodingFailed
    case requestFailed(Error)
    case decodingFailed(Error)
    case unknownError
}

class AuthenticationManager {
    
    let httpService: HTTPService
    
    init(httpService: HTTPService = URLSessionHTTPClient()) {
        self.httpService = httpService
    }
    
 
    
    func buildAuthenticationRequest(username: String, password: String) throws -> URLRequest {
        
        guard let url = URL(string: "http://127.0.0.1:8080/user/auth") else {
            throw AuthenticationError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let authentificationModel = URLRequestEncodingModel(email: username, password: password)
        guard let data = try? JSONEncoder().encode(authentificationModel) else {
            throw AuthenticationError.encodingFailed
        }
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func authenticate(username: String, password: String) async throws -> JSONResponseDecodingModel {
        do {
            let request = try buildAuthenticationRequest(username: username, password: password)
            let (data, _) = try await httpService.request(request)
            let json = try JSONDecoder().decode(JSONResponseDecodingModel.self, from: data)
            return json
        } catch let error as AuthenticationError {
            throw error
        } catch let error {
            throw AuthenticationError.requestFailed(error)
        }
    }
}
