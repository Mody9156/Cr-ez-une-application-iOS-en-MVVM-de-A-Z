import SwiftUI

struct CandidatesListView: View {
    @StateObject var candidateViewModel: CandidateViewModel
    @State private var search = ""

    var body: some View {
        NavigationStack {
            ZStack {
                // fond bleu
                Color.blue.opacity(0.5).ignoresSafeArea()
                VStack {
                    Spacer()
                    VStack {
                        List {
                            //foreach sur RecruitTech pour afficher les candidats
                            ForEach(searchResult, id: \.id) { element in
                                NavigationLink(destination:
                                Text(element.lastName)
                                ) {
                                    HStack {
                                        Text(element.lastName)
                                        Text(element.firstName)
                                        Spacer()
                                        Image(systemName: element.isFavorite ? "star.slash" : "star")
                                            .foregroundColor(element.isFavorite ? .yellow : .black)
                                    }
                                }
                                
                            }
                            .onDelete(perform: candidateViewModel.deleteCandidate)
                        }
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                EditButton()
                                    .frame(width: 100, height: 50)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    Task {
                                        do {
                                            let result = try await candidateViewModel.fetchAndProcessCandidateFavorites()
                                        print("fécilicatin vous venez d'afficher les favoris")
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
                        }
                        .toolbar {
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
                }.onAppear{
                    Task{
                        await  cadandidats()
                            
                            }
                }
            }
            .searchable(text: $search)
            .listStyle(.plain)
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden, edges: .bottom)
        }
    }
// initialisation de la barre de recherche
    var searchResult: [RecruitTech] {
        if search.isEmpty {
            return candidateViewModel.candidats
        } else {
            return candidateViewModel.candidats.filter { candidat in
                candidat.lastName.lowercased().contains(search.lowercased()) ||
                candidat.firstName.lowercased().contains(search.lowercased())
            }
        }
    }
    
    
    func cadandidats () async {
        
        do{
           let candidat =  try await candidateViewModel.fetchcandidateIDFetcher()
            print("succes for cadandidats")
            candidateViewModel.candidats = candidat
        }catch{
            print("variable cadandidats has error ")
        }
        
    }
}
