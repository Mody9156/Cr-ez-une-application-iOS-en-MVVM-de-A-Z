import SwiftUI

struct RegistrationView: View {
    @State var registreViewModel = RegistreViewModel(registrationRequestBuilder: RegistrationRequestBuilder(httpService: BasicHTTPClient()))
    @State private var password: String = "test123"
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
                        FetchRegistre(registreViewModel: $registreViewModel, infos: "First Name",text:registreViewModel.firstName,textField: "Use First Name valid")
                        FetchRegistre(registreViewModel: $registreViewModel, infos: "Last Name",text:registreViewModel.lastName,textField: "Use Last Name valid")
                        FetchRegistre(registreViewModel: $registreViewModel, infos: "Email",text:registreViewModel.email,textField: "Use Email valid ")
                        Group {
                            PasswordInputField(registreViewModel: $registreViewModel, password: $password,textNames: "Password")
                            PasswordInputField(registreViewModel: $registreViewModel, password: $password,textNames: "Confirm Password")
                        }
                    }
                    .padding()

                    Button("Create") {
                        Task {
                            try await registreViewModel.handleRegistrationViewModel()
                            self.login.username = registreViewModel.email
                            
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
    @Binding var registreViewModel : RegistreViewModel
    @State var infos : String = ""
    @State var text : String = ""
    @State var textField : String = ""
    
    var body: some View {
      
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


struct PasswordInputField: View {
    @Binding var registreViewModel : RegistreViewModel
    @Binding var password : String
    var textNames : String = ""
    
    var body: some View {
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
            
//            Text("Confirm Password").foregroundColor(.white)
//                .font(.title3)
//            SecureField("Use Password valid", text: $password)
//                .padding()
//                .cornerRadius(5.0)
//                .foregroundColor(.black)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 5)
//                        .stroke(Color.orange, lineWidth: 2)
//                )
    }
}
