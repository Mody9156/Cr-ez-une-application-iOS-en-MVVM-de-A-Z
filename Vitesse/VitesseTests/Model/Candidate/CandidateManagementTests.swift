//
//  CandidateManagementTests.swift
//  VitesseTests
//
//  Created by KEITA on 12/06/2024.
//

import XCTest
@testable import Vitesse

final class CandidateManagementTests: XCTestCase {

    var candidateManagement : CandidateManagement!
    
    override func setUp() {
        super.setUp()
        candidateManagement = CandidateManagement()
    }

    override func tearDown() {
        super.tearDown()
        candidateManagement = nil
    }

    func testcreateURLRequest() throws {
        //Given
        let url = URL(string: "https//exemple.com")!
        var request = URLRequest(url: url)
        let token =  "fnjkzebrgnkjzberg"
        
        //When
        let createURLRequest = try CandidateManagement.createNewCandidateRequest(
            url: "https://example.com/createCandidate",
            method: "POST",
            token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c", id: "123456",
            phone: "+1234567890",
            note: "Candidate seems highly qualified",
            firstName: "Alice",
            linkedinURL: "https://www.linkedin.com/in/alice-example",
            isFavorite: true,
            email: "alice@example.com",
            lastName: "Doe")

        //Then
        XCTAssertEqual(createURLRequest.httpMethod,"POST")
        XCTAssertNotNil(createURLRequest.httpMethod)
        XCTAssertNotNil(createURLRequest.allHTTPHeaderFields)
        XCTAssertNotNil(createURLRequest.url)
        
        
    }

    func testloadCandidatesFromURL() throws {
       
    }
    
    func testcreateNewCandidateRequest() throws {
       
    }
   
}
