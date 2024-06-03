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
                        if !showFavorites || candidate.isFavorite {
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
                                    Text(candidate.lastName)
                                        .foregroundColor(.orange)
                                    Text(candidate.firstName)
                                        .foregroundColor(.orange)
                                    Spacer()
                                    Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                                        .foregroundColor(candidate.isFavorite ? .yellow : .black)
                                }
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.orange)
                        }
                    }
                    .onDelete(perform: candidateListViewModel.removeCandidate)
                }
                .listStyle(PlainListStyle()) // Utiliser un style de liste simple
                .background(Color.white) // Ajouter une couleur d'arrière-plan à la liste
                .searchable(text: $search)
                .toolbar {
                    // Bouton pour modifier la liste
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.orange)
                    }
                    // Titre de la vue
                    ToolbarItem(placement: .navigation) {
                        Text("Candidats")
                    }
                    // Bouton pour afficher/masquer les favoris
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: toggleShowFavorites) {
                            Image(systemName: showFavorites ? "star.fill" : "star")
                                .foregroundColor(showFavorites ? .yellow : .black)
                        }
                        .frame(width: 40, height: 40)
                    }
                }
            }
            .padding()
            .background(Color.white) // Ajouter une couleur d'arrière-plan à la vue globale
            .task {
                await loadCandidates()
            }
        }
    }

    // Résultats de la recherche
    var searchResult: [CandidateInformation] {
        if search.isEmpty {
            return candidateListViewModel.candidates
        } else {
            return candidateListViewModel.candidates.filter { candidat in
                candidat.lastName.lowercased().contains(search.lowercased()) ||
                candidat.firstName.lowercased().contains(search.lowercased())
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
        Task {
            do {
                let candidate = try await candidateListViewModel.showFavoriteCandidates()
                print("La mise à jour du statut du favori pour le candidat a réussi : \(String(describing: candidate))")
                showFavorites.toggle()
            } catch {
                print("Dommage, il y a une erreur :", error)
            }
        }
    }
}
