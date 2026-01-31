//
//  AddApointmentView.swift
//  Movicare
//
//  Created by Carlos Figuera on 2026-01-30.
//

import SwiftUI
struct AddAppointmentView: View {
@State private var appointmentType: String = ""
@State private var day: String = ""
@State private var time: String = ""
var body: some View {
NavigationStack {
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
Text(day.isEmpty ? "" : day)
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
Text(time.isEmpty ? "" : time)
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
Text("Cancel")
.font(.system(size: 16))
.foregroundColor(.white)
.frame(maxWidth: .infinity)
.frame(height: 50)
.background(Color(hex: 0xD32F2F))
.cornerRadius(6)
Text("Save")
.font(.system(size: 16))
.foregroundColor(.white)
.frame(maxWidth: .infinity)
.frame(height: 50)
.background(Color(hex: 0x1565C0))
.cornerRadius(6)
}
Spacer()
}
.padding(16)
.navigationTitle("Add Appointment")
.navigationBarTitleDisplayMode(.inline)
.toolbar {
ToolbarItem(placement: .navigationBarLeading) {
Image(systemName: "arrow.left")
}
}
}
}
}
#Preview {
AddAppointmentView()
}