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
            }
            Text("Note")
            ZStack {
                Rectangle().border(.black,width: 1).frame(width: 380, height: 100, alignment: .leading).foregroundColor(.white).cornerRadius(10)
               
                if let note = candidate.note {
                    Text(note)
                } else {
                    Text("No note available")
                        .foregroundColor(.gray)
                    
                }
                
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
