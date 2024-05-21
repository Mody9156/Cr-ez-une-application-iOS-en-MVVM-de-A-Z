import Foundation

class CandidateFavoritesManager {
    let httpService: HTTPService

    init(httpService: HTTPService = BasicHTTPClient()) {
        self.httpService = httpService
    }

    enum CandidateFetchError: Error {
        case networkError
    }

    func favoritesURLRequest(token: String, candidate: String) -> URLRequest {
        let url = URL(string: "http://127.0.0.1:8080/candidate/\(candidate)/favorite")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let authHeader = "Bearer " + token
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")

        print("URLRequest: \(request)")

        return request
    }

    func fetchFavoritesURLRequest(token: String, candidate: String) async throws -> [RecruitTech] {
        do {
            let request = favoritesURLRequest(token: token, candidate: candidate)
            let (data, response) = try await httpService.request(request)

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Status Code: \(httpResponse.statusCode)")
            }

            let candidates = try JSONDecoder().decode([RecruitTech].self, from: data)

            return candidates
        } catch {
            print("Erreur réseau: \(error)")
            throw CandidateFetchError.networkError
        }
    }
}
