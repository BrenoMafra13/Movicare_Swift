import SwiftUI

struct MedicationsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var medications = [
        (name: "Amoxicillin", dosage: "500mg", schedule: "Jan 30 - Feb 10", time: "08:00 AM"),
        (name: "Ibuprofen", dosage: "200mg", schedule: "Jan 30 - Jan 31", time: "02:00 PM")
    ]
    
    var body: some View {
        VStack {
            if medications.isEmpty {
                VStack {
                    Spacer()
                    Text("No medications yet.")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                    Spacer()
                }
            } else {
                List {
                    ForEach(medications, id: \.name) { med in
                        MedicationCard(
                            name: med.name,
                            dosage: med.dosage,
                            scheduleText: med.schedule,
                            time: med.time
                        )
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                }
                .listStyle(.plain)
            }
            
            Spacer()
            
            NavigationLink(destination: AddMedicationView()) {
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
}

struct MedicationCard: View {
    var name: String
    var dosage: String
    var scheduleText: String
    var time: String
    
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
            
            Button(action: {}) {
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
