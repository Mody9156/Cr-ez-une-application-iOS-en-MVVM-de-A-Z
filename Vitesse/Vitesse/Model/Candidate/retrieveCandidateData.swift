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
        case networkError,httpResponseInvalid,processCandidateElementsError
        case fetchCandidateDataFavoris
        case NetworkError
    }
    
    func fetchCandidateData(request : URLRequest) async throws -> [CandidateInformation] {
        do {
            let request =  request
            let (data, _) = try await httpService.request(request)
            let candidates = try JSONDecoder().decode([CandidateInformation].self, from: data)
            
            return candidates
        }catch{
            throw CandidateFetchError.networkError
        }
        
    }
    func fetchCandidateDetaille(request : URLRequest) async throws -> CandidateInformation {
        do {
            let request =  request
            let (data, _) = try await httpService.request(request)
            let candidates = try JSONDecoder().decode(CandidateInformation.self, from: data)
            
            return candidates
        }catch{
            throw CandidateFetchError.networkError
        }
        
    }
 
  
    func fetchCandidateDataFavoris(request : URLRequest) async throws -> CandidateInformation {
        do {
            let request =  request
            let (data, _) = try await httpService.request(request)
            return try JSONDecoder().decode(CandidateInformation.self, from: data)
            
        }catch{
            print("error ", error)
            throw CandidateFetchError.fetchCandidateDataFavoris
        }
        
    }
   
    
    func validateHTTPResponse(request: URLRequest) async throws -> HTTPURLResponse {
        let (_, response) = try await httpService.request(request)
        
        
        guard  response.statusCode == 200 else {
            throw CandidateFetchError.httpResponseInvalid
        }
        
        
        return response
    }

    func fetchCandidateInformation(token: String, id: String,phone:String?,note:String?,firstName:String,linkedinURL: String?,isFavorite: Bool,email:String,lastName: String,request : URLRequest) async throws -> CandidateInformation {
        
        let (data,_) = try await httpService.request(request)
        
       guard let jsonDecode = try? JSONDecoder().decode(CandidateInformation.self, from: data)
        else {
            throw CandidateFetchError.networkError
        }
        return jsonDecode
    }
   
    
}
