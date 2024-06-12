import XCTest
@testable import Vitesse

final class CandidateListViewModelTests: XCTestCase {
    var candidateListViewModel: CandidateListViewModel!
    var mockKey: MockKey!

    override func setUp() {
        super.setUp()
        mockKey = MockKey()
        candidateListViewModel = CandidateListViewModel(retrieveCandidateData: CandidateDataManager(), keychain: MockKey())
    }

    override func tearDown() {
        candidateListViewModel = nil
        mockKey = nil
        super.tearDown()
    }

    func testToken_Success() throws {
        // Given
        let key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFkbWluQHZpdGVzc2UuY29tIiwiaXNBZG1pbiI6dHJ1ZX0.J83TqjxRzmuDuruBChNT8sMg5tfRi5iQ6tUlqJb3M9U"
        mockKey.stubbedToken = key.data(using: .utf8)

        // When
        let token = try candidateListViewModel.token()

        // Then
        XCTAssertEqual(token, key)
    }

    func testToken_Failure() throws {
        // Given
        mockKey.stubbedToken = nil

        // When & Then
        XCTAssertThrowsError(try candidateListViewModel.token()) { error in
            XCTAssertEqual(error as? CandidateListViewModel.CandidateManagementError, .fetchTokenError)
        }
    }

    // Placeholder for other tests
    func testDisplayCandidatesList() throws {}
    func testDeleteCandidate() throws {}
    func testShowFavoriteCandidates() throws {}
    func testRemoveCandidate() throws {}

}

class MockKey: Keychain {
    var stubbedToken: Data?

    override func get(forKey key: String) throws -> Data {
        guard let token = stubbedToken else {
            throw NSError(domain: "", code: 0, userInfo: nil) // Handle appropriately
        }
        return token
    }
}
