import SwiftUI

struct RegistrationView: View {
    @State var registerViewModel = RegisterViewModel(registrationRequestBuilder: RegistrationRequestBuilder(httpService: URLSessionHTTPClient()))
    @State private var registre: Bool = false
    @State var infos : String = ""
    @State var login : LoginViewModel

    var body: some View {
            ZStack {
                VStack {
                    Text("Registre")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                        .padding(.bottom,20)

                  
                    VStack(alignment: .leading) {
                        FetchRegistre(registreViewModel: $registerViewModel, infos: "First Name",text:registerViewModel.firstName,textField: "Use First Name valid")
                        FetchRegistre(registreViewModel: $registerViewModel, infos: "Last Name",text:registerViewModel.lastName,textField: "Use Last Name valid")
                        FetchRegistre(registreViewModel: $registerViewModel, infos: "Email",text:registerViewModel.email,textField: "Use Email valid ")

                        PasswordInputField(registreViewModel: $registerViewModel,textNames:"Password")
                        PasswordInputField(registreViewModel: $registerViewModel, textNames:" Confirm Password")
                    }
                    .padding()

                    Button("Create") {
                        Task {
                            try await registerViewModel.handleRegistrationViewModel()
                            self.login.username = registerViewModel.email
                            
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(35)
                }
                .padding()
            }
        
    }
}

struct FetchRegistre: View {
    @Binding var registreViewModel : RegisterViewModel
    @State var infos : String = ""
    @State var text : String = ""
    @State var textField : String = ""
    
    var body: some View {
        Group {
            Text(infos).foregroundColor(.white)
            TextField(textField, text: $text)
                .padding()
                .cornerRadius(5.0)
                .foregroundColor(.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.orange, lineWidth: 2)
                )

        }
    }
}

struct PasswordInputField: View {
    @Binding var registreViewModel : RegisterViewModel
    var textNames : String = ""
    
    var body: some View {
        Group {
            Text(textNames).foregroundColor(.white)
                .font(.title3)
            SecureField("Use Password valid", text: $registreViewModel.password)
                .padding()
                .cornerRadius(5.0)
                .foregroundColor(.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.orange, lineWidth: 2)
                )
            
        }
    }
}
