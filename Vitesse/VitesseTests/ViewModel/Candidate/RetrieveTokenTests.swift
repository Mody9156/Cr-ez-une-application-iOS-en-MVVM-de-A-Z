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
        MocksRetrieveToken.mockToken = "mockTokenValue"
        MocksRetrieveToken.shouldThrowError = false
        
        // When
        let retrievedToken = try MocksRetrieveToken.retrieveToken()
        
        // Then
        XCTAssertEqual(retrievedToken, "mockTokenValue")
        XCTAssertNoThrow(try MocksRetrieveToken.retrieveToken())
    }
    
    func testInvalidRetrieveToken() async throws{
        
        // Given
        MocksRetrieveToken.shouldThrowError = true
        
        // When & Then
        XCTAssertThrowsError(try MocksRetrieveToken.retrieveToken()) { error in
            XCTAssertEqual(error as? CandidateManagementError, .fetchTokenError)
        }
        
        
    }
}

class MocksRetrieveToken: TokenRetrievable {
    static var mockToken: String?
    static var shouldThrowError: Bool = false
    
    static func retrieveToken() throws -> String {
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
