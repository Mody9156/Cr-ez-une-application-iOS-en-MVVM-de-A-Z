//
//  RegisterUserModel.swift
//  Vitesse
//
//  Created by KEITA on 14/05/2024.
//


import Foundation

class RegisterUserModel{
    
    let httpService :  BasicHTTPClient
    
    init(httpService: BasicHTTPClient) {
        self.httpService = httpService
    }
    
    enum InvalidRequest : Error {
    case TokenInvalid
    }
    
    func urlRequest(username :String , password : String)  -> URLRequest {
        let url = URL(string: "http://127.0.0.1:8080/user/auth")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let authentificationModel = AuthentificationModel(email: username, password: password)
        let data = try? JSONEncoder().encode(authentificationModel)
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    
    func authentification(username :String , password : String ) async throws -> (String,String) {
        let (data,_) = try await httpService.request(urlRequest(username: username, password: password))
        
        guard let json = try? JSONDecoder().decode([String:String].self, from:data),
        let token = json["token"],
        let isAdmin = json["isAdmin"]
        else {
            throw InvalidRequest.TokenInvalid
        }
        return (token,isAdmin)
    }
    
    
    
}
