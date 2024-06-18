//
//  KeychainTests.swift
//  VitesseTests
//
//  Created by KEITA on 18/06/2024.
//

import XCTest
@testable import Vitesse
final class KeychainTests: XCTestCase {

    func testExample() throws {
        //Given
       let keychain = Keychain()
        //When
        do{
           try keychain.add("exemple_of_token", forKey: "exemple_1")
            XCTAssertEqual(keychain.get(forKey: "exemple_1"),)
        }catch let error as Keychain.KeychainError {
            XCTAssertEqual(error, .getFailed,"Failed to insert item into keychain.")
        }
       
        //Then
        
    }

    func testPerformanceExample() throws {
      
    }

}
