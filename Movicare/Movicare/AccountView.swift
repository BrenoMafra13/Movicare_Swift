import SwiftUI

struct AccountView: View {
    @Environment(\.dismiss) var dismiss
    @State private var street: String = ""
    @State private var unit: String = ""
    @State private var postalCode: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 0) {
                Image("profile")
                    .resizable()
                    .frame(width: 170, height: 170)
                    .clipShape(Circle())
                    .padding(.vertical, 24)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Street:").font(.system(size: 18, weight: .bold))
                    TextField("", text: $street)
                        .padding(12)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        .padding(.bottom, 8)
                    
                    Text("Unit:").font(.system(size: 18, weight: .bold))
                    TextField("", text: $unit)
                        .padding(12)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        .padding(.bottom, 8)
                    
                    Text("Postal Code:").font(.system(size: 18, weight: .bold))
                    TextField("", text: $postalCode)
                        .padding(12)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: 28)
                
                HStack(spacing: 16) {
                    Button(action: { dismiss() }) {
                        Text("BACK")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color(hex: 0xF44336))
                            .cornerRadius(4)
                    }
                    
                    Button(action: { dismiss() }) {
                        Text("SAVE")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color(hex: 0x1565C0))
                            .cornerRadius(4)
                    }
                }
            }
            .padding(24)
        }
        .navigationTitle("Edit account")
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
