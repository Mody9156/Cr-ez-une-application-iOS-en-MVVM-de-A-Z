import SwiftUI

struct CandidateDetailView: View {
    @StateObject var candidateViewModel: CandidateViewModel
    @State var recruitTech : [RecruitTech] = []

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
                        Text("\(tech.phone)")
                    }
                    HStack {
                        Text("LinkedIne")
                        Text("\(tech.linkedinURL)")
                    }
                        Text("Note")
                    Text("\(tech.note)")
                   
                }
                
               
            }
            
            
        }.onAppear{
            Task{
                await candidat()
            }
        }
    }
    
     func candidat() async {
        do{
            let data = try await candidateViewModel.fetchcandidateIDFetcher()
            print("felicitation \(data)")
            recruitTech = data
        }catch{
            print("\(recruitTech)")
            print("dommage  candidat n'est pas passé ")
        }
    }

}
