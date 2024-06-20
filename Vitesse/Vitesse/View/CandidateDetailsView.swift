import SwiftUI

struct CandidateDetailView: View {
    var candidateListViewModel: CandidateListViewModel
    @StateObject var candidateDetailsManagerViewModel: CandidateDetailsManagerViewModel
    @State private var isEditing = false
    @State private var editedNote: String?
    @State private var editedFirstName: String = ""
    @State private var editedLastName: String = ""
    @State private var editedPhone: String?
    @State private var editedEmail: String = ""
    @State private var editedLinkedIn: String?
    @State var candidateInformation: CandidateInformation
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showFavoris : Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            Section {
                HStack {
                    if isEditing {
                        TextFieldManager(textField: "First Name", text: $editedFirstName)
                        TextFieldManager(textField: "Last Name", text: $editedLastName)
                        
                        Spacer()
                        
                    } else {
                        Text(candidateInformation.firstName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(candidateInformation.lastName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                       
                        
                        Button {
                            Task {
                       
                                    try await candidateListViewModel.showFavoriteCandidates(selectedCandidateId: candidateInformation.id)
                                    try await loadCandidateProfile()
                                    initialiseEditingFields()
                            }
                        } label: {
                          
                            Image(systemName: candidateInformation.isFavorite ? "star.fill" : "star")
                                .foregroundColor(candidateInformation.isFavorite ? .yellow : .black)
                                .font(.title2)
                        }
                        
                    }
                }
                .padding()
                
                HStack {
                    Text("Phone:")
                    if isEditing {
                        TextFieldManager(textField: "Phone", text: Binding(
                            get: { editedPhone ?? "" },
                            set: { editedPhone = $0 }
                        ))
                    } else {
                        if let phone = candidateInformation.phone {
                            Text(phone)
                        } else {
                            Text("No phone available")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                
                HStack {
                    Text("Email:")
                    if isEditing {
                        TextFieldManager(textField: "Email", text: $editedEmail)
                    } else {
                        Text(candidateInformation.email)
                    }
                }
                .padding()
                
                HStack {
                    Text("LinkedIn:")
                    if isEditing {
                        TextFieldManager(textField: "LinkedIn URL", text: Binding(
                            get: { editedLinkedIn ?? "" },
                            set: { editedLinkedIn = $0 }
                        ))
                    } else {
                        if let linkedIn = candidateInformation.linkedinURL,
                           let url = URL(string: linkedIn) {
                            Link("Go on LinkedIn", destination: url)
                                .padding()
                                .border(Color.orange)
                                .foregroundColor(.white)
                                .background(Color.orange)
                                .cornerRadius(10)
                        } else {
                            Text("No LinkedIn available")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Note:")
                    if isEditing {
                        TextFieldManager(textField: "Note", text: Binding(get: { editedNote ?? "" }, set: { editedNote = $0 }))
                    } else {
                        if let note = candidateInformation.note {
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
        }
        .navigationBarBackButtonHidden()
        .task {
            do {
                try await loadCandidateProfile()
                initialiseEditingFields()
              
            } catch {
                NotificationCenter.default.post(name: Notification.Name("LoadCandidateProfileError"), object: error)
            }
        }
        .toolbar {
            toolbarContent
        }
    }
    
    // Toolbar content
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if isEditing {
                Button("Cancel") {
                    
                    isEditing = false
                    initialiseEditingFields()
                }
                .foregroundColor(.orange)
            } else {
                Button {
                    Task{
                        
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Image(systemName: "arrow.left.circle")
                        .foregroundColor(.orange)
                }
            }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            if isEditing {
                Button("Done") {
                    Task {
                        try await saveCandidate()
                        try await loadCandidateProfile()
                        initialiseEditingFields()
                    }
                }
                .foregroundColor(.orange)
            } else {
                Button("Edit") {
                    Task{
                        isEditing.toggle()
                        
                    }
                }
                .foregroundColor(.orange)
            }
        }
    }
}

struct TextFieldManager: View {
    var textField: String = ""
    @Binding var text: String
    
    var body: some View {
        TextField(textField, text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

extension CandidateDetailView {
    func loadCandidateProfile() async throws {
        
        candidateDetailsManagerViewModel.selectedCandidateId = candidateInformation.id
        let loadedCandidate = try await candidateDetailsManagerViewModel.displayCandidateDetails()
        try await  candidateDetailsManagerViewModel.displayCandidateDetails()
        updateView(with: loadedCandidate)
        try await candidateListViewModel.displayCandidatesList()
        
    }
    
    func saveCandidate() async throws {
        
        let updatedCandidate = try await candidateDetailsManagerViewModel.candidateUpdater(
            phone: editedPhone,
            note: editedNote,
            firstName: editedFirstName,
            linkedinURL: editedLinkedIn,
            isFavorite: candidateInformation.isFavorite,
            email: editedEmail,
            lastName: editedLastName,
            id: candidateInformation.id
        )
        candidateDetailsManagerViewModel.updateCandidateInformation(with: updatedCandidate)
        candidateInformation = updatedCandidate
        isEditing.toggle()
        initialiseEditingFields()
    }
    
    func initialiseEditingFields() {
        editedNote = candidateInformation.note ?? ""
        editedFirstName = candidateInformation.firstName
        editedLastName = candidateInformation.lastName
        editedPhone = candidateInformation.phone
        editedEmail = candidateInformation.email
        editedLinkedIn = candidateInformation.linkedinURL
    }
    
    func updateView(with candidate: CandidateInformation) {
        candidateInformation = candidate
        initialiseEditingFields()
    }
}
