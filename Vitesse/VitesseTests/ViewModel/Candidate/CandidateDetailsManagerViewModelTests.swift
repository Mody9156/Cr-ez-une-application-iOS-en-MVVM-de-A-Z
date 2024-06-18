//
//  CandidateDetailsManagerViewModelTests.swift
//  VitesseTests
//
//  Created by KEITA on 18/06/2024.
//

import XCTest
@testable import Vitesse

final class CandidateDetailsManagerViewModelTests: XCTestCase {


    func test_token() throws {
      
    }

    func test_displayCandidateDetails() throws {
       
    }

    func test_candidateUpdater() throws {
       
    }
    func test_updateCandidateInformation() throws {
       
    }
}


class MockHTTPpServicee: HTTPService {
    var mockResult: (Data, HTTPURLResponse)?
    var mockError: Error?
    
    func request(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        if let error = mockError {
            throw error
        }
        guard let result = mockResult else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        return result
    }
}
