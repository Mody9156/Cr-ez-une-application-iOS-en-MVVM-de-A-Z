import Foundation

class CandidateDataManager {
    
    let httpService: HTTPService
    
    init(httpService: HTTPService = URLSessionHTTPClient()) {
        self.httpService = httpService
    }
    
    enum CandidateFetchError: Error, Equatable {
        case httpResponseInvalid(statusCode: Int)
        case fetchCandidateDataError
        case fetchCandidateDetailError
        case fetchCandidateInformationError
        
        static func == (lhs: CandidateFetchError, rhs: CandidateFetchError) -> Bool {
            switch (lhs, rhs) {
            case let (.httpResponseInvalid(statusCode1), .httpResponseInvalid(statusCode2)):
                return statusCode1 == statusCode2
            case (.fetchCandidateDataError, .fetchCandidateDataError),
                 (.fetchCandidateDetailError, .fetchCandidateDetailError),
                 (.fetchCandidateInformationError, .fetchCandidateInformationError):
                return true
            default:
                return false
            }
        }
    }
    
    func fetchCandidateData(request: URLRequest) async throws -> [CandidateInformation] {
        do {
            let (data, response) = try await httpService.request(request)
            guard response.statusCode == 200 else {
                        throw CandidateFetchError.httpResponseInvalid(statusCode: response.statusCode)
                    }
            let candidates = try JSONDecoder().decode([CandidateInformation].self, from: data)
            return candidates
        } catch {
            throw CandidateFetchError.fetchCandidateDataError
        }
    }
    
    func fetchCandidateDetail(request: URLRequest) async throws -> CandidateInformation {
        do {
            let (data, _) = try await httpService.request(request)
            
            let candidate = try JSONDecoder().decode(CandidateInformation.self, from: data)
            return candidate
        } catch {
            throw CandidateFetchError.fetchCandidateDetailError
        }
    }
    
    func validateHTTPResponse(request: URLRequest) async throws -> HTTPURLResponse {
        let (_, response) = try await httpService.request(request)
        guard response.statusCode == 200 else {
            throw CandidateFetchError.httpResponseInvalid(statusCode: response.statusCode)
        }
        return response
    }
    
    func fetchCandidateInformation(token: String, id: String, phone: String?, note: String?, firstName: String, linkedinURL: String?, isFavorite: Bool, email: String, lastName: String, request: URLRequest) async throws -> CandidateInformation {
        let (data, _) = try await httpService.request(request)
        guard let candidate = try? JSONDecoder().decode(CandidateInformation.self, from: data) else {
            throw CandidateFetchError.fetchCandidateInformationError
        }
        return candidate
    }
}
