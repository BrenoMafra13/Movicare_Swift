//
//  AppointmentsView.swift
//  Movicare
//
//  Created by Carlos Figuera on 2026-01-30.
//

import SwiftUI
struct AppointmentsView: View {
var body: some View {
NavigationStack {
VStack {
VStack {
Spacer()
Text("No appointments yet.")
.foregroundColor(.gray)
.font(.system(size: 16))
Spacer()
}
.frame(maxWidth: .infinity, maxHeight: .infinity)
Spacer()
.frame(height: 24)
Text("Add Appointment")
.font(.system(size: 18))
.foregroundColor(.white)
.frame(maxWidth: .infinity)
.frame(height: 55)
.background(Color(hex: 0x3949AB))
.cornerRadius(4)
}
.padding(16)
.navigationTitle("Appointments")
.navigationBarTitleDisplayMode(.inline)
.toolbar {
ToolbarItem(placement: .navigationBarLeading) {
Image(systemName: "arrow.left")
}
}
}
}
}
struct AppointmentCard: View {
var type: String
var day: String
var time: String
var body: some View {
HStack(spacing: 12) {
Image("appointment")
.resizable()
.frame(width: 50, height: 50)
VStack(alignment: .leading) {
Text(type)
.font(.system(size: 18, weight: .bold))
Text("\(day) at \(time)")
.font(.system(size: 16))
.foregroundColor(.gray)
}
Spacer()
Text("Remove")
.font(.system(size: 16))
.foregroundColor(.white)
.padding(.horizontal, 12)
.frame(height: 40)
.background(Color(hex: 0xD32F2F))
.cornerRadius(4)
}
.padding(12)
.background(Color.white)
.cornerRadius(6)
.shadow(radius: 1, y: 1)
}
}
#Preview {
AppointmentsView()
}