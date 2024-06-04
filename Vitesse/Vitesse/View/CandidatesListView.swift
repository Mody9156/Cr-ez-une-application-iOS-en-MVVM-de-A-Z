import SwiftUI

struct CandidatesListView: View {
    @StateObject var candidateListViewModel: CandidateListViewModel
    @State private var search = ""
    @State private var showFavorites: Bool = false
    @ObservedObject var candidateDetailsManagerViewModel: CandidateDetailsManagerViewModel

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
                }
                .listStyle(PlainListStyle())
                .background(Color.white)
                .searchable(text: $search)
                .toolbar {
                    toolbarContent
                }
                
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
            return candidateListViewModel.candidates.filter { candidate in
                !showFavorites || candidate.isFavorite
            }
        } else {
            return candidateListViewModel.candidates.filter { candidate in
                (candidate.lastName.lowercased().contains(search.lowercased()) ||
                candidate.firstName.lowercased().contains(search.lowercased())) &&
                (!showFavorites || candidate.isFavorite)
            }
        }
    }

    // Load candidates
    func loadCandidates() async {
        do {
            let candidates = try await candidateListViewModel.displayCandidatesList()
            candidateListViewModel.candidates = candidates
        } catch {
            print("Error loading candidates")
        }
    }
    
    // Toggle favorites view
    func toggleShowFavorites() {
        showFavorites.toggle()
    }
    
    // Toolbar content
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            EditButton()
                .frame(width: 40, height: 40)
                .foregroundColor(.orange)
        }
        ToolbarItem(placement: .principal) {
            HStack {
                Spacer()
                Text("Candidates")
                    .font(.headline)
                    .foregroundColor(.orange)
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: toggleShowFavorites) {
                Image(systemName: showFavorites ? "star.fill" : "star")
                    .foregroundColor(showFavorites ? .yellow : .orange)
            }
            .frame(width: 40, height: 40)
        }
    }
}
