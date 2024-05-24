import SwiftUI
struct CandidateDetailView: View {
    @ObservedObject var candidateDetailsManager: CandidateDetailsManager
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.5).ignoresSafeArea()
            VStack {
                List {
                    ForEach(candidateDetailsManager.candidats, id: \.id) { tech in // Utilisez candidats du manager
                        VStack {
                            HStack {
                                Text(tech.lastName)
                                Text(tech.firstName)
                                Spacer()
                                Image(systemName: tech.isFavorite ? "star.fill" : "star")
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
                                if let linkedIn = tech.linkedinURL {
                                    Text(linkedIn)
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
    }

    func loadCandidateProfile() async {
        do {
            // Chargez les détails du candidat depuis le manager
            let data = try await candidateDetailsManager.displayCandidateDetails(at: IndexSet())
            candidateDetailsManager.candidats = data
            print("Félicitations")
        } catch {
            print("Dommage, le candidat n'est pas passé")
        }
    }
}
