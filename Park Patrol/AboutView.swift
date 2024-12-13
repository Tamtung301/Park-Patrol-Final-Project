//
//  AboutView.swift
//  Park Patrol
//
//  Created by Daniel Wright & Hector Mojica.
//
//  This view provides information about the Park Patrol app to users,
//  explaining its purpose, features, and basic usage instructions.

import SwiftUI

/// AboutView serves as an informational screen that introduces users to the app's functionality
/// and core features. It includes a description, feature list, and navigation controls.
struct AboutView: View {
    // MARK: - Properties

    /// Environment variable that enables programmatic view dismissal
    /// Used when returning to the previous screen via the "Get Started" button
    @Environment(\.dismiss) private var dismiss

    // MARK: - View Body
    var body: some View {
        // Enables scrolling for content overflow
        ScrollView {
            // Main content container with consistent spacing
            VStack(alignment: .leading, spacing: 20) {
                // MARK: - Header Section
                // App title with themed icon for visual appeal
                HStack {
                    // Car icon represents the parking-related functionality
                    Image(systemName: "car.2.fill")
                        .font(.largeTitle)
                        .foregroundColor(.blue)

                    // App name in prominent display
                    Text("About Park Patrol")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                .padding(.bottom, 10)

                // MARK: - Description Section
                // Detailed explanation of the app's purpose and basic usage
                Text("Park Patrol is your go-to app for reporting and staying informed about parking issues on and around CSUF's campus. Use our app to be aware of parking patrollers, and park smart, saving yourself from tickets and fines. \n\nTap anywhere on the map to select a location, and then share your findings with the community!")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 20)

                // MARK: - Features List
                // Visual presentation of key features with icons and descriptions
                VStack(alignment: .leading, spacing: 10) {
                    // Report Patrollers: First main feature
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.blue)
                        Text("Report Patrollers: Easily notify others about parking patrol.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    // Stay Alert: Second main feature
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.blue)
                        Text("Stay Alert: Get notifications about patrols or reported issues.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    // Find Safer Spots: Third main feature
                    HStack {
                        Image(systemName: "map.fill")
                            .foregroundColor(.blue)
                        Text("Find Safer Spots: Access a map of reported concerns and avoid trouble.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical)

                // Flexible spacing to push button to bottom
                Spacer()

                // MARK: - Navigation
                // Call-to-action button that returns user to main interface
                Button(action: {
                    // Dismisses the about view and returns to previous screen
                    dismiss()
                }) {
                    // Styled button with consistent app theming
                    Text("Get Started!")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
            }
            // Overall content padding
            .padding()
        }
    }
}
