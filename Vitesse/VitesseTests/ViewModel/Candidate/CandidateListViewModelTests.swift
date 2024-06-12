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
    var mockKey : MockKey!
    
    override func setUp()  {
        candidateListViewModel = CandidateListViewModel(retrieveCandidateData: CandidateDataManager())
        mockKey = MockKey()
        super.setUp()
    }

    override func tearDown()  {
        candidateListViewModel = nil
        mockKey = nil
      super.tearDown()
    }

    func testToken() throws {
        //Given
        do{
            //When
            let token = candidateListViewModel.token
            //Then
        }catch{
            
        }
            
    }

    func testDisplayCandidatesList() throws {
       
    }
    func testDeleteCandidate() throws {
       
    }
    func testShowFavoriteCandidates() throws {
       
    }
    func testRemoveCandidate() throws {
        
    }

}
class MockKey: Keychain {
    var stubbedToken: String?

    override func get(forKey key: String) throws -> Data {
        guard let token = stubbedToken else {
            throw NSError(domain: "", code: 0, userInfo: nil) // Handle appropriately
        }
        return token.data(using: .utf8)!
    }
}
