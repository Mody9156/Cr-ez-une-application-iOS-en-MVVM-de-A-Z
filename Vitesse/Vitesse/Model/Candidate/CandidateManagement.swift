//
//  CandidateManagement.swift
//  Vitesse
//
//  Created by KEITA on 23/05/2024.
//

import Foundation

class CandidateManagement {
    
    let httpService: HTTPService

    init(httpService: HTTPService = BasicHTTPClient()) {
        self.httpService = httpService
    }

    enum CandidateFetchError: Error {
        case networkError
        case httpResponseInvalid
    }
    
    func  createURLRequest(url:String,method:String,token:String) -> URLRequest{
        var url = URL(string: url)!
        var request  = URLRequest(url: url)
        request.httpMethod = method
        let authHeader = "Bearer " + token
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        return request
    }
    
    
    
    
    
    
}
