//
//  SideMenu.swift
//  Park Patrol
//
//  Created by Daniel Wright & Hector Mojica.
//
//  This file implements a sliding side menu for navigation between
//  different sections of the app.

import SwiftUI

// MARK: - Menu Options
/// Defines the available navigation destinations in the side menu
enum MenuOption: String, CaseIterable, Identifiable {
    /// Main home screen with map
    case home = "Home"
    /// App settings and preferences
    case settings = "Settings"
    /// App information and features
    case about = "About"

    /// Unique identifier for each menu option
    var id: String { rawValue }
}

/// A sliding menu view providing navigation options
struct SideMenu: View {
    // MARK: - Properties
    /// Controls the visibility of the menu
    @Binding var isShowing: Bool
    /// Currently selected navigation option
    @Binding var selectedOption: MenuOption?
    /// Environment variable for view dismissal
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme

    // MARK: - View Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Navigation buttons for each menu option
            ForEach(MenuOption.allCases) { option in
                Button(action: {
                    withAnimation {
                        selectedOption = option
                        isShowing = false
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text(option.rawValue)
                        .font(.headline)
                        .foregroundColor(Color.primary)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                }
            }

            Spacer()
        }
        // Menu styling and animation
        .padding()
        .frame(width: 250)
        .background(
            colorScheme == .dark ? Color.black : Color.white
        )
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 2, y: 0)
        .transition(.move(edge: .leading).combined(with: .opacity))
    }
}
