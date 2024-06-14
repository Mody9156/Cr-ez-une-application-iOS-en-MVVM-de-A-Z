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
    
    func testCreateURLRequest() throws {
        //Given
        let url = "https://example.com/createCandidate"
        let method = "POST"
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        let id = "123456"
        
        //When
        let createURLRequest = try CandidateManagement.createURLRequest(url: url, method: method, token: token, id: id)
        
        //Then
        XCTAssertEqual(createURLRequest.httpMethod, "POST")
        XCTAssertEqual(createURLRequest.url?.absoluteString, url)
        XCTAssertEqual(createURLRequest.allHTTPHeaderFields?["Authorization"], "Bearer \(token)")
        XCTAssertEqual(createURLRequest.allHTTPHeaderFields?["Content-Type"], "application/json")
        
    }
    func testInvalidCreateURLRequest() throws {
        //Given
        let url = ""
        let method = "POST"
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        let id = "123456"
        
        //When
        XCTAssertThrowsError(try CandidateManagement.createURLRequest(url: url, method: method, token: token, id: id)){ error in
            //Then
            XCTAssertEqual((error as Error)._code, URLError.badURL.rawValue)
        }
    }
    
    
    func testloadCandidatesFromURL() throws {
        //Given
        let url = "https://example.com/createCandidate"
        let method = "POST"
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        _ = "123456"
        
        //When
        let loadCandidatesFromURL = try CandidateManagement.loadCandidatesFromURL(url: url, method: method, token: token)
        
        //Then
        XCTAssertEqual(loadCandidatesFromURL.httpMethod, "POST")
        XCTAssertEqual(loadCandidatesFromURL.url?.absoluteString, url)
        XCTAssertEqual(loadCandidatesFromURL.allHTTPHeaderFields?["Authorization"], "Bearer \(token)")
        XCTAssertEqual(loadCandidatesFromURL.allHTTPHeaderFields?["Content-Type"], "application/json")
    }
    
    func testInvalidloadCandidatesFromURL() throws {
        //Given
        let url = ""
        let method = "POST"
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        _ = "123456"
        
        //When
        XCTAssertThrowsError(try CandidateManagement.loadCandidatesFromURL(url: url, method: method, token: token)){ error in //!
            //Then
            XCTAssertEqual((error as Error)._code, URLError.badURL.rawValue)
        }
    }
    
    func testCreateNewCandidateRequest() throws {
        // Given
        let url =  "https://example.com/createCandidate"
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        let method = "POST"
        
        let id = "342526245"
        
        // When
        let loadCandidatesFromURL = try CandidateManagement.createNewCandidateRequest(
            url: url,
            method: method,
            token: token,
            id: id,
            phone: "+1234567890",
            note: "Candidate seems highly qualified",
            firstName: "Alice",
            linkedinURL: "https://www.linkedin.com/in/alice-example",
            isFavorite: true,
            email: "alice@example.com",
            lastName: "Doe")
        
        //Then
        XCTAssertEqual(loadCandidatesFromURL.httpMethod, "POST")
        XCTAssertEqual(loadCandidatesFromURL.url?.absoluteString, url)
        XCTAssertEqual(loadCandidatesFromURL.allHTTPHeaderFields?["Authorization"], "Bearer \(token)")
        XCTAssertEqual(loadCandidatesFromURL.allHTTPHeaderFields?["Content-Type"], "application/json")
        
    }
    
    func testInvalidCreateNewCandidateRequest() throws {//!
        //Given
        let url = ""
        let method = "POST"
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        let id = "123456"
        
        //When
        XCTAssertThrowsError( try CandidateManagement.createNewCandidateRequest(
            url: url,
            method: method,
            token:token,
            id: id,
            phone: "+1234567890",
            note: "Candidate seems highly qualified",
            firstName: "Alice",
            linkedinURL: "https://www.linkedin.com/in/alice-example",
            isFavorite: true,
            email: "alice@example.com",
            lastName: "Doe")){ error in
                //Then
                XCTAssertEqual((error as Error)._code, URLError.badURL.rawValue)
            }
    }
    
}
