//
//  candidateId.swift
//  Vitesse
//
//  Created by KEITA on 20/05/2024.
//

import Foundation

class candidateId {

    let httpService : HTTPService

    init(httpService: HTTPService = BasicHTTPClient()) {
        self.httpService = httpService
    }

    enum URLRequestError: Error {
        case invalidGeToken

    }

    func fetchURLRequest(token:String,candidate : String) -> URLRequest{
            var url = URL(string: "http://127.0.0.1:8080/candidate/\(candidate)")!

            var request = URLRequest(url: url)
            request.httpMethod = "Get"
            let stock = "Bearer " + token
            request.setValue( stock , forHTTPHeaderField: "Authorization")
            return request


    }

    func fetchCandidateSubmission(token:String,candidate : String) async throws ->  [RecruitTech] {
        do{
            let request = fetchURLRequest(token: token, candidate: candidate)
            let (data,_) = try await httpService.request(request)
                   let candidats = try JSONDecoder().decode([RecruitTech].self, from: data)
            return candidats
        }catch{
            throw URLRequestError.invalidGeToken
        }

    }

}
