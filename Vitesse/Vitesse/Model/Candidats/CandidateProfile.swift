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
    
    
    func fetchURLRequest() -> URLRequest{
        
    }
    
    
}
