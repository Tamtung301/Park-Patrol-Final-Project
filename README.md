
## Park Patrol

**GitHub Repository**: [Park Patrol on GitHub](https://github.com/Tamtung301/Park-Patrol-Final-Project)

# Developers
- **Hector Mojica**
- **Daniel Wright**

### Goals of the Project
Park Patrol is designed to empower university students and staff with a reliable tool to report and stay informed about parking patrol activities on and around the CSUF campus. The app aims to:
- Promote community awareness of parking patrols.
- Reduce parking-related fines by notifying users of patrol locations.
- Create a collaborative environment for sharing real-time information about parking conditions.

### Functionalities
1. **Interactive Map**:
   - Real-time user location tracking.
   - Pin placement for reporting patrol sightings.
   - Reverse geocoding to display human-readable location names.
2. **Alert System**:
   - Send alerts to notify users about reported patrols.
   - Notifications for received alerts.
3. **Profile Management**:
   - User profile setup with personal details and profile images.
   - History of user alerts with detailed timestamps and coordinates.
4. **Settings**:
   - Theme selection (light, dark, system).
   - Manage notification preferences (sound, vibration).
5. **Historical Data**:
   - View a chronological list of past patrol reports.

### Architecture and Design
The app leverages modern technologies and clean architectural principles:
- **Frontend**: Built using SwiftUI for a seamless, interactive user experience.
- **Backend**: Core Data handles data persistence, including storing user-generated alerts.
- **Mapping Functionality**: Integrates MapKit for location services, pin interactions, and geocoding.
- **Navigation**: A SideMenu and NavigationStack ensure intuitive and smooth navigation across views.
- **Modular Design**: Each feature is encapsulated in dedicated views (e.g., `CustomMapView`, `AvatarView`), promoting reusability and scalability.

### Documentation of the Project
#### GitHub Location
All source code and project files are available on GitHub: [Park Patrol Repository](https://github.com/Tamtung301/Park-Patrol-Final-Project)

#### Deployment Instructions
1. Clone the repository to your local machine:
   ```
   git clone https://github.com/Tamtung301/Park-Patrol-Final-Project
   ```
2. Open the project in Xcode:
   ```
   open ParkPatrol.xcodeproj
   ```
3. Ensure you have the latest version of Xcode and Swift installed.

#### Instructions to Run the Application
1. Open the project in Xcode.
2. Set your device simulator or connected iOS device as the target.
3. Build and run the application:
   - In Xcode, click on the **Run** button or use the shortcut `Command + R`.
4. The app will launch, showing the **HomeView** with interactive map functionality.
