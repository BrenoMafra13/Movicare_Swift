import SwiftUI
import SwiftData

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @Environment(\.dismiss) var dismiss
    
    @State private var username = ""
    @State private var password = ""
    @State private var navigateToHome = false
    @State private var errorMessage: String? = nil
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
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
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.bottom, 8)
                }

                Button(action: {
                    Task {
                        do {
                            let request = FetchDescriptor<User>(predicate: #Predicate { $0.username == username })
                            if let user = try context.fetch(request).first, user.password == password {
                                isLoggedIn = true
                            } else {
                                errorMessage = "Invalid username or password"
                            }
                        } catch {
                            errorMessage = "An error occurred. Please try again."
                        }
                    }
                }) {
                    Text("Log In")
                        .font(.system(size: 18, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(username.isEmpty || password.isEmpty ? Color.gray : Color(hex: 0x2AB3A3))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(username.isEmpty || password.isEmpty)
                
                NavigationLink(destination: SignupView()) {
                    Text("Create account")
                        .foregroundColor(.blue)
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 32)
        }
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
}
