import SwiftUI

struct ProfileView: View {
    @State private var userName: String = "User"
    @State private var userRole: String = "SENIOR"
    @State private var address: String = "Not set"

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 16) {
                    Image("profile")
                        .resizable()
                        .frame(width: 130, height: 130)

                    VStack(alignment: .leading, spacing: 0) {
                        Text(userName)
                            .font(.system(size: 30, weight: .bold))
                        Text(userRole)
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                        
                        Spacer().frame(height: 10)
                        
                        Text("My Address:")
                            .font(.system(size: 20, weight: .bold))
                        
                        Spacer().frame(height: 4)
                        
                        Text(address)
                            .font(.system(size: 16))
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer().frame(height: 28)

                VStack(spacing: 10) {
                    ProfileMenuItem(title: "My Health")
                    ProfileMenuItem(title: "Medications")
                    ProfileMenuItem(title: "Family Members")
                    ProfileMenuItem(title: "Appointments")
                    ProfileMenuItem(title: "Account")
                }
            }

            Spacer()

            VStack(spacing: 10) {
                Text("Back")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color(hex: 0x1E88E5))
                    .cornerRadius(4)
                    .shadow(radius: 3, y: 3)

                Text("Log out")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(hex: 0xE3F2FD))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color(hex: 0xF44336))
                    .cornerRadius(4)
                    .shadow(radius: 3, y: 3)
            }
            .padding(.top, 10)
            .padding(.bottom, 8)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
    }
}

struct ProfileMenuItem: View {
    var title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 18))
                .foregroundColor(.black)
            Spacer()
            Image(systemName: "arrow.right")
                .foregroundColor(.black)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(Color(hex: 0xF7F7F7))
        .cornerRadius(8)
    }
}

#Preview {
    ProfileView()
}
