import SwiftUI
import SwiftData

extension DateFormatter {
    static let medicationDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()

    static let medicationTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
}

struct MedicationsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    let user: User

    private var sortedMedications: [Medication] {
        user.medications.sorted { lhs, rhs in
            if lhs.startDate == rhs.startDate {
                return lhs.time < rhs.time
            }
            return lhs.startDate < rhs.startDate
        }
    }
    
    var body: some View {
        VStack {
            if sortedMedications.isEmpty {
                VStack {
                    Spacer()
                    Text("No medications yet.")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                    Spacer()
                }
            } else {
                List {
                    ForEach(sortedMedications) { med in
                        MedicationCard(
                            name: med.name,
                            dosage: med.dosage,
                            scheduleText: "\(DateFormatter.medicationDate.string(from: med.startDate)) - \(DateFormatter.medicationDate.string(from: med.endDate))",
                            time: DateFormatter.medicationTime.string(from: med.time),
                            onRemove: { removeMedication(med) }
                        )
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                }
                .listStyle(.plain)
            }
            
            Spacer()
            
            NavigationLink(destination: AddMedicationView(user: user)) {
                Text("Add Medication")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(hex: 0x4CAF50))
                    .cornerRadius(4)
                    .shadow(radius: 3, y: 3)
            }
            .padding(16)
        }
        .navigationTitle("My Medications")
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

    private func removeMedication(_ medication: Medication) {
        user.medications.removeAll { $0.id == medication.id }
        modelContext.delete(medication)
        try? modelContext.save()
    }
}

struct MedicationCard: View {
    var name: String
    var dosage: String
    var scheduleText: String
    var time: String
    var onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image("medication")
                .resizable()
                .frame(width: 48, height: 48)
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.system(size: 16, weight: .bold))
                Text(dosage)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Text("\(scheduleText) - \(time)")
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
