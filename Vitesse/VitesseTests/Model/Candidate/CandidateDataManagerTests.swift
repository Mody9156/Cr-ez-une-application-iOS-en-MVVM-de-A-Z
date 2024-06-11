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

    func testFetchCandidateData() throws {
        
        let  CandidateDecode = """
{
             "phone" : "0122333344",
             "note": "Développeur en Backend",
             "id" : "vzbjkzjbinkjzbjkz4254",
             "firstName": "William",
             "linkedinURL": "https://www.linkedin.com/in/William-William-123456789/
",
             "isFavorite": true,
             "email" : "William.Browm@gmail.com",
             "lastName": "Browm"
        }
""".data(using: .utf8)!
        
        struct CandidateEncode: Identifiable, Decodable ,Hashable{
            var phone, note: String?
            var id, firstName: String
            var linkedinURL: String?
            var isFavorite: Bool
            var email, lastName: String
        }
        
        
        
        let decode = try? JSONDecoder().decode([CandidateEncode].self, from: CandidateDecode)
        
        
        
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
