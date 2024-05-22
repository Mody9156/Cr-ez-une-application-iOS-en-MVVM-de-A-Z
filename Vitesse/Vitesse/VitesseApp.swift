import SwiftUI

@main
struct VitesseApp: App {
    @StateObject var vitesseViewModel = VitesseViewModel()
    
    var body: some Scene {
        WindowGroup {
            if vitesseViewModel.onLoginSucceed {
                TabView {
                    CandidatesListView(
                        fetchCandidateProfileViewModel: vitesseViewModel.fetchCandidateProfileViewModel,
                        fetchcandidateIDFetcherViewModel: vitesseViewModel.fetchCandidateIDFetcherViewModel,
                        fetchDeleteCandidateViewModel: vitesseViewModel.fetchDeleteCandidateViewModel,
                        fetchAndProcessCandidateFavoritesViewModel: vitesseViewModel.fetchAndProcessCandidateFavoritesViewModel
                    )
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Candidats")
                    }
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
