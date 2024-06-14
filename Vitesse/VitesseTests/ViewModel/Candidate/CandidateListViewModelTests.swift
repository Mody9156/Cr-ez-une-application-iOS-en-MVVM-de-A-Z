//
//  CandidateListViewModelTests.swift
//  VitesseTests
//
//  Created by KEITA on 12/06/2024.
//

import XCTest
@testable import Vitesse

final class CandidateListViewModelTests: XCTestCase {
    var candidateListViewModel : CandidateListViewModel!

    override func setUp()  {
        candidateListViewModel = CandidateListViewModel(retrieveCandidateData: CandidateDataManager(),keychain: MockKey())

        super.setUp()
    }

    override func tearDown()  {
        candidateListViewModel = nil

      super.tearDown()
    }

    func testTokenSuccess() async throws {
        // Given
               let mockTokenString = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImV4ZW1wbGUyMjMxMkBnbWFpbC5jb20iLCJpc0FkbWluIjpmYWxzZX0.t3ec7oA3gEQJT1gh_qahIPzawLN4o_bTkAsE0iHg3rg"
               let mockTokenData = mockTokenString.data(using: .utf8)!
               
               let mockKey = MockKey()
                mockKey.mockTokenData = mockTokenData
             
               
               // When
               do {
                   let token = try candidateListViewModel.token()
                   
                   // Then
                   XCTAssertEqual(token, mockTokenString)
               } catch {
                   XCTFail("Unexpected error: \(error)")
               }
    }
    
  
  
   
    func testDisplayCandidatesList() async throws {
        //Given
      
        //When
        let DisplayCandidatesList = try await candidateListViewModel.displayCandidatesList()
        //Then
        XCTFail("erreur")
    }
    func testDeleteCandidate() throws {
       
    }
    func testShowFavoriteCandidates() throws {
       
    }
    func testRemoveCandidate() throws {
        
    }

}


class MockKey: Keychain {
    
    private var keychain  : [String:String]
   }
