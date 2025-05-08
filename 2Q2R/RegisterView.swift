import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var registerError = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Register")
                .font(.largeTitle)
                .bold()
            
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            Button("Register") {
                register()
            }
            .foregroundColor(.white)
            .frame(width: 200, height: 50)
            .background(Color.green)
            .cornerRadius(10)
            
            Button("Back to login") {
                dismiss()
            }
            
            if !registerError.isEmpty {
                Text(registerError)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                registerError = error.localizedDescription
            } else {
                dismiss()
            }
        }
    }
}
