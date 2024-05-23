//
//  CandidateManagement.swift
//  Vitesse
//
//  Created by KEITA on 23/05/2024.
//

import Foundation

enum CandidateManagement {
    
    func createURLRequest(url:String,method:String,token:String,id:String) -> URLRequest{
        var url = URL(string: url)!
        var request  = URLRequest(url: url)
        request.httpMethod = method
        let authHeader = "Bearer " + token
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        return request
    }
    
    func createURLRequesttt(url:String,method:String,token:String) -> URLRequest{
        var url = URL(string: url)!
        var request  = URLRequest(url: url)
        request.httpMethod = method
       
        return request
    }
   
}
