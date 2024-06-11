//
//  CandidateDataManagerTests.swift
//  VitesseTests
//
//  Created by KEITA on 11/06/2024.
//

import XCTest
@testable import Vitesse

final class CandidateDataManagerTests: XCTestCase {
    var candidateDataManager : CandidateDataManager!
    
    override func setUp()  {
        super.setUp()
        candidateDataManager = CandidateDataManager(httpService: MockHTTPService())
    }

    override func tearDown()  {
        super.tearDown()
        candidateDataManager = nil
    }

    func testFetchCandidateData() async throws {
        //Given
        let candidateJSON = """
                [{
                    "phone" : "0122333344",
                    "note": "Développeur en Backend",
                    "id" : "vzbjkzjbinkjzbjkz4254",
                    "firstName": "William",
                    "linkedinURL": "https://www.linkedin.com/in/William-William-123456789/",
                    "isFavorite": true,
                    "email" : "William.Browm@gmail.com",
                    "lastName": "Browm"
                }]
                """.data(using: .utf8)!
        
        struct CandidateEncode: Identifiable, Decodable, Hashable {
                   var phone, note: String?
                   var id, firstName: String
                   var linkedinURL: String?
                   var isFavorite: Bool
                   var email, lastName: String
               }
               
               let expectedCandidates = try JSONDecoder().decode([CandidateEncode].self, from: candidateJSON)
               let expectedCandidate = expectedCandidates.first
               
               let url = URL(string: "https://example.com")!
               var request = URLRequest(url: url)
               
               let mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
               let response: (Data, HTTPURLResponse) = (candidateJSON, mockResponse)
               (candidateDataManager.httpService as! MockHTTPService).mockResult = response
               
               // When
               let fetchedCandidates = try await candidateDataManager.fetchCandidateData(request: request)
        do{
            // When
            let Candidates = try await candidateDataManager.fetchCandidateData(request: request)
            
            //Then
            XCTAssertEqual(Candidates.count, 1)
            
            let fetchedCandidate = Candidates.first
            XCTAssertNotNil(fetchedCandidate)
            XCTAssertEqual(fetchedCandidate?.phone, expectedCandidate?.phone)
            XCTAssertEqual(fetchedCandidate?.note, expectedCandidate?.note)
            XCTAssertEqual(fetchedCandidate?.id, expectedCandidate?.id)
            XCTAssertEqual(fetchedCandidate?.firstName, expectedCandidate?.firstName)
            XCTAssertEqual(fetchedCandidate?.linkedinURL, expectedCandidate?.linkedinURL)
            XCTAssertEqual(fetchedCandidate?.isFavorite, expectedCandidate?.isFavorite)
            XCTAssertEqual(fetchedCandidate?.email, expectedCandidate?.email)
            XCTAssertEqual(fetchedCandidate?.lastName, expectedCandidate?.lastName)
        }catch {
            XCTFail("Unexpected error: \(error)")        }
           }
    
    func testInvalidFetchCandidateData() async throws {
            // Given
            let url = URL(string: "https//exemple.com")!
            let request = URLRequest(url: url)
        
        let mockResponse = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
            let response: (Data, HTTPURLResponse) = (Data(), mockResponse)
            (candidateDataManager.httpService as! MockHTTPService).mockResult = response
            
            // When
            do {
                let candidates = try await candidateDataManager.fetchCandidateData(request: request)
                
                // Then
                XCTAssertEqual(candidates.count, 1, "Le nombre de candidats récupérés est incorrect")
            } catch let error as CandidateDataManager.CandidateFetchError {
                XCTAssertEqual(error, .fetchCandidateDataError, "L'erreur retournée n'est pas celle attendue")
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
        

    func testfetchCandidateDetail() throws {
      
    }
    
    func testvalidateHTTPResponse() throws {
        
    }
    
    func testfetchCandidateInformation() throws {
        
    }
    // Mock HTTPService utilisé pour simuler les réponses HTTP
    class MockHTTPService: HTTPService {
          
          var mockResult: (Data, HTTPURLResponse)?
          
          func request(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
              guard let result = mockResult else {
                  throw NSError(domain: "", code: 0, userInfo: nil)
              }
              return result
          }
      }
}
