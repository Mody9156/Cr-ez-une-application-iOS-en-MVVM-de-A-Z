import SwiftUI

struct CandidatesListView: View {
    @StateObject var candidateListViewModel: CandidateListViewModel
    @State private var search = ""
    @State private var showFavorites: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                // Liste des candidats
                List {
                    ForEach(searchResult, id: \.id) { candidate in
                        NavigationLink(
                            destination: CandidateDetailView(
                                CandidateDetailsManagerViewModel: CandidateDetailsManagerViewModel(
                                    retrieveCandidateData: CandidateDataManager(),
                                    candidats: candidateListViewModel.candidates
                                ),
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
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.orange)
                    }
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Spacer()
                            Text("Candidats")
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
            .padding()
            .background(Color.white)
            
        }.task {
            await loadCandidates()
        }
    }

    // Résultats de la recherche
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

    // Charger les candidats
    func loadCandidates() async {
        do {
            let candidats = try await candidateListViewModel.displayCandidatesList()
            candidateListViewModel.candidates = candidats
        } catch {
            print("Erreur lors de la récupération des candidats")
        }
    }

    // Basculer l'affichage des favoris
    func toggleShowFavorites() {
        showFavorites.toggle()
    }
}
