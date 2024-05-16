//
//  RegisterUserModel.swift
//  Vitesse
//
//  Created by KEITA on 14/05/2024.
//

import Foundation

class AuthenticationManager {
    
    let httpService: BasicHTTPClient
    
    init(httpService: BasicHTTPClient = BasicHTTPClient()) {
        self.httpService = httpService
    }
    
    
    func buildAuthenticationRequest(username: String, password: String) -> URLRequest {
        let url = URL(string: "http://127.0.0.1:8080/user/auth")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let authentificationModel = URLRequestEncodingModel(email: username, password: password)
        let data = try? JSONEncoder().encode(authentificationModel)
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    
    func authenticate(username: String, password: String) async throws -> JSONResponseDecodingModel {
        let (data, _) = try await httpService.request(buildAuthenticationRequest(username: username, password: password))
        
        let json = try JSONDecoder().decode(JSONResponseDecodingModel.self, from: data)
        
        return json
    }
}
