//
//  RegistreTest.swift
//  VitesseTests
//
//  Created by KEITA on 11/06/2024.
//

import XCTest
@testable import Vitesse

final class RegistreTests: XCTestCase {
    var registrationRequestBuilder : RegistrationRequestBuilder!

    override func setUp()  {
        super.setUp()
        // Given
        // Initialisation de votre AuthConnector avec un HTTPService fictif pour les tests
        registrationRequestBuilder = RegistrationRequestBuilder(httpService: MockHTTPService())
    }

    override func tearDown()  {
        // Nettoyage après chaque test si nécessaire
        registrationRequestBuilder = nil
        super.tearDown()
    }

    func testBuildRegistrationURLRequest() throws {
        // Given
        struct EncodingLogin :Encodable {
        var email: String
        var password: String
        var firstName: String
        var lastName: String
        }
        let email = "Paul.Pierce@gmail.com"
        let password = "test"
        let firstName = "Paul"
        let lastName = "Pierce"
        
        let encodeRegistre = EncodingLogin(email: email, password: password, firstName: firstName, lastName: lastName)
        let encode = try JSONEncoder().encode(encodeRegistre)
        let useExpectedURL = URL(string: "http://exemple.boston/auh)")!
        
        var request = URLRequest(url: useExpectedURL)
        request.httpBody = encode
        
        // When
        
        let buildRegistrationURLRequest = registrationRequestBuilder.buildRegistrationURLRequest(email: email, password: password, firstName: firstName, lastName: lastName)
        
        // Then
        XCTAssertEqual(buildRegistrationURLRequest.httpBody, request.httpBody)
        XCTAssertNotNil(buildRegistrationURLRequest.url)
        XCTAssertEqual(buildRegistrationURLRequest.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertNotNil(buildRegistrationURLRequest.allHTTPHeaderFields)
    }
    
    func testSuccessfulBuildRegistrationRequest() async throws {
        //Given
       
        let email = "Paul.Pierce@gmail.com"
        let password = "test"
        let firstName = "Paul"
        let lastName = "Pierce"
        
        let response = HTTPURLResponse(url: URL(string:"https//exempledelien.com")!, statusCode: 201, httpVersion: nil, headerFields: nil)!
        let result : (Data,HTTPURLResponse) = (Data(),response)
        (registrationRequestBuilder.httpService as! MockHTTPService ).mockResult = result
       
        //When
        do{
            
            let buildRegistrationRequest =  try await registrationRequestBuilder.buildRegistrationRequest(email: email, password: password, firstName: firstName, lastName: lastName)
            //Then
            XCTAssertEqual(buildRegistrationRequest.statusCode, 201)
        }catch let error  as RegistrationRequestBuilder.HTTPResponseError{
            throw error
            
        }
       
        
    }
    func testInvalidfulBuildRegistrationRequest() async throws {
        //Given
       
        let email = "Paul.Pierce@gmail.com"
        let password = "test"
        let firstName = "Paul"
        let lastName = "Pierce"
        
        let response = HTTPURLResponse(url: URL(string:"https//exempledelien.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)!
        let result : (Data,HTTPURLResponse) = (Data(),response)
        (registrationRequestBuilder.httpService as! MockHTTPService ).mockResult = result
        //When
        do{
            
            let buildRegistrationRequest =  try await registrationRequestBuilder.buildRegistrationRequest(email: email, password: password, firstName: firstName, lastName: lastName)
            //Then
            XCTFail("Expected invalid response error")
            
        }catch let error as RegistrationRequestBuilder.HTTPResponseError {
           print(error)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

    }
    
    // Mock HTTPService utilisé pour simuler les réponses HTTP
    class MockHTTPService: HTTPService {
          
          var mockResult: (Data, HTTPURLResponse)?
          
          func request(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
              guard let result = mockResult else {
                  throw NSError(domain: "", code: 0, userInfo: nil)
              }
              return result
          }
      }
}
