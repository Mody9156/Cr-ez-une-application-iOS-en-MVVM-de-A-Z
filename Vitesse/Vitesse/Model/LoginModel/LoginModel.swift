//
//  LoginModel.swift
//  Vitesse
//
//  Created by KEITA on 14/05/2024.
//

import Foundation

class LoginModel{
    
    let httpService :  BasicHTTPClient
    
    init(httpService: BasicHTTPClient) {
        self.httpService = httpService
    }
    
    enum InvalidRequest : Error {
    case TokenInvalid
    }
    
    func urlRequest() -> URLRequest {
        let url = URL(string: "http://127.0.0.1:8080/user/auth")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let data = try JSONEncoder().encode(AuthentificationModel.self)
        request.httpBody = data
        return request
    }
    
    
    func authentification() throws -> AuthentificationModel {
        let (data,response) = try httpService(urlRequest)
        
        guard let json = try JSONDecoder().decode(AuthentificationModel.self, from:data),
        let token = json["token"],
        let isAdmin = json["isAdmin"]
        else {
            throw InvalidRequest.TokenInvalid
        }
    }
    
    
    
}
