import SwiftUI

struct CandidateDetailView: View {
    @StateObject var CandidateDetailsManagerViewModel: CandidateDetailsManagerViewModel
    @State private var isEditing = false
    @State private var editedNote: String?
    @State private var editedFirstName: String = ""
    @State private var editedLastName: String = ""
    @State private var editedPhone: String?
    @State private var editedEmail: String = ""
    @State private var editedLinkedIn: String?
    @State var CandidateInformation: CandidateInformation
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(alignment: .leading) {
            Section {
                HStack {
                    if isEditing {
                        TextFieldManager(textField: "First Name", text: editedFirstName)
                        TextFieldManager(textField: "Last Name", text: editedLastName)
                          
                    } else {
                        Text(CandidateInformation.firstName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(CandidateInformation.lastName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    Spacer()
                    if CandidateInformation.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.title2)
                    }
                }
                .padding()

                HStack {
                    Text("Phone :")
                    if isEditing {
                        TextField("Phone", text: Binding(
                            get: { editedPhone ?? "" },
                            set: { editedPhone = $0 }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        if let phone = CandidateInformation.phone {
                            Text(phone)
                        } else {
                            Text("No phone available")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()

                HStack {
                    Text("Email :")
                    if isEditing {
    
                        TextFieldManager(textField: "Email", text: editedEmail)
                    } else {
                        Text(CandidateInformation.email)
                    }
                }
                .padding()

                HStack {
                    Text("LinkedIn :")
                    if isEditing {
                        TextField("LinkedIn URL", text: Binding(
                            get: { editedLinkedIn ?? "" },
                            set: { editedLinkedIn = $0 }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        if let linkedIn = CandidateInformation.linkedinURL,
                            let url = URL(string: linkedIn) {
                        Link("Go on LinkedIn", destination: url)
                                .padding().border(.orange).foregroundStyle(.white)
                                .background(Color.orange).cornerRadius(10)
                        } else {
                            Text("No LinkedIn available")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()

                VStack(alignment: .leading) {
                    Text("Note :")
                    if isEditing {
                        TextField("Note", text:  Binding(get: {editedNote ?? ""}, set: {editedNote = $0}))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        if let note = CandidateInformation.note {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.orange, lineWidth: 1)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                                .frame(height: 100)
                                .overlay(
                                    Text(note)
                                        .padding()
                                        .foregroundColor(.black),
                                    alignment: .center
                                )

                        } else {
                            Text("No note available")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
            }
            Spacer()
        }.navigationBarBackButtonHidden()
        .onAppear {
            initialiseEditingFields()
            Task {
                await loadCandidateProfile()
               

            }
            
        }
        .toolbar {
            ToolbarContent
        }
    }
    
    
    //toolbar
    @ToolbarContentBuilder
    var ToolbarContent : some ToolbarContent {
        
            ToolbarItem(placement: .navigationBarLeading) {
                   if isEditing {
                       Button("Cancel") {
                           isEditing = false
                       }.foregroundColor(.orange)
                   }else{
                       Button {
                           presentationMode.wrappedValue.dismiss()
                       } label: {
                           Image(systemName: "arrow.left.circle").foregroundColor(.orange)
                       }

                   }
               }
       ToolbarItem(placement: .navigationBarTrailing) {
                if isEditing {
                    Button("Done") {
                       
                        Task {
                            await saveCandidate()
                            
                        }
                    }.foregroundColor(.orange)
                } else {
                    Button("Edit") {
                        isEditing.toggle()
                    }.foregroundColor(.orange)
                }
            }
    }
}

struct TextFieldManager : View {
    var textField : String = ""
    @State var text : String = ""
    
    var body: some View {
        TextField(textField, text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}





extension CandidateDetailView {
     func loadCandidateProfile() async {
        do {
            try await CandidateDetailsManagerViewModel.displayCandidateDetails()
            
            print("Félicitations, loadCandidateProfile est passée")
        } catch {
            print("\(CandidateInformation.email)")
            print("Dommage, le candidat n'est pas passé")
        }
    }

    func saveCandidate() async {
        do {
            let updatedCandidate = try await CandidateDetailsManagerViewModel.candidateUpdater(
                phone: editedPhone,
                note: editedNote,
                firstName: editedFirstName,
                linkedinURL: editedLinkedIn,
                isFavorite: CandidateInformation.isFavorite,
                email: editedEmail,
                lastName: editedLastName,
                id: CandidateInformation.id
            )
            CandidateDetailsManagerViewModel.updateCandidateInformation(with: updatedCandidate)
            isEditing.toggle()
            print("Félicitations Updater \(updatedCandidate)")
        } catch {
            print("Dommage, le Updater n'est pas passé")
        }
    }

    func initialiseEditingFields() {
        editedNote = CandidateInformation.note ?? ""
        editedFirstName = CandidateInformation.firstName
        editedLastName = CandidateInformation.lastName
        editedPhone = CandidateInformation.phone ?? ""
        editedEmail = CandidateInformation.email
        editedLinkedIn = CandidateInformation.linkedinURL ?? ""
    }
}
