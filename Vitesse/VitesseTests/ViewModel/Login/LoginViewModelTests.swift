//
//  LoginViewModelTests.swift
//  VitesseTests
//
//  Created by KEITA on 12/06/2024.
//

import XCTest
@testable import Vitesse

final class LoginViewModelTests: XCTestCase {
    var loginViewModel : LoginViewModel!
    
    override func setUp()  {
        super.tearDown()
        loginViewModel = LoginViewModel({})
    }

    override func tearDown()  {
        super.tearDown()
        loginViewModel = nil
    }

    func testAuthenticateUserAndProceed() async throws {
    //Given
     var username = "admin@vitesse.com"
     var password = "test123"
    
        
    let token = "nznjkgbzejbrz"
        
    //When
        let authenticationResult = try await loginViewModel.authenticationManager.authenticate(username: username, password: password)
    //Then
        XCTAssertEqual(authenticationResult.isAdmin, true)
        
    }

    func testInvalidAuthenticateUserAndProceed() async throws {
        //Given
         var username = "admin@vitesse.com"
         var password = ""

        let token = "nznjkgbzejbrz"
       
        do{
            
        //When
            let authenticationResult = try await loginViewModel.authenticationManager.authenticate(username: username, password: password)
        //Then
        }catch let error as LoginViewModel.AuthViewModelFailure{
            XCTAssertEqual(error, .tokenInvalide)
        }catch{
            XCTFail("erreur")
        }
    }

}
