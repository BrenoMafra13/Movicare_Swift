//
//  FamilyMemberView.swift
//  Movicare
//
//  Created by Carlos Figuera on 2026-01-30.
//

import SwiftUI
struct FamilyMembersView: View {
@State private var showAddDialog = false
@State private var familyMembers: [String] = []
var body: some View {
NavigationStack {
ZStack {
VStack {
if familyMembers.isEmpty {
Spacer()
Text("No family members added yet.")
.foregroundColor(.gray)
Spacer()
} else {
ScrollView {
VStack(spacing: 8) {
FamilyMemberListItem(name: "John Doe", relation: "Son", phone: "123-456-7890")
}
.padding(16)
}
}
}
VStack {
Spacer()
HStack {
Spacer()
Image(systemName: "plus")
.font(.title.bold())
.foregroundColor(.white)
.frame(width: 56, height: 56)
.background(Color.accentColor)
.clipShape(Circle())
.shadow(radius: 4)
.padding(16)
}
}
}
.navigationTitle("Manage Family")
.navigationBarTitleDisplayMode(.inline)
.toolbar {
ToolbarItem(placement: .navigationBarLeading) {
Image(systemName: "arrow.left")
}
}
.overlay {
if showAddDialog {
AddFamilyMemberDialog()
}
}
}
}
}
struct FamilyMemberListItem: View {
var name: String
var relation: String
var phone: String
var body: some View {
HStack {
VStack(alignment: .leading) {
Text(name)
.font(.system(size: 18, weight: .bold))
Text("\(relation) • \(phone)")
.font(.system(size: 14))
.foregroundColor(.gray)
}
Spacer()
Image(systemName: "trash")
.foregroundColor(.red)
}
.padding(16)
.background(Color.white)
.cornerRadius(8)
.shadow(radius: 1, y: 1)
}
}
struct AddFamilyMemberDialog: View {
@State private var name = ""
@State private var relation = ""
@State private var phone = ""
var body: some View {
ZStack {
Color.black.opacity(0.4).ignoresSafeArea()
VStack(alignment: .leading, spacing: 16) {
Text("Add Family Member")
.font(.headline)
VStack(spacing: 8) {
TextField("Name", text: $name)
.padding(10)
.overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.5)))
TextField("Relationship", text: $relation)
.padding(10)
.overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.5)))
TextField("Phone Number", text: $phone)
.padding(10)
.overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.5)))
}
HStack {
Spacer()
Text("Cancel")
.foregroundColor(.blue)
.padding(.trailing, 16)
Text("Add & Invite")
.fontWeight(.bold)
.foregroundColor(.blue)
}
}
.padding(20)
.background(Color.white)
.cornerRadius(12)
.padding(40)
}
}
}
#Preview {
FamilyMembersView()
}