//
//  CandidateUpdater.swift
//  Vitesse
//
//  Created by KEITA on 21/05/2024.
//

import Foundation

class CandidateUpdater {
    let httpService: HTTPService

    init(httpService: HTTPService = BasicHTTPClient()) {
        self.httpService = httpService
    }

    enum CandidateFetchError: Error {
        case networkError
    }
    
    
}
