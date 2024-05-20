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
        
    }
    
    func fetchURLRequest(token:String) -> URLRequest{
        var url = URL(string: "http://127.0.0.1:8080/candidate/:candidateId")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "Get"
        let stock = "Bearer " + token
        request.setValue( stock , forHTTPHeaderField: "Authorization")
        return request
        
        
    }
    
    func fetchCandidateSubmission(token:String) async throws -> HTTPURLResponse {
        do{
            let request = fetchURLRequest(token: token)
            let (response,_) = try await httpService.request(request)
            guard let httpreponse = try JSONDecoder().decode([RecruitTech].self, from: data)
            return candidats
        }catch{
            throw URLRequestError.invalidGeToken
        }
        
    }
}
