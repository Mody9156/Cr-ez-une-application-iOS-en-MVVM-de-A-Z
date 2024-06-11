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
    }

    override func tearDown()  {
        super.tearDown()
    }

    func testExample() throws {
       
    }

    func testPerformanceExample() throws {
      
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
