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
            //fail
        }
       
        
    }
    func testInvalidBuildRegistrationRequest() async throws {
           // Given
           let email = "Paul.Pierce@gmail.com"
           let password = "test"
           let firstName = "Paul"
           let lastName = ""
           
           let response = HTTPURLResponse(url: URL(string: "https://exempledelien.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)!
           let result: (Data, HTTPURLResponse) = (Data(), response)
           (registrationRequestBuilder.httpService as! MockHTTPService).mockResult = result
           
           // When
           do {
               _ = try await registrationRequestBuilder.buildRegistrationRequest(email: email, password: password, firstName: firstName, lastName: lastName)
               XCTFail("Expected invalid response error")
           } catch let error as RegistrationRequestBuilder.HTTPResponseError {
               // Then
               XCTAssertEqual(error, .invalidResponse(statusCode: 404))
           } catch {
               XCTFail("Unexpected error: \(error)")
           }
       }
    func testHTTPResponseErrorEquality() {
        // Créer deux erreurs invalides avec le même code d'état
        let invalidResponse1 = RegistrationRequestBuilder.HTTPResponseError.invalidResponse(statusCode: 404)
        let invalidResponse2 = RegistrationRequestBuilder.HTTPResponseError.invalidResponse(statusCode: 404)
        
        let error1 = NSError(domain: "Test", code: 500, userInfo: nil)
        let error2 = NSError(domain: "Test", code: 500, userInfo: nil)
        
        let networkError1 = RegistrationRequestBuilder.HTTPResponseError.networkError(error1)
        let networkError2 = RegistrationRequestBuilder.HTTPResponseError.networkError(error2)
        // Créer une erreur réseau
        _ = RegistrationRequestBuilder.HTTPResponseError.networkError(NSError(domain: "Test", code: 500, userInfo: nil))
        
        // Test d'égalité pour les erreurs invalides
        XCTAssertTrue(invalidResponse1 == invalidResponse2, "Les erreurs invalides avec le même code d'état doivent être égales")
        
        // Test d'inégalité entre une erreur invalide et une erreur réseau
        XCTAssertFalse(invalidResponse1 == networkError1, "Les erreurs invalides et les erreurs réseau ne doivent pas être égales")
        
        XCTAssertTrue(networkError1 == networkError2)
       
    }
    // Mock HTTPService utilisé pour simuler les réponses HTTP
    class MockHTTPService: HTTPService {
           
          var mockResult: (Data, HTTPURLResponse)?
          var mockError: Error?
          func request(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
              if let error = mockError {
                              throw error
                          }
              guard let result = mockResult else {
                  throw NSError(domain: "", code: 0, userInfo: nil)
              }
              return result
          }
      }
}
