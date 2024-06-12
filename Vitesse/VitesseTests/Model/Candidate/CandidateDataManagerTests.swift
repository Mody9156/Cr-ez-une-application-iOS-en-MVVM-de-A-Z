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
    
    struct CandidateEncode: Identifiable, Decodable, Hashable {
               var phone, note: String?
               var id, firstName: String
               var linkedinURL: String?
               var isFavorite: Bool
               var email, lastName: String
           }
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
        let request = URLRequest(url: url)
               
               let mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
               let response: (Data, HTTPURLResponse) = (candidateJSON, mockResponse)
               (candidateDataManager.httpService as! MockHTTPService).mockResult = response
               
               // When
        _ = try await candidateDataManager.fetchCandidateData(request: request)
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
        
    func testHTTPResponseErrorEquality() {
        // Given
               let error1: CandidateDataManager.CandidateFetchError = .httpResponseInvalid(statusCode: 404)
               let error2: CandidateDataManager.CandidateFetchError = .httpResponseInvalid(statusCode: 404)
               let error3: CandidateDataManager.CandidateFetchError = .fetchCandidateDataError
               let error4: CandidateDataManager.CandidateFetchError = .fetchCandidateDetailError
               let error5: CandidateDataManager.CandidateFetchError = .fetchCandidateInformationError
        // Then
               XCTAssertEqual(error1, error2)
               XCTAssertNotEqual(error1, error3)
               XCTAssertNotEqual(error1, error4)
               XCTAssertNotEqual(error1, error5)
               XCTAssertNotEqual(error3, error4)
               XCTAssertNotEqual(error3, error5)
               XCTAssertNotEqual(error4, error5)
       
    }
  
    func testfetchCandidateDetail() async throws {
        //Given
        let candidateJSON = """
                {
                    "phone" : "0122333344",
                    "note": "Développeur en Backend",
                    "id" : "vzbjkzjbinkjzbjkz4254",
                    "firstName": "William",
                    "linkedinURL": "https://www.linkedin.com/in/William-William-123456789/",
                    "isFavorite": true,
                    "email" : "William.Browm@gmail.com",
                    "lastName": "Browm"
                }
                """.data(using: .utf8)!
        
      
               
               let expectedCandidates = try JSONDecoder().decode(CandidateEncode.self, from: candidateJSON)
        let expectedCandidate = expectedCandidates
               
               let url = URL(string: "https://example.com")!
        let request = URLRequest(url: url)
               
               let mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
               let response: (Data, HTTPURLResponse) = (candidateJSON, mockResponse)
               (candidateDataManager.httpService as! MockHTTPService).mockResult = response
               
               // When
       
        do{
            let fetchedCandidates = try await candidateDataManager.fetchCandidateDetail(request: request)
            //Then
            let fetchedCandidate = fetchedCandidates
            XCTAssertNotNil(fetchedCandidate)
            XCTAssertEqual(fetchedCandidate.phone, expectedCandidate.phone)
            XCTAssertEqual(fetchedCandidate.note, expectedCandidate.note)
            XCTAssertEqual(fetchedCandidate.id, expectedCandidate.id)
            XCTAssertEqual(fetchedCandidate.firstName, expectedCandidate.firstName)
            XCTAssertEqual(fetchedCandidate.linkedinURL, expectedCandidate.linkedinURL)
            XCTAssertEqual(fetchedCandidate.isFavorite, expectedCandidate.isFavorite)
            XCTAssertEqual(fetchedCandidate.email, expectedCandidate.email)
            XCTAssertEqual(fetchedCandidate.lastName, expectedCandidate.lastName)
            
        } catch {
            XCTFail("Unexpected error: \(error)")  
        }
 }
    
    func testInvalidFetchCandidateDetail() async throws {
            // Given
            let url = URL(string: "https//exemple.com")!
            let request = URLRequest(url: url)
        
        let mockResponse = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
            let response: (Data, HTTPURLResponse) = (Data(), mockResponse)
            (candidateDataManager.httpService as! MockHTTPService).mockResult = response
            
            // When
            do {
                let candidates = try await candidateDataManager.fetchCandidateDetail(request: request)
                
                // Then
                XCTAssertNotNil(candidates)
            } catch let error as CandidateDataManager.CandidateFetchError {
                XCTAssertEqual(error, .fetchCandidateDetailError, "L'erreur retournée n'est pas celle attendue")
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    
    
    func testvalidateHTTPResponse() async throws {
        //Given
        let url = URL(string: "https//exemple.com")!
        let request = URLRequest(url: url)
        
        let validateHTTPResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let data = Data()
        let result : (Data,HTTPURLResponse) = (data,validateHTTPResponse)
        (candidateDataManager.httpService as! MockHTTPService).mockResult = result
        //When
        let validateResponse = try await  candidateDataManager.validateHTTPResponse(request: request)
        
        //Then
        
        XCTAssertEqual(validateResponse.statusCode, 200)
        
    }
    func testInvalideHTTPResponse() async throws {
        //Given
        let url = URL(string: "https//exemple.com")!
        let request = URLRequest(url: url)
        
        let validateHTTPResponse = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
        let data = Data()
        let result : (Data,HTTPURLResponse) = (data,validateHTTPResponse)
        (candidateDataManager.httpService as! MockHTTPService).mockResult = result
        //When
        do{
            _ = try await  candidateDataManager.validateHTTPResponse(request: request)
            XCTFail("Unexpected error")
        } catch let error as CandidateDataManager.CandidateFetchError {
            XCTAssertEqual(error, .httpResponseInvalid(statusCode: 404), "L'erreur retournée n'est pas celle attendue")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
        //Then
        
        
    }
    func testfetchCandidateInformation() async throws {
        // Given
      
        let candidateJSON = """
        {
            "id": "fzeklrngzergzerg",
            "phone": "0767890034",
            "note": "Developpeur IOS",
            "firstName": "William",
            "linkedinURL": "https://www.linkedin.com/in/William_Jackson/",
            "isFavorite": true,
            "email": "William.Jksc@gmail.com",
            "lastName": "Jackson"
        }
        """.data(using: .utf8)!
        
        let url = URL(string: "https://exemple.com")!
        let request = URLRequest(url: url)
        
        let expectedCandidate = try JSONDecoder().decode(CandidateEncode.self, from: candidateJSON)
        
        
        // When
        let token = "jknalekrjvnzor43245345é"
        do{
            
        let fetchedCandidate = try await candidateDataManager.fetchCandidateInformation(
            token: token,
            id: "fzeklrngzergzerg",
            phone: "0767890034",
            note: "Developpeur IOS",
            firstName: "William",
            linkedinURL: "https://www.linkedin.com/in/William_Jackson/",
            isFavorite: true,
            email: "William.Jksc@gmail.com",
            lastName: "Jackson",
            request: request
        )
        
        // Then
        XCTAssertNotNil(fetchedCandidate)
        XCTAssertEqual(fetchedCandidate.phone, expectedCandidate.phone)
        XCTAssertEqual(fetchedCandidate.note, expectedCandidate.note)
        XCTAssertEqual(fetchedCandidate.id, expectedCandidate.id)
        XCTAssertEqual(fetchedCandidate.firstName, expectedCandidate.firstName)
        XCTAssertEqual(fetchedCandidate.linkedinURL, expectedCandidate.linkedinURL)
        XCTAssertEqual(fetchedCandidate.isFavorite, expectedCandidate.isFavorite)
        XCTAssertEqual(fetchedCandidate.email, expectedCandidate.email)
        XCTAssertEqual(fetchedCandidate.lastName, expectedCandidate.lastName)
    
            
        }catch {
             print("error")
        }
    }

    func testInvalidfetchCandidateInformation() async throws {
            // Given
            let url = URL(string: "https//exemple.com")!
            let request = URLRequest(url: url)
        
        let mockResponse = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
            let response: (Data, HTTPURLResponse) = (Data(), mockResponse)
            (candidateDataManager.httpService as! MockHTTPService).mockResult = response
        let token = "jknalekrjvnzor43245345é"
            // When
            do {
              
                let candidates = try await candidateDataManager.fetchCandidateInformation(
                    token: token,
                    id: "fzeklrngzergzerg",
                    phone: "0767890034",
                    note: "Developpeur IOS",
                    firstName: "William",
                    linkedinURL: "https://www.linkedin.com/in/William_Jackson/",
                    isFavorite: true,
                    email: "William.Jksc@gmail.com",
                    lastName: "Jackson",
                    request: request
                )
                // Then
                XCTAssertNotNil(candidates)
            } catch let error as CandidateDataManager.CandidateFetchError {
                XCTAssertEqual(error, .fetchCandidateInformationError, "L'erreur retournée n'est pas celle attendue")
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
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
