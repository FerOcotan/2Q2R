import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loginError = ""
    @State private var isLoggedIn = false
    @State private var showRegister = false
    @State private var showPassword = false
    @State private var vm = AuthenticationView()
    @State private var showContent = false


    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg") // Nombre de tu imagen de fondo
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                Color.black.opacity(0.2).edgesIgnoringSafeArea(.all) // Para contraste con el fondo

                VStack(spacing: 16) {
                    Spacer()

                    // Logo
                    Image ("logowhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    Text("Sign In")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("Welcome back")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    // Email
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)

                    // Password
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                        if showPassword {
                            TextField("Password", text: $password)
                                .foregroundColor(.white)
                        } else {
                            SecureField("Password", text: $password)
                                .foregroundColor(.white)
                        }
                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)

                    // Login Button
                    Button("Login") {
                        login()
                    }
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.brown)
                    .cornerRadius(25)


                    // Google Sign In Button más pequeño y redondo
                    GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light)) {
                        vm.signInWithGoogle()
                    }
                    .frame(width: 300, height: 40) // Más pequeño que los inputs
                    .clipShape(Capsule())
                    .padding(.top, 4)




                    Button(action: {
                        showRegister = true
                    }) {
                        (
                            Text("Don't have an account? ")
                                .foregroundColor(.white.opacity(0.8))
                            +
                            Text("Register")
                                .bold()
                                .foregroundColor(.white.opacity(0.9))
                        )
                        .font(.footnote)
                    }
                    .padding(.top, 8)

                    
                    Spacer()

                    NavigationLink(destination: RegisterView(), isActive: $showRegister) {
                        EmptyView()
                    }

                    NavigationLink(value: isLoggedIn) {
                        EmptyView()
                    }
                    .navigationDestination(isPresented: $isLoggedIn) {
                        ContentView()
                            .navigationBarBackButtonHidden(true)
                    }
                }
                .padding()
            }
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
