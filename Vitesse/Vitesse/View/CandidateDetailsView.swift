import SwiftUI

struct CandidateDetailView: View {
    @StateObject var candidateViewModel: CandidateViewModel


    var body: some View {
        VStack {
            
            
        }.onAppear{
            Task{
              await  candidat()
            }
        }
    }
    
    func candidat() async {
        do{
            let data = try await candidateViewModel.fetchcandidateIDFetcher()
            print("felicitation \(data)")
        }catch{
            print("dommage  candidat n'est pas passé ")
        }
    }

}
