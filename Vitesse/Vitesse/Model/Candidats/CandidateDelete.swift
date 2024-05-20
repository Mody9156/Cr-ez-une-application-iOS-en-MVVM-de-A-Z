//
//  candidateDelete.swift
//  Vitesse
//
//  Created by KEITA on 20/05/2024.
//

import Foundation

class CandidateDelete {
    
    let httpService : HTTPService
    
    init(httpService: HTTPService = BasicHTTPClient()) {
        self.httpService = httpService
    }
    
    
    enum URLRequestError: Error {
        case invalidGeToken
        case httpresponseInvalid
        
    }
    
    func fetchURLRequest(token:String,CandidateId:String) -> URLRequest{
        var url = URL(string: "http://127.0.0.1:8080/candidate/\(CandidateId)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "Get"
        let stock = "Bearer " + token
        request.setValue( stock , forHTTPHeaderField: "Authorization")
        return request
        
        
    }
    
    func deleteCandidate(token:String,CandidateId:String) async throws -> HTTPURLResponse {
        
            let request = fetchURLRequest(token: token,CandidateId: CandidateId)
            let (_,response) = try await httpService.request(request)
            
            guard let httpreponse = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw URLRequestError.httpresponseInvalid
            }
            return httpreponse
      
        
    }
}
