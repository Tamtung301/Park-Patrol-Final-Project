//
//  HomeView.swift
//  Park Patrol
//
//  Created by Daniel Wright & Hector Mojica.
//
//  This is the main view of the Park Patrol app, containing the map interface,
//  navigation controls, and alert functionality.

import SwiftUI
import MapKit

/// Main view of the app showing the map and user interface
struct HomeView: View {
    // MARK: - State Properties
    /// Controls the visibility of the side menu
    @State private var isMenuVisible = false
    /// Currently selected menu option
    @State private var selectedOption: MenuOption? = nil
    /// Current map region centered on CSUF East Parking
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.8818, longitude: -117.8855),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    /// Selected pin location on the map
    @State private var pin: CLLocationCoordinate2D? = nil
    /// Shows confirmation when alert is sent
    @State private var isAlertSent = false
    /// Name of nearest location to selected pin
    @State private var nearestLocation = ""
    /// String representation of selected coordinates
    @State private var coordinatesText = ""
    /// User's profile image
    @State private var profileImage: UIImage?

    // MARK: - Environment
    /// Core Data managed object context
    @Environment(\.managedObjectContext) private var viewContext

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Main Content
                VStack {
                    // Custom map view with location display
                    CustomMapView(region: $region, pin: $pin, nearestLocation: $nearestLocation, coordinatesText: $coordinatesText)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .padding()

                    // Location information display
                    VStack {
                        Text("Location: \(nearestLocation)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Coordinates: \(coordinatesText)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom)

                    // Alert button
                    Button(action: {
                        if let pin = pin {
                            sendAlert(location: nearestLocation, coordinate: pin)
                            isAlertSent = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isAlertSent = false
                            }
                        }
                    }) {
                        Text("Send Alert")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(pin == nil ? Color.gray : Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(pin == nil)
                    .padding(.horizontal)

                    Spacer()
                }
                .blur(radius: isMenuVisible ? 10 : 0)

                // MARK: - Side Menu
                if isMenuVisible {
                    // Semi-transparent background overlay
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isMenuVisible = false
                            }
                        }
                        .transition(.opacity)

                    // Side menu content
                    HStack {
                        SideMenu(isShowing: $isMenuVisible, selectedOption: $selectedOption)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 0)
                            .transition(.move(edge: .leading))
                            .zIndex(1)

                        Spacer()
                    }
                }

                // MARK: - Navigation Links
                NavigationLink(destination: SettingsView(), tag: .settings, selection: $selectedOption) {
                                    SettingsView()
                                }
                                .hidden()
                                NavigationLink(destination: AboutView(), tag: .about, selection: $selectedOption) {
                                    AboutView()
                                }
                                .hidden()

                // MARK: - Alert Confirmation
                if isAlertSent {
                    VStack {
                        Spacer()
                        Text("Alert Sent Successfully!")
                            .font(.headline)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                            .padding(.bottom, 80)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut, value: isAlertSent)
                    .zIndex(2)
                }
            }
            // MARK: - Navigation Bar
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation {
                            isMenuVisible.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AvatarView(profileImage: $profileImage)) {
                        if let image = profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .imageScale(.large)
                        }
                    }
                }
            }
            .navigationTitle("Home")
        }
    }

    // MARK: - Helper Functions
    /// Creates and saves a new patrol report to Core Data
    /// - Parameters:
    ///   - location: Name of the location
    ///   - coordinate: Geographic coordinates of the report
    private func sendAlert(location: String, coordinate: CLLocationCoordinate2D) {
        let newReport = Report(context: viewContext)
        newReport.timestamp = Date()
        newReport.latitude = coordinate.latitude
        newReport.longitude = coordinate.longitude
        newReport.location = location

        do {
            try viewContext.save()
        } catch {
            print("Failed to send alert: \(error)")
        }
    }
}
