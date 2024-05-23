//
//  CandidateManagement.swift
//  Vitesse
//
//  Created by KEITA on 23/05/2024.
//

import Foundation

struct CandidateManagement {
    
    static func createURLRequest(url:String,method:String,token:String,id:String) throws -> URLRequest{
        let url = URL(string: url)!
        var request  = URLRequest(url: url)
        request.httpMethod = method
        let authHeader = "Bearer " + token
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        return request
    }
    
   static func createURLRequesttt(url:String,method:String,token:String) throws -> URLRequest{
       let url = URL(string: url)!
        var request  = URLRequest(url: url)
        request.httpMethod = method
        let authHeader = "Bearer " + token
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        return request
    }
    
    
   
}
