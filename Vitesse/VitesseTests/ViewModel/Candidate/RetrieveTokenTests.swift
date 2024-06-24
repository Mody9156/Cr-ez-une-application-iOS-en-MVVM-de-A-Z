//
//  RetrieveToken.swift
//  VitesseTests
//
//  Created by KEITA on 24/06/2024.
//

import XCTest
@testable import Vitesse

final class RetrieveTokenTests: XCTestCase {
    
    
    func testRetrieveToken() async throws{
        
        // Given
        let key = Keychain()
        MocksRetrieveToken.mockToken = "mockTokenValue"
        MocksRetrieveToken.shouldThrowError = false
        try key.add("exemple", forKey: "fake_key")
        // When
        let retrievedToken = try MocksRetrieveToken.retrieveToken("fake_key")
        
        // Then
        XCTAssertEqual(retrievedToken, "mockTokenValue")
        XCTAssertNoThrow(try MocksRetrieveToken.retrieveToken("fake_key"))
    }
    
    func testInvalidRetrieveToken() async throws{
        
        // Given
        MocksRetrieveToken.shouldThrowError = true
        
        // When & Then
        XCTAssertThrowsError(try MocksRetrieveToken.retrieveToken("fake_key")) { error in
            XCTAssertEqual(error as? CandidateManagementError, .fetchTokenError)
        }
        
        
    }
  
    
    func testFetchTokenError() async throws{
        
        //When
        XCTAssertThrowsError(try RetrieveToken.retrieveToken("")) { error in
            XCTAssertEqual(error as? CandidateManagementError, .fetchTokenError)
        }
        //Then
        
    }
}

class MocksRetrieveToken: TokenRetrievable {
    static var mockToken: String?
    static var shouldThrowError: Bool = false
    
    static func retrieveToken(_ token : String) throws -> String {
        if shouldThrowError {
            throw CandidateManagementError.fetchTokenError
        }
        if let token = mockToken {
            return token
        } else {
            throw CandidateManagementError.fetchTokenError
        }
    }
}
