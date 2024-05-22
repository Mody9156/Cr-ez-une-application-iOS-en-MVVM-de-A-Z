import SwiftUI
struct CandidateDetailView: View {
    @ObservedObject var candidateViewModel: CandidateViewModel
    var recruitTech: [RecruitTech]

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
                        Text(tech.phone)
                    }
                    HStack {
                        Text("LinkedIn")
                        Text(tech.linkedinURL)
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
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.bottom, 10)
            }
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
