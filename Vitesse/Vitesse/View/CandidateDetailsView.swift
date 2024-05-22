import SwiftUI
struct CandidateDetailView: View {
    @ObservedObject var fetchcandidateIDFetcherViewModel: FetchcandidateIDFetcherViewModel
    @ObservedObject var fetchDeleteCandidateViewModel : FetchDeleteCandidateViewModel
    @State var recruitTech: [RecruitTech]

    var body: some View {
        ZStack {
          Color.blue.opacity(0.5).ignoresSafeArea()
            VStack {
                List {
                   
               
                    ForEach(recruitTech, id: \.id) { tech in
                        VStack {
                            HStack {
                                Text(tech.lastName)
                                Text(tech.firstName)
                                Spacer()
                                Image(systemName: tech.isFavorite ? "star.slash" : "star")
                                    .foregroundColor(tech.isFavorite ? .yellow : .black)
                            }
                            HStack {
                                Text("Phone")
                                if let phone = tech.phone {
                                    Text(phone)
                                } else {
                                    Text("No phone available")
                                        .foregroundColor(.gray)
                                }
                            }
                            HStack {
                                Text("Email")
                                Text(tech.email)
                            }
                            HStack {
                                Text("LinkedIn")
                                if let LinkedIn = tech.linkedinURL {
                                    Text(LinkedIn)
                                } else {
                                    Text("No LinkedIn available")
                                        .foregroundColor(.gray)
                                }
                            }
                            Text("Note")
                            if let note = tech.note {
                                Text(note)
                            } else {
                                Text("No note available")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        
                        
                    }.onDelete(perform: fetchDeleteCandidateViewModel.deleteCandidate)
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .frame(width: 100, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .onAppear {
                Task {
                    await loadCandidateProfile()
                }
            }
            .padding()
            
        }
        }
    }

    func loadCandidateProfile() async {
        do {
            let data = try await fetchcandidateIDFetcherViewModel.fetchcandidateIDFetcher(at: IndexSet(integer: 3))
            print("Félicitations ")
        } catch {
            print("Dommage, le candidat n'est pas passé")
        }
    }
}
