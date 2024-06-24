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
        
        //When & Then
        XCTAssertNoThrow(try keychain.add("exemple_of_token", forKey: "exemple_23"))
        
    }
    
    func testInvalidAddNewKeyChain() throws {
        
        //When & Then
        
        XCTAssertThrowsError(try keychain.add("", forKey: "")){ error in
            XCTAssertEqual(error as? Keychain.KeychainError,.insertFailed )
        }
        
    }
    
    func testGetNewKeyChain() throws {
        //Given
        
        //When
        let _ =  try keychain.add("exemple_of_token", forKey: "exemple_30")
       
        //Then
        XCTAssertNoThrow(try keychain.get(forKey: "exemple_30"))
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
        let _ =  try keychain.add("exemple_of_token", forKey: "exemple_22")
        
        //Then
        XCTAssertNoThrow(try keychain.delete(forKey: "exemple_22"))
    }
    
    
    func testInvalidDeleteNewKeyChain() throws {
        
        //When & Then
        XCTAssertThrowsError(try keychain.delete(forKey: "BadDeleteToken")){error in
            XCTAssertEqual(error as? Keychain.KeychainError,.deleteFailed)
            
        }
        
    }
    
}

