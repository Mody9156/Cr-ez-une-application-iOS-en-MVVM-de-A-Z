import SwiftUI
struct CandidateDetailView: View {
    @ObservedObject var candidateViewModel: CandidateViewModel
    @State var recruitTech: [RecruitTech]

    var body: some View {
        VStack {
            ForEach(recruitTech) { tech in
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
                }.toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                            .frame(width: 100, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.bottom, 10)
            }.onDelete(perform: candidateViewModel.deleteCandidate)
        }
        .onAppear {
            Task {
                await loadCandidateProfile()
            }
        }
        .padding()
        .background(Color.blue.opacity(0.5).ignoresSafeArea())
    }

    func loadCandidateProfile() async {
        do {
            let data = try await candidateViewModel.fetchCandidateProfile()
            print("Félicitations \(data)")
        } catch {
            print("Dommage, le candidat n'est pas passé")
        }
    }
}
