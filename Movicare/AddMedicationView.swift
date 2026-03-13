import SwiftUI
import SwiftData

struct AddMedicationView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    let user: User

    @State private var medicationName: String = ""
    @State private var dosage: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var time: Date = Date()
    @State private var activePicker: PickerKind?
    @State private var showValidationAlert = false
    @State private var validationMessage = ""

    private enum PickerKind: Int, Identifiable {
        case startDate
        case endDate
        case time

        var id: Int { rawValue }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                BoxMedicationImage()
                
                Text("Medication")
                    .font(.system(size: 16, weight: .bold))
                TextField("", text: $medicationName)
                    .padding(12)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))
                
                Text("Dosage")
                    .font(.system(size: 16, weight: .bold))
                TextField("", text: $dosage)
                    .padding(12)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))
                
                Text("Start date")
                    .font(.system(size: 16, weight: .bold))
                Button(action: { activePicker = .startDate }) {
                    HStack {
                        Text(DateFormatter.medicationDate.string(from: startDate))
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "calendar")
                            .foregroundColor(.primary)
                    }
                    .padding(12)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))
                }
                .buttonStyle(.plain)
                
                Text("End date")
                    .font(.system(size: 16, weight: .bold))
                Button(action: { activePicker = .endDate }) {
                    HStack {
                        Text(DateFormatter.medicationDate.string(from: endDate))
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "calendar")
                            .foregroundColor(.primary)
                    }
                    .padding(12)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))
                }
                .buttonStyle(.plain)
                
                Text("Time")
                    .font(.system(size: 16, weight: .bold))
                Button(action: { activePicker = .time }) {
                    HStack {
                        Text(DateFormatter.medicationTime.string(from: time))
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "clock")
                            .foregroundColor(.primary)
                    }
                    .padding(12)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))
                }
                .buttonStyle(.plain)
                
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
                    
                    Button(action: saveMedication) {
                        Text("Save")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(hex: 0x1565C0))
                            .cornerRadius(6)
                    }
                }
                .padding(.top, 12)
            }
            .padding(16)
        }
        .navigationTitle("Add Medication")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .sheet(item: $activePicker) { picker in
            NavigationStack {
                VStack {
                    switch picker {
                    case .startDate:
                        DatePicker(
                            "Start date",
                            selection: $startDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)

                    case .endDate:
                        DatePicker(
                            "End date",
                            selection: $endDate,
                            in: startDate...,
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
                .navigationTitle(titleForPicker(picker))
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

    private func titleForPicker(_ picker: PickerKind) -> String {
        switch picker {
        case .startDate:
            return "Start date"
        case .endDate:
            return "End date"
        case .time:
            return "Time"
        }
    }

    private func saveMedication() {
        let trimmedName = medicationName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDosage = dosage.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            validationMessage = "Medication name is required."
            showValidationAlert = true
            return
        }

        guard !trimmedDosage.isEmpty else {
            validationMessage = "Dosage is required."
            showValidationAlert = true
            return
        }

        guard endDate >= startDate else {
            validationMessage = "End date cannot be earlier than start date."
            showValidationAlert = true
            return
        }

        let medication = Medication(
            name: trimmedName,
            dosage: trimmedDosage,
            startDate: startDate,
            endDate: endDate,
            time: time,
            user: user
        )

        user.medications.append(medication)
        modelContext.insert(medication)
        try? modelContext.save()
        dismiss()
    }
}

struct BoxMedicationImage: View {
    var body: some View {
        HStack {
            Spacer()
            Image("medication")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .padding(8)
            Spacer()
        }
    }
}
