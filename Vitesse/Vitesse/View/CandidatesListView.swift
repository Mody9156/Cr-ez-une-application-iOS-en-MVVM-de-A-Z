import SwiftUI
struct CandidatesListView: View {
    @StateObject var candidateListViewModel: CandidateListViewModel
    @State private var search = ""
    @State private var showFavorites : Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
              
                    List {
                        ForEach(searchResult, id: \.id) { candidate in
                            if !showFavorites || candidate.isFavorite {
                                NavigationLink(destination: CandidateDetailView(CandidateDetailsManagerViewModel: CandidateDetailsManagerViewModel(retrieveCandidateData: CandidateDataManager(), candidats: candidateListViewModel.candidates), CandidateInformation: candidate)){
                                    HStack {
                                        Text(candidate.lastName)
                                        Text(candidate.firstName)
                                        Spacer()
                                        
                                        Image(systemName:candidate.isFavorite ? "star.fill" :"star")
                                            .foregroundColor(candidate.isFavorite ? .yellow : .black).listRowSeparatorTint(.orange,edges:.bottom)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: candidateListViewModel.removeCandidate)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            EditButton()
                                .frame(width: 40,height: 40)
                                .foregroundColor(.blue)
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                Task {
                                    do {
                                        let candidate = try await candidateListViewModel.showFavoriteCandidates()
                                        print("La mise à jour du statut du favori pour le candidat a réussi. : \(String(describing: candidate))")
                                        self.showFavorites.toggle()
                                    } catch {
                                        print("Dommage, il y a une erreur :", error)
                                    }
                                }

                            } label: {
                                Image(systemName: showFavorites ?  "star.fill":"star").foregroundColor(showFavorites ? .yellow : .black)
                            }
                            .frame(width: 40,height: 40)
                            .foregroundColor(.blue)
                        }
                       
                    }
                    .searchable(text: $search)
                }
            }
        }
        .task {
            await loadCandidates()
        }
    }
    
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
    
    func loadCandidates() async {
        do {
            let candidats = try await candidateListViewModel.displayCandidatesList()
            candidateListViewModel.candidates = candidats
        } catch {
            print("Erreur lors de la récupération des candidats")
        }
    }
    
  
}
