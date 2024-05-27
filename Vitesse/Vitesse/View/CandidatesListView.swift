import SwiftUI
struct CandidatesListView: View {
    @StateObject var candidateListViewModel: CandidateListViewModel
    @State private var search = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.blue.opacity(0.5).ignoresSafeArea()
                VStack {
              
                    List {
                        ForEach(searchResult, id: \.id) { candidate in
                            NavigationLink(destination:CandidateDetailView(candidateDetailsManager: CandidateDetailsManager(retrieveCandidateData: retrieveCandidateData()), candidate: candidate)){
                                HStack {
                                    Text(candidate.lastName)
                                    Text(candidate.firstName)
                                    Spacer()
                                   
                                        Image(systemName: "star.fill" )
                                            .backgroundStyle(.yellow)
                                    
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
                                    do{
                                        let favoris =   try await candidateListViewModel.showFavoriteCandidates()
                                        print("favoris : \(String(describing: favoris))")
                                    }catch {
                                        print("erreur",error)
                                    }
                                      
                                      
                                }
                            } label: {
                                Image(systemName: "star")
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
            let candidats = try await candidateListViewModel.displayCandidatesList()
            candidateListViewModel.candidats = candidats
        } catch {
            print("Erreur lors de la récupération des candidats")
        }
    }
}
