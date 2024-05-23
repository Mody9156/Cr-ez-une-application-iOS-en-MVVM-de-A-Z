import SwiftUI

struct CandidatesListView: View {
    @StateObject var candidateListViewModel : CandidateListViewModel

    @StateObject  var fetchcandidateIDFetcherViewModel: FetchcandidateIDFetcherViewModel
    @State private var search = ""
    @StateObject  var fetchDeleteCandidateViewModel : FetchDeleteCandidateViewModel
    @StateObject  var fetchAndProcessCandidateFavoritesViewModel : FetchAndProcessCandidateFavoritesViewModel
    @State private var like : Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue.opacity(0.5).ignoresSafeArea()
                VStack {
                    List {
                        ForEach(searchResult, id: \.id) { element in
                            NavigationLink(destination:
                                Text(element.lastName)
                            ){
                                HStack {
                                    Text(element.lastName)
                                    Text(element.firstName)
                                    Spacer()
                                    if element.isFavorite {
                                        Image(systemName: "star.fill" )
                                            .backgroundStyle(.yellow)
                                    }
                                    
                                }
                            }
                        }
                        .onDelete(perform: fetchDeleteCandidateViewModel.deleteCandidate)
                    
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            EditButton()
                                
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                Task {
                                    do {
                                        let result = try await fetchAndProcessCandidateFavoritesViewModel.fetchAndProcessCandidateFavorites()
                                        print("Félicitations, vous venez d'afficher les favoris : \(String(describing: result))")
                                         let like = true
                                    } catch {
                                        print("Failed to process candidate favorites: \(error)")
                                    }
                                }
                            } label: {
                                Image(systemName: "star.fill")
                            }
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        ToolbarItem(placement: .navigation) {
                            Text("Candidats")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .padding()
                        }
                    }.searchable(text: $search)
                    
                }
            }
        }
        .task {
            await loadCandidates()
        }
    }

    var searchResult: [CandidateInformation] {
        if search.isEmpty {
            return candidateListViewModel.candidats
        } else {
            return candidateListViewModel.candidats.filter { candidat in
                candidat.lastName.lowercased().contains(search.lowercased()) ||
                candidat.firstName.lowercased().contains(search.lowercased())
            }
        }
    }
    
    

    func loadCandidates() async {
        do {
            let candidats = try await candidateListViewModel.fetchCandidateProfile()
            candidateListViewModel.candidats = candidats
        } catch {
            print("Erreur lors de la récupération des candidats")
        }
    }
}
