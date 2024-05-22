import SwiftUI

struct CandidateDetailView: View {
    @StateObject var candidateViewModel: CandidateViewModel
    let candidate: RecruitTech
    @State private var isLoading = false

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
            } else if let info = candidate {
                Text(info.lastName)
                Text(info.firstName)
                
            } else {
                Text("No details available.")
            }
        }
        .onAppear {
            loadCandidateDetails()
        }
    }

    func loadCandidateDetails() {
        Task {
            do {
                isLoading = true
                let details = try await candidateViewModel.fetchDetails(for: candidate.id)
                detailedInfo = details
            } catch {
                print("Failed to load candidate details: \(error)")
            }
            isLoading = false
        }
    }
}
