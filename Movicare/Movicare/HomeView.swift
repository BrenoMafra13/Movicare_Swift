import SwiftUI

struct HomeView: View {
    @State private var userRole: String = "senior"
    @State private var userName: String = "Jhon Doe"
    
    var body: some View {
        if userRole.lowercased() == "senior" {
            SeniorDashboard(userName: userName, userRole: userRole)
        } else {
            FamilyCaregiverDashboard()
        }
    }
}

struct SeniorDashboard: View {
    let userName: String
    let userRole: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 12) {
                    Image("profile")
                        .resizable()
                        .frame(width: 75, height: 75)
                    
                    VStack(alignment: .leading) {
                        Text(userName)
                            .font(.system(size: 30, weight: .bold))
                        Text(userRole.uppercased())
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                    }
                }

                VStack {
                    VStack {
                        Text("I'm OK")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer().frame(height: 8)
                        
                        HStack {
                            Image(systemName: "bell.fill")
                            Text("Panic button\nhold 3 sec")
                                .font(.system(size: 20))
                                .lineLimit(2)
                        }
                        .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .background(Color(hex: 0x4CAF50))
                    .cornerRadius(20)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("MEDICATIONS DUE")
                        .font(.system(size: 20, weight: .bold))
                    
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Medication Name")
                                    .font(.system(size: 18, weight: .medium))
                                Text("Dosage • Time")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            HStack {
                                Text("TAKE")
                                    .font(.system(size: 12))
                                    .frame(height: 36)
                                    .padding(.horizontal, 8)
                                    .background(Color(hex: 0x1565C0))
                                    .foregroundColor(.white)
                                    .cornerRadius(4)
                                
                                Text("SNOOZE")
                                    .font(.system(size: 12))
                                    .frame(height: 36)
                                    .padding(.horizontal, 8)
                                    .background(Color(hex: 0xD32F2F))
                                    .foregroundColor(.white)
                                    .cornerRadius(4)
                            }
                        }
                        Divider()
                    }
                }
                .padding(16)
                .background(Color(hex: 0xF8F8F8))
                .cornerRadius(14)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Appointments")
                        .font(.system(size: 20, weight: .bold))
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(Color(hex: 0xEF6C00))
                            .font(.system(size: 26))
                        
                        VStack(alignment: .leading) {
                            Text("Appointment Type")
                                .font(.system(size: 16, weight: .semibold))
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(Color(hex: 0x1565C0))
                                Text("Day at Time")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick Help Request")
                        .font(.system(size: 20, weight: .bold))
                    
                    HStack(spacing: 16) {
                        VStack {
                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 50))
                            Text("Ride")
                                .font(.system(size: 25, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 130)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(18)

                        VStack {
                            Image(systemName: "phone.fill")
                                .font(.system(size: 50))
                            Text("Assistance")
                                .font(.system(size: 25, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 130)
                        .background(Color(hex: 0xE0E0E0))
                        .foregroundColor(.black)
                        .cornerRadius(18)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
    }
}

struct FamilyCaregiverDashboard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("My Seniors")
                .font(.system(size: 24, weight: .bold))
            
            Divider()
            
            VStack(alignment: .leading, spacing: 24) {
                Text("Medications Status")
                    .font(.system(size: 18, weight: .bold))
                
                Text("Upcoming Appointments")
                    .font(.system(size: 18, weight: .bold))
            }
            Spacer()
        }
        .padding(16)
    }
}

#Preview {
    HomeView()
}
