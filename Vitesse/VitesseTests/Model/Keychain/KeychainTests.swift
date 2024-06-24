//
//  KeychainTests.swift
//  VitesseTests
//
//  Created by KEITA on 18/06/2024.
//

import XCTest
@testable import Vitesse
final class KeychainTests: XCTestCase {
    
    var keychain : Keychain!
    
    override func setUp() {
        super.setUp()
        // Initialisation de votre AuthConnector avec un HTTPService fictif pour les tests
        keychain = Keychain()
    }
    
    override func tearDown() {
        // Nettoyage après chaque test si nécessaire
        keychain = nil
        super.tearDown()
    }
    
    func testAddNewKeyChain() throws {
        //Given
        
        //When
        let add =  try keychain.add("exemple_of_token", forKey: "exemple_23")
        //Then
        XCTAssertNoThrow(add)
        
    }
    
    func testGetNewKeyChain() throws {
        //Given
        
        //When
        let add =  try keychain.add("exemple_of_token", forKey: "exemple_30")
        let get = try keychain.get(forKey: "exemple_30")
        //Then
        XCTAssertNoThrow(get)
    }
    
    func testInvalidGetNewKeyChain() throws {
        //Given
        
        //When & Then
        XCTAssertThrowsError(try keychain.get(forKey: "badGetToken")){ error in
            
            XCTAssertEqual(error as? Keychain.KeychainError,.getFailed)
            
        }
        
    }
    
    func testDeleteNewKeyChain() throws {
        
        //When
        let add =  try keychain.add("exemple_of_token", forKey: "exemple_22")
        let delete = try keychain.delete(forKey: "exemple_22")
        //Then
        XCTAssertNoThrow(delete)
    }
    
    
    func testInvalidDeleteNewKeyChain() throws {
        
        //When & Then
        XCTAssertThrowsError(try keychain.delete(forKey: "BadDeleteToken")){error in
            XCTAssertEqual(error as? Keychain.KeychainError,.deleteFailed)
            
        }
        
    }
    
}

