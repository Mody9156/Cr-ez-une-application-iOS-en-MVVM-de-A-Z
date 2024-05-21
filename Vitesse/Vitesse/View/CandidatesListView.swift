import SwiftUI

struct CandidatesListView: View {
    @StateObject var candidateViewModel: CandidateViewModel
    @State private var search = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue.opacity(0.5).ignoresSafeArea()
                VStack {
                    Spacer()
                    VStack {
                        List {
                            ForEach(searchResult, id: \.id) { element in
                                NavigationLink(destination: CandidateDetailView(candidate: element)) {
                                    HStack {
                                        Text(element.lastName)
                                        Text(element.firstName)
                                        Spacer()
                                        Image(systemName: element.isFavorite ? "star.slash" : "star")
                                            .foregroundColor(element.isFavorite ? .yellow : .black)
                                    }
                                }
                                .task {
                                    if let index = candidateViewModel.candidats.firstIndex(where: { $0.id == element.id }) {
                                        do {
                                            let result = try await candidateViewModel.fetchcandidateIDFetcher(at: IndexSet(integer: index))
                                            print("Fetched candidate details: \(result)")
                                        } catch {
                                            print("Failed to fetch candidate details: \(error)")
                                        }
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
                                            let result = try await candidateViewModel.fetchAndProcessCandidateFavorites(at: IndexSet(integer: 0))
                                            print("Favorites Processed: \(String(describing: result))")
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

struct CandidateDetailView: View {
    var candidate: RecruitTech

    var body: some View {
        VStack {
            Text(candidate.lastName)
            Text(candidate.firstName)
        }
        .navigationTitle("Candidate Detail")
    }
}
