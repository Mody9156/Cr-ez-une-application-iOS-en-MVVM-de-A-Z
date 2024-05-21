import SwiftUI

struct CandidatesListView: View {
    @StateObject var candidateViewModel: CandidateViewModel
    @State private var search = ""
    @State var test: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue.opacity(0.5).ignoresSafeArea()
                VStack {
                    Spacer()
                    VStack {
                        List {
                            ForEach(searchResult, id: \.id) { element in
                                NavigationLink(destination:
                                    HStack {
                                        Text(element.lastName)
                                        Text(element.firstName)
                                    }
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
                                            // Pass an example IndexSet
                                            let result = try await candidateViewModel.fetchAndProcessCandidateFavorites(at: IndexSet(integer: 0))
                                            print("Favorites Processed: \(result)")
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
                }
            }
            .searchable(text: $search)
            .listStyle(.plain)
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden, edges: .bottom)
        }
    }

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
}
