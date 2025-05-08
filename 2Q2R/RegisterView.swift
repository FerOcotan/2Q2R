import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var registerError = ""
    @State private var agreedToTerms = false

    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            Color.black.opacity(0.2).edgesIgnoringSafeArea(.all)

            VStack(spacing: 16) {
                Spacer()

                // Logo
                Image("logowhite")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)

                Text("Sign up")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                Text("Create an account here")
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

                // Terms of Use Checkbox
                Toggle(isOn: $agreedToTerms) {
                    Text("By signing up you agree with our Terms of Use")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.7))
                }
                .toggleStyle(CheckboxStyle())
                .padding(.horizontal)

                // Register Button
                Button("Register") {
                    register()
                }
                .disabled(!agreedToTerms)
                .foregroundColor(.white)
                .frame(width: 200, height: 50)
                .background(agreedToTerms ? Color.brown : Color.gray)
                .cornerRadius(25)

                // Already a member?
                HStack {
                    Text("Already a member?")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.footnote)
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Sign in")
                            .font(.footnote)
                            .bold()
                            .foregroundColor(.white)
                    }
                }

                // Error
                if !registerError.isEmpty {
                    Text(registerError)
                        .foregroundColor(.red)
                        .padding(.top)
                }

                Spacer()
            }
            .padding()
        }
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

struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(configuration.isOn ? .brown : .gray)
                configuration.label
            }
        }
    }
}
