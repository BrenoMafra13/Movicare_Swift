import SwiftUI

struct AppointmentsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                Text("No appointments yet.")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer().frame(height: 24)
            
            NavigationLink(destination: AddAppointmentView()) {
                Text("Add Appointment")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color(hex: 0x3949AB))
                    .cornerRadius(4)
            }
        }
        .padding(16)
        .navigationTitle("Appointments")
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
