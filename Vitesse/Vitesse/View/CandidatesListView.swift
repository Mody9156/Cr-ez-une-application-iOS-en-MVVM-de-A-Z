import SwiftUI

struct CandidatesListView: View {
    @StateObject var fetchCandidateProfileViewModel: FetchCandidateProfileViewModel
    @StateObject  var fetchcandidateIDFetcherViewModel: FetchcandidateIDFetcherViewModel
    @State private var search = ""
    @StateObject  var fetchDeleteCandidateViewModel : FetchDeleteCandidateViewModel
    @StateObject  var fetchAndProcessCandidateFavoritesViewModel : FetchAndProcessCandidateFavoritesViewModel
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
                                    Image(systemName: element.isFavorite ? "star.slash" : "star")
                                        .foregroundColor(element.isFavorite ? .yellow : .black)
                                }
                            }
                        }
                        .onDelete(perform: fetchDeleteCandidateViewModel.deleteCandidate)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            EditButton()
                                .frame(width: 100, height: 50)
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
                                    } catch {
                                        print("Failed to process candidate favorites: \(error)")
                                    }
                                }
                            } label: {
                                Image(systemName: "star.fill")
                            }
                            .frame(width: 100, height: 50)
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
            return fetchCandidateProfileViewModel.candidats
        } else {
            return fetchCandidateProfileViewModel.candidats.filter { candidat in
                candidat.lastName.lowercased().contains(search.lowercased()) ||
                candidat.firstName.lowercased().contains(search.lowercased())
            }
        }
    }

    func loadCandidates() async {
        do {
            let candidats = try await fetchCandidateProfileViewModel.fetchCandidateProfile()
            fetchCandidateProfileViewModel.candidats = candidats
        } catch {
            print("Erreur lors de la récupération des candidats")
        }
    }
}
