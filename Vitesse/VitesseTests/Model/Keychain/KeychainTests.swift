//
//  KeychainTests.swift
//  VitesseTests
//
//  Created by KEITA on 18/06/2024.
//

import XCTest
@testable import Vitesse
final class KeychainTests: XCTestCase {
    
    func testAdd() throws {
        
        //Given
        let keychain = Keychain()
        
        //When
        do{
            let add =  try keychain.add("exemple_of_token", forKey: "exemple_1")
            
            //Then
            XCTAssertNoThrow(add)
        } catch let error as Keychain.KeychainError {
            
            XCTAssertEqual(error, .insertFailed, "Expected to receive an insertFailed error.")
            
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
  
    
}
