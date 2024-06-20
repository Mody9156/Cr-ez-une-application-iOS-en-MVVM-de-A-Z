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
    
    func testAddDuplicateItem() throws {
        
        // Given
        let keychain = Keychain()
        let token = "example_of_token"
        let key = ""
        
        do {
            // When
            let add = try keychain.add(token, forKey: key)
            XCTAssertNoThrow(add)
            // Then
        } catch let error as Keychain.KeychainError {
            // Ensure the correct error is thrown
            XCTAssertEqual(error, .insertFailed, "Expected to receive an insertFailed error.")
        } catch {
            // If any other error is thrown, the test should fail
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testget() throws {
        //Given
        let keychain = Keychain()
        
        //When
        do{
            try keychain.add("kjnezrgzer", forKey: "exemple_1")
            let get =  try keychain.get(forKey: "exemple_1")
            XCTAssertNoThrow(get)
        }catch let error as Keychain.KeychainError{
            XCTAssertEqual(error, .getFailed)
        }
        
    }
    
    
    func testInvalidGet() throws {
        let keychain = Keychain()
        
        do{
            let get =  try keychain.get(forKey: "exemple_3")
            XCTAssertNoThrow(get)
        }catch let error as Keychain.KeychainError{
            XCTAssertEqual(error, .getFailed)
        }
        
    }
    
    
    func test_delete() throws {
        let keychain = Keychain()
        let token = String(repeating: "Mffzef", count: 15)
        
        do{
            try keychain.add(token, forKey: "exemple_20")
            try keychain.delete(forKey: "exemple_50")
            XCTFail("Expected to receive a deleteFailed error.")
            
        }catch let error as Keychain.KeychainError{
            XCTAssertEqual(error, .deleteFailed)
        }
    }
    
    
    func test_Invalid_delete() throws {
        let keychain = Keychain()
        
        do{
            try keychain.delete(forKey: "exemple_50")
            XCTFail("Expected to receive a deleteFailed error.")
            
        }catch let error as Keychain.KeychainError{
            XCTAssertEqual(error, .deleteFailed)
        }
    }
    
}
