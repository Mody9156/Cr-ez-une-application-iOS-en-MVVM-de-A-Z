//
//  LoginTests.swift
//  LoginTests
//
//  Created by KEITA on 10/06/2024.
//

import XCTest
@testable import Vitesse

final class LoginTests: XCTestCase {
    
    var authenticationManager : AuthenticationManager!
    
    override func setUp() {
        super.setUp()
        // Given
        // Initialisation de votre AuthConnector avec un HTTPService fictif pour les tests
        authenticationManager = AuthenticationManager(httpService: MockHTTPService())
    }
    
    override func tearDown() {
        // Nettoyage après chaque test si nécessaire
        authenticationManager = nil
        super.tearDown()
    }
    
    func testBuildAuthenticationRequest() throws {
        
        struct EncodingLogin :Encodable {
        var email: String
        var password: String
        }
        let name = "Paul"
        let password = "test"
        let encodeAuth = EncodingLogin(email: name, password: password)
        let encode = try? JSONEncoder().encode(encodeAuth)

        let useExpectedURL = URL(string: "http://exemple/auh)")!
        
        var request = URLRequest(url: useExpectedURL)
        request.httpBody = encode
        
        let buildAuthenticationRequest =  authenticationManager.buildAuthenticationRequest(username: name, password: password)
        

        XCTAssertEqual(buildAuthenticationRequest.httpMethod,"POST" )
        XCTAssertNotNil(buildAuthenticationRequest.url)
        XCTAssertEqual(buildAuthenticationRequest.httpBody,request.httpBody)
        XCTAssertNotNil(buildAuthenticationRequest.allHTTPHeaderFields)

    }

    func testAuthenticate() async throws {
        let name = "Paul"
        let password = "test"
        
        let JSONResponse =
        """
          "name" : "Paul",
          "password" = "test"
        
            
        """.data(using: .utf8)!
        
        let mockResponse = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockResult: (Data, HTTPURLResponse) = (JSONResponse, mockResponse)
        (authenticationManager.httpService as! MockHTTPService).mockResult = mockResult
//        let json = try JSONDecoder().decode(JSONResponse.self, from: JSONResponse)

        
        let buildAuthenticationRequest = try await authenticationManager.authenticate(username: name, password: password)
        
    }
    
    // Mock HTTPService utilisé pour simuler les réponses HTTP
    class MockHTTPService : HTTPService {
        
        var mockResult: (Data, HTTPURLResponse)?

        func request(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
            guard let result = mockResult else {
                throw NSError(domain: "", code: 0, userInfo: nil)
            }
            return result
        }
      
    }

}
