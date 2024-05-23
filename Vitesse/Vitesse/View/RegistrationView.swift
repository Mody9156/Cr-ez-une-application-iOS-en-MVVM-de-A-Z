import SwiftUI

struct RegistrationView: View {
    @State var registreViewModel = RegistreViewModel(registrationRequestBuilder: RegistrationRequestBuilder(httpService: BasicHTTPClient()))
    @State private var password: String = "test123"
    @State private var registre: Bool = false
    @State var infos : String = ""
    @State var login : LoginViewModel

    var body: some View {
            ZStack {
                Color.blue.opacity(0.5).ignoresSafeArea()
                VStack {
                    Text("Registre")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding()

                    VStack(alignment: .leading) {
                        FetchRegistre(registreViewModel: $registreViewModel, infos: "First Name",text:registreViewModel.firstName,textField: "Use First Name valid")
                        FetchRegistre(registreViewModel: $registreViewModel, infos: "Last Name",text:registreViewModel.lastName,textField: "Use Last Name valid")
                        FetchRegistre(registreViewModel: $registreViewModel, infos: "Email",text:registreViewModel.email,textField: "Use Email valid ")

                        Group {
                            Text("Password").foregroundColor(.white)
                                .font(.title3)
                            SecureField("Use Password valid", text: $registreViewModel.password)
                                .textFieldStyle(.roundedBorder)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)

                            Text("Confirm Password").foregroundColor(.white)
                                .font(.title3)
                            SecureField("Use Password valid", text: $password)
                                .textFieldStyle(.roundedBorder)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                    }
                    .padding()

                    Button("Create") {
                        Task {
                            try await registreViewModel.handleRegistrationViewModel()
                            self.login.username = registreViewModel.email
                        }
                    }
                    .frame(width: 100, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
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
        Group {
            Text(infos).foregroundColor(.white)
            TextField(textField, text: $text)
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)

        }
    }
}
