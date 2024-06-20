import SwiftUI

@main
struct VitesseApp: App {
    @StateObject var vitesseViewModelManager = VitesseViewModelManager()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if vitesseViewModelManager.onLoginSucceed {
                    TabView {
                        CandidatesListView(
                            candidateListViewModel: vitesseViewModelManager.candidateListViewModel,
                            candidateDetailsManagerViewModel: vitesseViewModelManager.candidateDetailsManager)
                    }
                    .onAppear {
                        // Create a new candidate
                        // Example: vitesseViewModel.createNewCandidate()

                    }
                } else {
                    LoginView(
                        loginViewModel: vitesseViewModelManager.loginViewModel,
                        vitesseViewModel: VitesseViewModelManager())
                }
            }
        }
    }
}
