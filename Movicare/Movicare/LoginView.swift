import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    
    var onBackClick: () -> Void = {}
    var onGoToSignUp: () -> Void = {}
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 0) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding(.bottom, 24)

                    Spacer()
                        .frame(height: 16)

                    TextField("Username", text: $username)
                        .textFieldStyle(.outlined)
                        .autocapitalization(.none)

                    Spacer()
                        .frame(height: 12)

                    SecureField("Password", text: $password)
                        .textFieldStyle(.outlined)

                    Spacer()
                        .frame(height: 28)

                    Button(action: { }) {
                        Text("Log In")
                            .font(.system(size: 18, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(username.isEmpty || password.isEmpty ? Color.gray : Color(hex: 0x2AB3A3))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(username.isEmpty || password.isEmpty)

                    Button(action: onGoToSignUp) {
                        Text("Create account")
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 32)
            }
            .navigationTitle("Login")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: onBackClick) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

extension TextFieldStyle where Self == OutlinedTextFieldStyle {
    static var outlined: OutlinedTextFieldStyle { OutlinedTextFieldStyle() }
}

struct OutlinedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
    }
}

#Preview {
    LoginView()
}
