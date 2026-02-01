import SwiftUI

struct AddAppointmentView: View {
    @Environment(\.dismiss) var dismiss
    @State private var appointmentType: String = ""
    @State private var day: String = ""
    @State private var time: String = ""
    
    var body: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Appointment type")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                TextField("", text: $appointmentType)
                    .padding(12)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.5), lineWidth: 1))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Day")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                HStack {
                    Text(day.isEmpty ? "Select Day" : day)
                        .foregroundColor(day.isEmpty ? .gray : .primary)
                    Spacer()
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.5), lineWidth: 1))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Time")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                HStack {
                    Text(time.isEmpty ? "Select Time" : time)
                        .foregroundColor(time.isEmpty ? .gray : .primary)
                    Spacer()
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.5), lineWidth: 1))
            }
            
            Spacer().frame(height: 12)
            
            HStack(spacing: 16) {
                Button(action: { dismiss() }) {
                    Text("Cancel")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(hex: 0xD32F2F))
                        .cornerRadius(6)
                }
                
                Button(action: { dismiss() }) {
                    Text("Save")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(hex: 0x1565C0))
                        .cornerRadius(6)
                }
            }
            Spacer()
        }
        .padding(16)
        .navigationTitle("Add Appointment")
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
