import SwiftUI
import SwiftData

struct HomeView: View {
    @Binding var isLoggedIn: Bool
    @Binding var currentUsername: String
    @Environment(\.modelContext) private var modelContext
    @State private var user: User?
    
    var body: some View {
        Group {
            if let user {
                SeniorDashboard(user: user, isLoggedIn: $isLoggedIn, currentUsername: $currentUsername)
            } else {
                ContentUnavailableView("User not found", systemImage: "person.slash")
            }
        }
        .onAppear(perform: loadCurrentUser)
    }

    private func loadCurrentUser() {
        guard !currentUsername.isEmpty else {
            isLoggedIn = false
            return
        }

        let descriptor = FetchDescriptor<User>(predicate: #Predicate { $0.username == currentUsername })
        user = try? modelContext.fetch(descriptor).first

        if user == nil {
            isLoggedIn = false
            currentUsername = ""
        }
    }
}

struct SeniorDashboard: View {
    @Bindable var user: User
    @Binding var isLoggedIn: Bool
    @Binding var currentUsername: String
    @Environment(\.modelContext) private var modelContext
    @State private var pendingTakenDose: DueMedication?
    @State private var refreshCounter = 0

    private static let dueDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
    }()

    private static let appointmentDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
    }()

    private var nearestUpcomingAppointment: Appointment? {
        let now = Date()
        return user.appointments
            .filter { $0.scheduledAt >= now }
            .sorted { $0.scheduledAt < $1.scheduledAt }
            .first
    }

    private var nextMedicationDue: DueMedication? {
        _ = refreshCounter
        let calendar = Calendar.current
        let now = Date()
        guard let limitDate = calendar.date(byAdding: .day, value: 14, to: now) else {
            return nil
        }

        var nearest: DueMedication?

        for medication in user.medications {
            guard let scheduled = scheduledDueForNextUntakenDose(medication) else {
                continue
            }

            let adjustedDueAt = adjustedDueDate(
                for: medication,
                scheduledDueAt: scheduled.dueAt,
                day: scheduled.dueDay
            )

            if adjustedDueAt < now || adjustedDueAt > limitDate {
                continue
            }

            let candidate = DueMedication(
                medication: medication,
                dueAt: adjustedDueAt,
                dueDay: scheduled.dueDay
            )

            if nearest == nil || candidate.dueAt < nearest!.dueAt {
                nearest = candidate
            }
        }

        return nearest
    }

    private var displayedMedicationDue: DueMedication? {
        pendingTakenDose ?? nextMedicationDue
    }

    private var isShowingTakenState: Bool {
        pendingTakenDose != nil
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 12) {
                    NavigationLink(destination: ProfileView(user: user, isLoggedIn: $isLoggedIn, currentUsername: $currentUsername)) {
                        if let avatarData = user.avatarData, let uiImage = UIImage(data: avatarData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 75, height: 75)
                                .clipShape(Circle())
                        } else {
                            Image("profile")
                                .resizable()
                                .frame(width: 75, height: 75)
                                .clipShape(Circle())
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    VStack(alignment: .leading) {
                        Text(user.fullName)
                            .font(.system(size: 30, weight: .bold))
                        Text("SENIOR")
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
                        if let displayedMedicationDue {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(displayedMedicationDue.medication.name)
                                        .font(.system(size: 18, weight: .medium))
                                    Text("\(displayedMedicationDue.medication.dosage) • \(Self.dueDayFormatter.string(from: displayedMedicationDue.dueAt)) • \(DateFormatter.medicationTime.string(from: displayedMedicationDue.dueAt))")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                HStack(spacing: 8) {
                                    Button(action: {
                                        handleTakeTap(displayedMedicationDue)
                                    }) {
                                        Text(isShowingTakenState ? "Taken" : "TAKE")
                                            .font(.system(size: 12))
                                            .frame(height: 36)
                                            .padding(.horizontal, 8)
                                            .background(isShowingTakenState ? Color.gray : Color(hex: 0x1565C0))
                                            .foregroundColor(.white)
                                            .cornerRadius(4)
                                    }
                                    .disabled(isShowingTakenState)
                                    
                                    Button(action: {
                                        snoozeMedication(displayedMedicationDue)
                                    }) {
                                        Text("SNOOZE")
                                            .font(.system(size: 12))
                                            .frame(height: 36)
                                            .padding(.horizontal, 8)
                                            .background(Color(hex: 0xD32F2F))
                                            .foregroundColor(.white)
                                            .cornerRadius(4)
                                    }
                                    .disabled(isShowingTakenState)
                                }
                            }
                        } else {
                            Text("You dont have any medications to take for the next 2 weeks")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Divider()
                    }
                }
                .padding(16)
                .background(Color(hex: 0xF8F8F8))
                .cornerRadius(14)

                VStack(alignment: .leading, spacing: 12) {
                    Text("NEXT APPOINTMENT")
                        .font(.system(size: 20, weight: .bold))

                    VStack {
                        if let nearestUpcomingAppointment {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(nearestUpcomingAppointment.type)
                                        .font(.system(size: 18, weight: .medium))
                                    Text("\(Self.appointmentDayFormatter.string(from: nearestUpcomingAppointment.scheduledAt)) • \(DateFormatter.medicationTime.string(from: nearestUpcomingAppointment.scheduledAt))")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                        } else {
                            Text("No upcoming appointments")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Divider()
                    }
                }
                .padding(16)
                .background(Color(hex: 0xF8F8F8))
                .cornerRadius(14)
                
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
        .navigationBarHidden(true)
    }

    private func scheduledDueForNextUntakenDose(_ medication: Medication) -> (dueDay: Date, dueAt: Date)? {
        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: medication.startDate)
        let endDay = calendar.startOfDay(for: medication.endDate)

        guard endDay >= startDay else {
            return nil
        }

        let totalDoses = calendar.dateComponents([.day], from: startDay, to: endDay).day! + 1
        guard medication.takenDosesCount < totalDoses else {
            return nil
        }

        guard let dueDay = calendar.date(byAdding: .day, value: medication.takenDosesCount, to: startDay) else {
            return nil
        }

        let timeComponents = calendar.dateComponents([.hour, .minute], from: medication.time)
        guard let dueAt = calendar.date(
            bySettingHour: timeComponents.hour ?? 0,
            minute: timeComponents.minute ?? 0,
            second: 0,
            of: dueDay
        ) else {
            return nil
        }

        return (dueDay, dueAt)
    }

    private func adjustedDueDate(for medication: Medication, scheduledDueAt: Date, day: Date) -> Date {
        let calendar = Calendar.current

        guard
            let snoozedUntil = medication.snoozedUntil,
            let snoozedForDay = medication.snoozedForDay,
            calendar.isDate(snoozedForDay, inSameDayAs: day),
            snoozedUntil > scheduledDueAt
        else {
            return scheduledDueAt
        }

        return snoozedUntil
    }

    private func markAsTaken(_ due: DueMedication) {
        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: due.medication.startDate)
        let endDay = calendar.startOfDay(for: due.medication.endDate)
        let totalDoses = calendar.dateComponents([.day], from: startDay, to: endDay).day! + 1

        due.medication.takenDosesCount += 1
        due.medication.snoozedUntil = nil
        due.medication.snoozedForDay = nil

        if due.medication.takenDosesCount >= totalDoses {
            user.medications.removeAll { $0.id == due.medication.id }
            modelContext.delete(due.medication)
        }

        try? modelContext.save()
        refreshCounter += 1
    }

    private func handleTakeTap(_ due: DueMedication) {
        guard !isShowingTakenState else {
            return
        }

        pendingTakenDose = due

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            markAsTaken(due)
            pendingTakenDose = nil
            refreshCounter += 1
        }
    }

    private func snoozeMedication(_ due: DueMedication) {
        let now = Date()
        let snoozeBase = max(now, due.dueAt)
        guard let snoozedUntil = Calendar.current.date(byAdding: .minute, value: 15, to: snoozeBase) else {
            return
        }

        due.medication.snoozedUntil = snoozedUntil
        due.medication.snoozedForDay = due.dueDay
        try? modelContext.save()
        refreshCounter += 1
    }

    private struct DueMedication {
        let medication: Medication
        let dueAt: Date
        let dueDay: Date
    }
}

#Preview {
    HomeView(isLoggedIn: .constant(true), currentUsername: .constant(""))
    .modelContainer(for: [User.self, Medication.self, Appointment.self], inMemory: true)
}
