import SwiftUI

struct WelcomeView: View {
    var onLoginClick: () -> Void = {}
    var onSignupClick: () -> Void = {}

    var body: some View {
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

                Button(action: onLoginClick) {
                    Text("Log In")
                        .font(.system(size: 18, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color(hex: 0x2AB3A3))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: onSignupClick) {
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
        .frame(fillMaxSize: .infinity)
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255,
            opacity: alpha
        )
    }
}

extension View {
    func frame(fillMaxSize: CGFloat) -> some View {
        self.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}

#Preview {
    WelcomeView()
}
