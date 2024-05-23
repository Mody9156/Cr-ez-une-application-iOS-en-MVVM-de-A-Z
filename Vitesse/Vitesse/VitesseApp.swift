import SwiftUI

@main
struct VitesseApp: App {
    @StateObject var vitesseViewModel = VitesseViewModel()
    
    var body: some Scene {
        WindowGroup {
            if vitesseViewModel.onLoginSucceed {
                TabView {
                    CandidatesListView(
                        candidateListViewModel: vitesseViewModel.candidateListViewModel,
                        fetchDeleteCandidateViewModel: vitesseViewModel.fetchDeleteCandidateViewModel,
                        fetchAndProcessCandidateFavoritesViewModel: vitesseViewModel.fetchAndProcessCandidateFavoritesViewModel
                    )
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Candidats")
                    }
                }.onAppear{
                    //
                }
                
            } else {
                LoginView(
                    AuthenticationView: vitesseViewModel.loginViewModel,
                    vitesseViewModel: vitesseViewModel
                )
            }
        }
    }
}
