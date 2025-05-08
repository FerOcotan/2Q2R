import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseAuth
import GoogleSignInSwift

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loginError = ""
    @State private var isLoggedIn = false
    @State private var showRegister = false
    @State private var vm = AuthenticationView()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
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
                
                Button("Login") {
                    login()
                }
                .foregroundColor(.white)
                .frame(width: 200, height: 50)
                .background(Color.blue)
                .cornerRadius(10)

                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light)) {
                    vm.signInWithGoogle()
                }
                
                Button("Don't have an account? Register") {
                    showRegister = true
                }
                .foregroundColor(.blue)

                if !loginError.isEmpty {
                    Text(loginError)
                        .foregroundColor(.red)
                        .padding()
                }

                NavigationLink(value: isLoggedIn) {
                    EmptyView()
                }
                .navigationDestination(isPresented: $isLoggedIn) {
                    ContentView()
                        .navigationBarBackButtonHidden(true)
                }

                NavigationLink(destination: RegisterView()) {
                    EmptyView()
                }
                .opacity(0)
                .navigationDestination(isPresented: $showRegister) {
                    RegisterView()
                }
            }
            .padding()
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                loginError = error.localizedDescription
                isLoggedIn = false
            } else {
                isLoggedIn = true
            }
        }
    }
}
