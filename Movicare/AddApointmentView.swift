import SwiftUI
import SwiftData

private extension DateFormatter {
    static let appointmentPickerDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    static let appointmentPickerTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
}

struct AddAppointmentView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    let user: User

    @State private var appointmentType: String = ""
    @State private var day: Date = Date()
    @State private var time: Date = Date()
    @State private var activePicker: PickerKind?
    @State private var showValidationAlert = false
    @State private var validationMessage = ""

    private enum PickerKind: Int, Identifiable {
        case day
        case time

        var id: Int { rawValue }
    }
    
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
                Button(action: { activePicker = .day }) {
                    HStack {
                        Text(DateFormatter.appointmentPickerDay.string(from: day))
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                }
                .buttonStyle(.plain)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Time")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Button(action: { activePicker = .time }) {
                    HStack {
                        Text(DateFormatter.appointmentPickerTime.string(from: time))
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                }
                .buttonStyle(.plain)
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
                
                Button(action: saveAppointment) {
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
        .sheet(item: $activePicker) { picker in
            NavigationStack {
                VStack {
                    switch picker {
                    case .day:
                        DatePicker(
                            "Day",
                            selection: $day,
                            in: Date()...,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                    case .time:
                        DatePicker(
                            "Time",
                            selection: $time,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.wheel)
                    }
                    Spacer()
                }
                .padding(16)
                .navigationTitle(picker == .day ? "Day" : "Time")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            activePicker = nil
                        }
                    }
                }
            }
        }
        .alert("Unable to save", isPresented: $showValidationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(validationMessage)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.primary)
                }
            }
        }
    }

    private func saveAppointment() {
        let trimmedType = appointmentType.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedType.isEmpty else {
            validationMessage = "Appointment type is required."
            showValidationAlert = true
            return
        }

        let dayStart = Calendar.current.startOfDay(for: day)
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
        guard let scheduledAt = Calendar.current.date(
            bySettingHour: timeComponents.hour ?? 0,
            minute: timeComponents.minute ?? 0,
            second: 0,
            of: dayStart
        ) else {
            validationMessage = "Could not create appointment date."
            showValidationAlert = true
            return
        }

        let appointment = Appointment(type: trimmedType, scheduledAt: scheduledAt, user: user)
        user.appointments.append(appointment)
        modelContext.insert(appointment)
        try? modelContext.save()
        dismiss()
    }
}
