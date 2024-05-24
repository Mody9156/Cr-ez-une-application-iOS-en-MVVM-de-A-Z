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
                  
                        Text("Go on Linkedin").foregroundColor(.white)
                           
                    
                }
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
        }.toolbar{
            Button("Edit") {
                Task{
                    await  candidateUpdater()

                }
            }
        }
  
  }
            

    func loadCandidateProfile() async {
        do {
            // Chargez les détails du candidat depuis le manager
            let data = try await candidateDetailsManager.displayCandidateDetails(at: IndexSet())
            candidateDetailsManager.candidats = data
            print("Félicitations loadCandidateProfile est passée")
        } catch {
            print("Dommage, le candidat n'est pas passé")
        }
    }
    
    func candidateUpdater() async {
        do{
            let data = try await candidateDetailsManager.candidateUpdater(at: IndexSet(), phone: candidate.phone, note: candidate.note, firstName: candidate.firstName, linkedinURL: candidate.linkedinURL, isFavorite: candidate.isFavorite, email: candidate.email, lastName: candidate
                .lastName)
            print("Félicitations Updater ")
        }catch{
            print("Dommage, le Updater n'est pas passé")
        }
    }
    
    
}
