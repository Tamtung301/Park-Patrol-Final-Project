//
//  ContentView.swift
//  Park Patrol
//
//  Created by Daniel Wright & Hector Mojica.
//
//  This view displays a list of all reported parking patrol locations
//  with their coordinates and timestamps. It serves as a historical
//  view of all reports made through the app.

import SwiftUI

/// ContentView provides a chronological list of all patrol reports
/// sorted by timestamp in descending order (most recent first)
struct ContentView: View {
    // MARK: - Properties

    /// Core Data fetch request to retrieve all reports
    /// - Fetches from Report entity
    /// - Sorts by timestamp in descending order
    /// - Includes animation for smooth updates
    @FetchRequest(
        entity: Report.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Report.timestamp, ascending: false)],
        animation: .default
    ) var reports: FetchedResults<Report>

    // MARK: - View Body
    var body: some View {
        // Navigation wrapper for list hierarchy
        NavigationView {
            // Dynamic list of reports
            List(reports) { report in
                // Individual report item layout
                VStack(alignment: .leading) {
                    // Location coordinates display
                    Text("Location: \(report.latitude), \(report.longitude)")
                        .font(.headline)

                    // Timestamp display with formatted date
                    Text("Timestamp: \(report.timestamp ?? Date(), formatter: DateFormatter.shortDate)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Reports")  // List title in navigation bar
        }
    }
}

// MARK: - DateFormatter Extension
extension DateFormatter {
    /// Shared date formatter for consistent date/time display
    /// Configured for short date and time format
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short  // Short date format (e.g., 12/5/24)
        formatter.timeStyle = .short  // Short time format (e.g., 3:30 PM)
        return formatter
    }
}
