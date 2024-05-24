import SwiftUI
struct CandidateDetailView: View {
    @ObservedObject var candidateDetailsManager: CandidateDetailsManager
     var candidate: CandidateInformation // Assurez-vous que CandidateInformation est le bon type
    var body: some View {
        ZStack {
            Color.blue.opacity(0.5).ignoresSafeArea()
            VStack {
                List {
                        VStack {
                            HStack {
                                Text(candidate.lastName)
                                Text(candidate.firstName)
                                Spacer()
                                Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                                    .foregroundColor(candidate.isFavorite ? .yellow : .black)
                            }
                            HStack {
                                Text("Phone")
                                if let phone = candidate.phone {
                                    Text(phone)
                                } else {
                                    Text("No phone available")
                                        .foregroundColor(.gray)
                                }
                            }
                            HStack {
                                Text("Email")
                                Text(candidate.email)
                            }
                            HStack {
                                Text("LinkedIn")
                                if let linkedIn = candidate.linkedinURL {
                                    Text(linkedIn)
                                } else {
                                    Text("No LinkedIn available")
                                        .foregroundColor(.gray)
                                }
                            }
                            Text("Note")
                            if let note = candidate.note {
                                Text(note)
                            } else {
                                Text("No note available")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                    
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
