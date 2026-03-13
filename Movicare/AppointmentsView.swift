import SwiftUI
import SwiftData

private extension DateFormatter {
    static let appointmentDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    static let appointmentTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
}

struct AppointmentsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    let user: User

    private var sortedAppointments: [Appointment] {
        user.appointments.sorted { $0.scheduledAt < $1.scheduledAt }
    }
    
    var body: some View {
        VStack {
            if sortedAppointments.isEmpty {
                VStack {
                    Spacer()
                    Text("No appointments yet.")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(sortedAppointments) { appointment in
                        AppointmentCard(
                            type: appointment.type,
                            dayText: DateFormatter.appointmentDay.string(from: appointment.scheduledAt),
                            timeText: DateFormatter.appointmentTime.string(from: appointment.scheduledAt),
                            onRemove: { removeAppointment(appointment) }
                        )
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                }
                .listStyle(.plain)
            }
            
            Spacer().frame(height: 24)
            
            NavigationLink(destination: AddAppointmentView(user: user)) {
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

    private func removeAppointment(_ appointment: Appointment) {
        user.appointments.removeAll { $0.id == appointment.id }
        modelContext.delete(appointment)
        try? modelContext.save()
    }
}

struct AppointmentCard: View {
    let type: String
    let dayText: String
    let timeText: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 24))
                .frame(width: 48, height: 48)
                .background(Color(hex: 0xE3F2FD))
                .foregroundColor(Color(hex: 0x1565C0))
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(type)
                    .font(.system(size: 16, weight: .bold))
                Text(dayText)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Text(timeText)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }

            Spacer()

            Button(action: onRemove) {
                Text("Remove")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .frame(height: 36)
                    .background(Color(hex: 0xD32F2F))
                    .cornerRadius(6)
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(6)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}
