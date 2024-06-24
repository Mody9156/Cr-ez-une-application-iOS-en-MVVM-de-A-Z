import SwiftUI

struct CandidatesListView: View {
    @StateObject var candidateListViewModel: CandidateListViewModel
    @State private var search = ""
    @State private var showFavorites: Bool = false
    @StateObject var candidateDetailsManagerViewModel: CandidateDetailsManagerViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // Liste des candidats
                List {
                    ForEach(searchResult, id: \.id) { candidate in
                        NavigationLink(
                            // Détails du candidat
                            destination: CandidateDetailView(
                                candidateListViewModel: candidateListViewModel, candidateDetailsManagerViewModel: candidateDetailsManagerViewModel, // Utilisez le même ViewModel
                                candidateInformation: candidate
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
                    .onDelete(perform:  removeCandidate)
                }
                .searchable(text: $search)
                .listStyle(PlainListStyle())
                .background(Color.white)
            }
            .toolbar {
                toolbarContent
            }
            .background(Color.white)
            .onAppear {
                Task {
                    await loadCandidates()
                }
            }
        }
    }
    
    // Résultats de la recherche
    var searchResult: [CandidateInformation] {
        if search.isEmpty {
            return candidateListViewModel.candidate.filter { candidate in
                !showFavorites || candidate.isFavorite
            }
        } else {
            return candidateListViewModel.candidate.filter { candidate in
                let fullName = "\(candidate.firstName) \(candidate.lastName)"
                let fullName_two = "\(candidate.lastName) \(candidate.firstName)"
                let lowercaseSearch = search.trimmingCharacters(in: .whitespaces).lowercased()
                let lowercaseFullName = fullName.lowercased()
                let lowercaseFullName_two = fullName_two.lowercased()
                
                return (lowercaseFullName.contains(lowercaseSearch) ||
                        candidate.firstName.lowercased().contains(lowercaseSearch) ||
                        candidate.lastName.lowercased().contains(lowercaseSearch)) || lowercaseFullName_two.contains(lowercaseSearch) &&
                (!showFavorites || candidate.isFavorite)
            }
        }
    }
    
    // Charger les candidats
    func loadCandidates() async {
        if let candidates = try? await candidateListViewModel.displayCandidatesList() {
            candidateListViewModel.candidate = candidates
        }
    }
    
    // Basculer l'affichage des favoris
    func toggleShowFavorites() {
        showFavorites.toggle()
    }
    
    // Remove candidate
    func removeCandidate(at offsets: IndexSet)  {
        Task {
            try await candidateListViewModel.deleteCandidate(at: offsets)
        }
         
}

    // Contenu de la barre d'outils
    @ToolbarContentBuilder // une manière pratique et structurée d'ajouter des éléments de barre d'outils à vos vues.
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            EditButton()
                .foregroundColor(.orange)
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: toggleShowFavorites) {
                Image(systemName: showFavorites ? "star.fill" : "star")
                    .foregroundColor(showFavorites ? .yellow : .black)
            }
        }
    }
}
