import SwiftUI

struct CandidateDetailView: View {
    @ObservedObject var candidateViewModel: CandidateViewModel
    @State var recruitTech : [RecruitTech] = []

    var body: some View {
        VStack {
            
            
            
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
            print("dommage  candidat n'est pas passé ")
        }
    }

}
