//
//  AvatarView.swift
//  Park Patrol
//
//  Created by Daniel Wright & Hector Mojica.
//
//  This view handles user profile management, including personal information,
//  profile image, alert history, and user session management.

import SwiftUI
import CoreData

/// AvatarView provides user profile management functionality and displays user-specific information
struct AvatarView: View {
    // MARK: - Properties
    
    /// Persistent user data stored using UserDefaults
    @AppStorage("firstName") private var firstName: String = "John"
    @AppStorage("lastName") private var lastName: String = "Doe"
    @AppStorage("username") private var username: String = "johndoe"
    @AppStorage("email") private var email: String = "johndoe@example.com"
    
    /// User interface state properties
    @Binding var profileImage: UIImage?  // User's profile picture
    @State private var showingImagePicker = false  // Controls image picker visibility
    @State private var isEditing = false  // Controls edit mode for personal info
    @State private var showingLogoutConfirmation = false  // Controls logout confirmation dialog
    
    /// Core Data properties for managing alert history
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Report.timestamp, ascending: false)],
        animation: .default
    )
    private var reports: FetchedResults<Report>

    // MARK: - View Body
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // MARK: - Profile Section
                Group {
                    // Profile image display and picker
                    if let image = profileImage {
                        // Display selected profile image
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                            .onTapGesture { showingImagePicker = true }
                    } else {
                        // Default profile image placeholder
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue)
                            .onTapGesture { showingImagePicker = true }
                    }

                    // Username display
                    Text(username)
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(.bottom)

                // MARK: - Personal Information Section
                VStack(alignment: .leading, spacing: 12) {
                    // Section header with edit button
                    HStack {
                        Text("Personal Information")
                            .font(.headline)
                        Spacer()
                        // Toggle edit mode button
                        Button(action: {
                            withAnimation { isEditing.toggle() }
                        }) {
                            Image(systemName: isEditing ? "checkmark.circle.fill" : "pencil.circle.fill")
                                .foregroundColor(.blue)
                                .imageScale(.large)
                        }
                    }
                    
                    // Conditional content based on edit mode
                    if isEditing {
                        // Editable form fields
                        Group {
                            TextField("First Name", text: $firstName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Last Name", text: $lastName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Username", text: $username)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                    } else {
                        // Read-only information display
                        Group {
                            Text("First Name: \(firstName)")
                            Text("Last Name: \(lastName)")
                            Text("Email: \(email)")
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

                // MARK: - Alert History Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Your Alert History")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    // Conditional display based on history existence
                    if reports.isEmpty {
                        // Empty state message
                        Text("No alerts sent yet.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else {
                        // List of alert history items
                        ForEach(reports.filter { $0.latitude != 0 && $0.longitude != 0 }, id: \.self) { report in
                            VStack(alignment: .leading, spacing: 8) {
                                // Location name
                                Text(report.location ?? "Unknown Location")
                                    .font(.headline)
                                    .lineLimit(2)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                // Coordinates
                                Text("Coordinates: \(report.latitude), \(report.longitude)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                // Timestamp
                                if let timestamp = report.timestamp {
                                    Text("Date: \(timestamp, style: .date)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                            .padding(.horizontal)
                        }
                    }

                    // Clear history functionality
                    Button(action: clearHistory) {
                        Text("Clear History")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                    
                    Divider()
                        .padding(.vertical)
                    
                    // MARK: - Logout Section
                    Button(action: {
                        showingLogoutConfirmation = true
                    }) {
                        Text("Logout")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .alert("Confirm Logout", isPresented: $showingLogoutConfirmation) {
                        Button("Cancel", role: .cancel) { }
                        Button("Yes, Logout", role: .destructive) {
                            resetUserData()
                        }
                    } message: {
                        Text("Are you sure you want to logout? This will reset all your profile information.")
                    }
                }
            }
            .padding(.vertical)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $profileImage)
        }
    }

    // MARK: - Helper Functions
    
    /// Clears all user alert history from Core Data
    private func clearHistory() {
        for report in reports {
            viewContext.delete(report)
        }
        do {
            try viewContext.save()
        } catch {
            print("Failed to clear history: \(error.localizedDescription)")
        }
    }
    
    /// Resets all user data to default values
    private func resetUserData() {
        // Clear stored values from UserDefaults
        UserDefaults.standard.removeObject(forKey: "firstName")
        UserDefaults.standard.removeObject(forKey: "lastName")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "email")
        
        // Reset properties to default values
        firstName = "John"
        lastName = "Doe"
        username = "johndoe"
        email = "johndoe@example.com"
        profileImage = nil
    }
}

// MARK: - Image Picker
/// UIKit image picker wrapper for SwiftUI compatibility
struct ImagePicker: UIViewControllerRepresentable {
    /// Binding to selected image
    @Binding var image: UIImage?
    /// Environment variable to handle view dismissal
    @Environment(\.presentationMode) private var presentationMode

    /// Creates and configures the UIImagePickerController
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    /// Creates the coordinator to handle the picker's delegate methods
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /// Coordinator class to handle UIImagePickerController delegation
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        /// Handles image selection
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        /// Handles picker cancellation
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
