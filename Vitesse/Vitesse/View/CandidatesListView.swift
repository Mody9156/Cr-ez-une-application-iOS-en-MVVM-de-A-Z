import SwiftUI

struct CandidatesListView: View {
    @StateObject var candidateListViewModel: CandidateListViewModel
    @State private var search = ""
    @State private var showFavorites: Bool = false
    @StateObject var candidateDetailsManagerViewModel: CandidateDetailsManagerViewModel

    var body: some View {
        NavigationStack {
            VStack {
                
                // Candidates list
                List {
                    ForEach(searchResult, id: \.id) { candidate in
                        NavigationLink(
                            // Candidate details
                            destination: CandidateDetailView(
                                CandidateDetailsManagerViewModel: candidateDetailsManagerViewModel,
                                CandidateInformation: candidate
                            )
                        ) {
                            HStack {
                                Text(candidate.firstName)
                                    .foregroundColor(.orange)
                                Text(candidate.lastName)
                                    .foregroundColor(.orange)
                                Spacer()
                                Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                                    .foregroundColor(candidate.isFavorite ? .yellow : .black)
                            }
                        }
                        .listRowSeparator(.visible)
                        .listRowBackground(Color.clear)
                        .listSectionSeparatorTint(.orange)
                    }
                    .onDelete(perform: candidateListViewModel.removeCandidate)
                }.searchable(text: $search)
                .listStyle(PlainListStyle())
                .background(Color.white)
            }
            .padding()
            .background(Color.white)
        }.task {
            await loadCandidates()
        }
    }

    // Search results
    var searchResult: [CandidateInformation] {
        if search.isEmpty {
            return candidateListViewModel.candidats.filter { candidate in
                !showFavorites || candidate.isFavorite
            }
        } else {
            return candidateListViewModel.candidats.filter { candidate in
                let fullName = "\(candidate.firstName) \(candidate.lastName)"
                let lowercaseSearch = search.lowercased()
                let lowercaseFullName = fullName.lowercased()
                
                return (lowercaseFullName.contains(lowercaseSearch) ||
                        candidate.firstName.lowercased().contains(lowercaseSearch) ||
                        candidate.lastName.lowercased().contains(lowercaseSearch)) &&
                       (!showFavorites || candidate.isFavorite)
            }
        }
    }

    // Load candidates
    func loadCandidates() async {
        do {
            let candidates = try await candidateListViewModel.displayCandidatesList()
            candidateListViewModel.candidats = candidates
        } catch {
            print("Error loading candidates")
        }
    }
}
