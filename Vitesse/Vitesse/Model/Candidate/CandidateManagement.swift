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
        let authHeader = "Bearer" + token
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return request
    }
    static func createURLRequestFavoris(url:String,method:String,token:String) throws -> URLRequest{
        let url = URL(string: url)!
        var request  = URLRequest(url: url)
        request.httpMethod = method
        let authHeader = "Bearer " + token
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
   static func createURLRequesttt(url:String,method:String,token:String) throws -> URLRequest{
       let url = URL(string: url)!
        var request  = URLRequest(url: url)
        request.httpMethod = method
        let authHeader = "Bearer " + token
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    static func createURLRequestfornewcandidat(url:String,method:String,token:String, id: String,phone:String?,note:String?,firstName:String,linkedinURL: String?,isFavorite: Bool,email:String,lastName: String) throws -> URLRequest{
        let url = URL(string: url)!
         var request  = URLRequest(url: url)
         request.httpMethod = method
        let data = CandidateInformation(phone: phone, note: note, id: id, firstName: firstName, linkedinURL: linkedinURL, isFavorite: isFavorite, email: email, lastName: lastName)
        let body = try? JSONEncoder().encode(data)
        request.httpBody = body
         let authHeader = "Bearer " + token
         request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

         return request
     }
    
}
