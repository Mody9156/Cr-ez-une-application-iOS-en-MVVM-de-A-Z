import SwiftUI
struct CandidateDetailView: View {
    @ObservedObject var candidateDetailsManager: CandidateDetailsManager
     var candidate: CandidateInformation // Assurez-vous que CandidateInformation est le bon type
    var body: some View {
        
        VStack(alignment: .leading) {
            Group {

            HStack {
                Text(candidate.lastName)
                    .font(.title2)
                Text(candidate.firstName)
                    .font(.title2)
                Spacer()
                Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                    .foregroundColor(candidate.isFavorite ? .yellow : .black).font(.title2)
            }
                
            HStack {
                Text("Phone").font(.title3)
                if let phone = candidate.phone {
                    Text(phone)
                } else {
                    Text("No phone available")
                        .foregroundColor(.gray)
                }
            }
                
            HStack {
                Text("Email").font(.title3)
                Text(candidate.email)
            }
            HStack {
                Text("LinkedIn").font(.title3)
                if let linkedIn = candidate.linkedinURL {
                    Text(linkedIn)
                } else {
                    Text("No LinkedIn available")
                        .foregroundColor(.gray)
                }
            }
            }
            Text("Note").font(.title3)
            if let note = candidate.note {
                Text(note)
            } else {
                Text("No note available")
                    .foregroundColor(.gray).border(.blue,width: 2)
            }
        }
        .padding()
        
        .onAppear {
            Task {
                await loadCandidateProfile()
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
