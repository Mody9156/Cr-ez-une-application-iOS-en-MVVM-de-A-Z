//
//  retrieveCandidateData.swift
//  Vitesse
//
//  Created by KEITA on 23/05/2024.
//
//
//import Foundation
//

import Foundation

class retrieveCandidateData{
    
    let httpService: HTTPService

    init(httpService: HTTPService = BasicHTTPClient()) {
        self.httpService = httpService
    }

    enum CandidateFetchError: Error {
        case networkError
    }

    func fetchCandidateDetailsById(request : URLRequest) async throws -> [CandidateInformation] {
        do {
            let request =  request
            let (data, _) = try await httpService.request(request)
            let candidates = try JSONDecoder().decode([CandidateInformation].self, from: data)
            return candidates
        }catch{
            throw CandidateFetchError.networkError
        }
    }
    
   

}

