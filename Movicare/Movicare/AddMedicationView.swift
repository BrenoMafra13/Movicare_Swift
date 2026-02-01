import SwiftUI

struct AddMedicationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var medicationName: String = ""
    @State private var dosage: String = ""
    @State private var startDate: String = ""
    @State private var endDate: String = ""
    @State private var time: String = ""
    
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
                HStack {
                    Text(startDate.isEmpty ? "Select start date" : startDate)
                        .foregroundColor(startDate.isEmpty ? .gray : .black)
                    Spacer()
                    Image(systemName: "calendar")
                }
                .padding(12)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))
                
                Text("End date")
                    .font(.system(size: 16, weight: .bold))
                HStack {
                    Text(endDate.isEmpty ? "Select end date" : endDate)
                        .foregroundColor(endDate.isEmpty ? .gray : .black)
                    Spacer()
                    Image(systemName: "calendar")
                }
                .padding(12)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))
                
                Text("Time")
                    .font(.system(size: 16, weight: .bold))
                HStack {
                    Text(time.isEmpty ? "Select a time" : time)
                        .foregroundColor(time.isEmpty ? .gray : .black)
                    Spacer()
                    Image(systemName: "clock")
                }
                .padding(12)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))
                
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
                .padding(.top, 12)
            }
            .padding(16)
        }
        .navigationTitle("Add Medication")
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
