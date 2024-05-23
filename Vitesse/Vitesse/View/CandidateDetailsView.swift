import SwiftUI

struct CandidateDetailView: View {
    @ObservedObject var candidateDetailsManager: CandidateDetailsManager

    var body: some View {
        ZStack {
            Color.blue.opacity(0.5).ignoresSafeArea()
            VStack {
                List {
                    ForEach(candidateDetailsManager.candidats, id: \.id) { tech in
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
                    
                }
                .toolbar {
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
            let data = try await candidateDetailsManager.displayCandidateDetails(at: IndexSet())
            candidateDetailsManager.candidats = data
            print("Félicitations")
        } catch {
            print("Dommage, le candidat n'est pas passé")
        }
    }
}
