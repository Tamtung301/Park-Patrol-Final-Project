//
//  AppEntry.swift
//  Park Patrol
//
//  Created by Daniel Wright & Hector Mojica.
//
//  This is the main entry point for the Park Patrol application.
//  It initializes Core Data persistence and sets up the root view.

import SwiftUI

/// Main application structure that serves as the entry point
/// The @main attribute identifies this as the app's launch point
@main
struct ParkPatrolApp: App {
    // MARK: - Properties
    
    /// Shared persistence controller for CoreData
    /// This manages the app's data layer and provides access to the Core Data stack
    let persistenceController = PersistenceController.shared

    // MARK: - Scene Configuration
    var body: some Scene {
        // Define the main window group for the app
        WindowGroup {
            // Set HomeView as the root view of the application
            HomeView()
                // Inject the Core Data managed object context into the environment
                // This makes Core Data available throughout the app's view hierarchy
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
