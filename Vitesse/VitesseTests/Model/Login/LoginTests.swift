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
    
    func test_buildAuthenticationRequest_Success() throws {
        // Given
        
        struct EncodingLogin :Encodable {
            var email: String
            var password: String
        }
        
        let name = "Paul"
        let password = "test"
        let encodeAuth = EncodingLogin(email: name, password: password)
        let encode = try? JSONEncoder().encode(encodeAuth)
        
        let useExpectedURL = URL(string: "http://exemple/auh.com")!
        
        var request = URLRequest(url: useExpectedURL)
        request.httpBody = encode
    
            // When
            let buildAuthenticationRequest =  try authenticationManager.buildAuthenticationRequest(username: name, password: password)
            
            // Then
            XCTAssertEqual(buildAuthenticationRequest.httpMethod,"POST" )
            XCTAssertNotNil(buildAuthenticationRequest.url)
            XCTAssertEqual(buildAuthenticationRequest.httpBody,request.httpBody)
            XCTAssertEqual(buildAuthenticationRequest.value(forHTTPHeaderField: "Content-Type"), "application/json")
            XCTAssertNotNil(buildAuthenticationRequest.allHTTPHeaderFields)
      
    }

    func test_buildAuthenticationRequest_failure_Url() throws {
        struct EncodingLogin :Encodable {
            var email: String
            var password: String
        }
        
        let name = "Paul"
        let password = "test"
        let encodeAuth = EncodingLogin(email: name, password: password)
        let encode = try? JSONEncoder().encode(encodeAuth)
        
        let useExpectedURL = URL(string: "http://exemple/auh.com")!
        
        var request = URLRequest(url: useExpectedURL)
        request.httpBody = encode
        
        // When
        let buildAuthenticationRequest =  try authenticationManager.buildAuthenticationRequest(username: name, password: password)
    }
    
    func test_authenticate() async throws {
        // Given
        let name = "Paul"
        let password = "test"
        
        struct AuthenticationResponse: Decodable {
            var isAdmin: Bool
            var token: String
        }
        
        let JSONResponse = """
        {
            "isAdmin": true,
            "token": "someToken"
        }
        """.data(using: .utf8)!
        
        let mockResponse = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let mockResult: (Data, HTTPURLResponse) = (JSONResponse, mockResponse)
        (authenticationManager.httpService as! MockHTTPService).mockResult = mockResult

        let decode = try JSONDecoder().decode(AuthenticationResponse.self, from: JSONResponse)
        
        // When
        // Assuming authenticationManager.authenticate returns an AuthenticationResponse
        do{
            let buildAuthenticationRequest = try await authenticationManager.authenticate(username: name, password: password)
            
            // Then
            XCTAssertEqual(buildAuthenticationRequest.isAdmin, true)
            XCTAssertNotNil(buildAuthenticationRequest.token)
            XCTAssertEqual(buildAuthenticationRequest.isAdmin, decode.isAdmin)
            XCTAssertEqual(buildAuthenticationRequest.token, decode.token)
        }catch{
            XCTFail("Erreur inattendue: \(error)")
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
