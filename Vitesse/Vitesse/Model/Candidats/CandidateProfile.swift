//
//  Candidats.swift
//  Vitesse
//
//  Created by KEITA on 17/05/2024.
//

import Foundation

class CandidateProfile {
    
    let httpService : HTTPService
    
    init(httpService: HTTPService = BasicHTTPClient()) {
        self.httpService = httpService
    }
    
    enum URLRequestError: Error {
        case invalidRequest
        case invalidMethod
        case invalidBody
    }
    
    func fetchURLRequest(token:String) -> URLRequest{
        let url = URL(string: "http://127.0.0.1:8080/candidate")!
        var request = URLRequest(url: url)
        request.httpMethod = "Get"
        print("request httpMethod : \(String(describing: request.httpMethod))")
        let stock = "Bearer " + token
        print("stock\(stock)")
        request.setValue( stock , forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchCandidateSubmission(token:String) async throws ->  [RecruitTech] {
        let request = fetchURLRequest(token: token)
        let (data,_) = try await httpService.request(request)
        print("data : \(data)")
        print("request : \(request)")

        let candidats = try JSONDecoder().decode([RecruitTech].self, from: data)
        print("candidats : \(candidats)")

        return candidats
    }
    
    
}
