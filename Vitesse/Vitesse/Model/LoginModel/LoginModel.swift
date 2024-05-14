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
    
    func urlRequest() -> URLRequest {
        let url = URL(string: "http://127.0.0.1:8080/user/auth")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    
    
}
