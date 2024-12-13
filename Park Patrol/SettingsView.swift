//
//  SettingsView.swift
//  Park Patrol
//
//  Created by Daniel Wright & Hector Mojica.
//
//  This view handles user preferences and app configuration options,
//  including theme selection and notification settings.

import SwiftUI

/// A view that manages application settings and user preferences
struct SettingsView: View {
    // MARK: - State Properties
    /// Current theme selection (light, dark, or system)
    @State private var theme: Theme = .system
    /// Controls whether notifications are enabled
    @State private var notificationsEnabled = true
    /// Controls notification sound settings
    @State private var soundEnabled = true
    /// Controls device vibration for notifications
    @State private var vibrationEnabled = true

    // MARK: - View Body
    var body: some View {
        VStack {
            // View title
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Form {
                // MARK: - Appearance Section
                Section(header: Text("Appearance")) {
                    // Theme picker with live updates
                    Picker("Theme", selection: Binding(
                        get: { theme },
                        set: { newTheme in
                            theme = newTheme
                            applyTheme(newTheme)
                        }
                    )) {
                        Text("Light").tag(Theme.light)
                        Text("Dark").tag(Theme.dark)
                        Text("System Default").tag(Theme.system)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                // MARK: - Notifications Section
                Section(header: Text("Notifications")) {
                    // Main notification toggle
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    // Additional notification settings
                    Toggle("Sound", isOn: $soundEnabled)
                    Toggle("Vibration", isOn: $vibrationEnabled)
                }
            }
        }
    }

    // MARK: - Helper Functions
    /// Applies the selected theme to the entire application
    /// - Parameter theme: The theme to be applied (light, dark, or system)
    private func applyTheme(_ theme: Theme) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            switch theme {
            case .light:
                keyWindow.overrideUserInterfaceStyle = .light
            case .dark:
                keyWindow.overrideUserInterfaceStyle = .dark
            case .system:
                keyWindow.overrideUserInterfaceStyle = .unspecified
            }
        }
    }
}

// MARK: - Theme Enum
/// Defines the available theme options for the app
enum Theme: String, CaseIterable, Identifiable {
    /// Light theme mode
    case light
    /// Dark theme mode
    case dark
    /// System default theme
    case system

    /// Unique identifier for each theme option
    var id: String { rawValue }
}
