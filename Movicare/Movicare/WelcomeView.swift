import SwiftUI

struct WelcomeView: View {
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                    .frame(height: 10)
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 260, height: 260)
                    .padding(.top, 40)
                
                VStack(alignment: .center, spacing: 12) {
                    Text("Welcome!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(hex: 0x0C2340))
                    
                    Text("Personal senior care and safety App.")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: 0x7A7A7A))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                }
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 16) {
                    Spacer()
                        .frame(height: 40)
                    
                    NavigationLink(destination: LoginView(isLoggedIn: $isLoggedIn)) {
                        Text("Log In")
                            .font(.system(size: 18, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color(hex: 0x2AB3A3))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    NavigationLink(destination: SignupView()) {
                        Text("Sign Up")
                            .font(.system(size: 18, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color(hex: 0x1B75BC))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    WelcomeView(isLoggedIn: .constant(false))
}
