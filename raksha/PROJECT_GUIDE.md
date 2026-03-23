# Raksha - Emergency Ambulance Alert System


A Flutter-based emergency ambulance alert system that provides real-time emergency services to users and ambulance drivers.

## Features

### User Mode
- **Location-based Emergency Service**: Users can enable location access to receive emergency ambulance services
- **SOS Button**: One-tap emergency alert to request immediate ambulance assistance
- **Live Ambulance Tracking**: Real-time notification when an ambulance is approaching
- **Nearby Hospitals**: Browse nearby hospitals with distance information
- **Ambulance Services**: View available ambulance services in your area
- **Responsive Dashboard**: Clean, modern UI with essential emergency information

### Ambulance Driver Mode
- **Driver Verification**: Complete verification process with driver credentials
- **Real-time Location Broadcasting**: Share ambulance location with users
- **Emergency Alert Broadcasting**: Tap to start broadcasting emergency location to nearby users
- **Current Location Display**: Always display current ambulance location
- **Alert Status Indicator**: Visual indication of alert broadcasting status

### Additional Features
- **Material Design 3**: Modern UI components and design patterns
- **Clean Architecture**: Organized folder structure for scalability
- **Responsive Layout**: Works seamlessly on various device sizes
- **Color-coded Modes**: Blue theme for User Mode, Red theme for Ambulance Mode
- **Smooth Navigation**: Intuitive flow between screens

## Project Structure

```
lib/
├── main.dart                           # App entry point and configuration
├── screens/
│   ├── mode_selection_screen.dart     # Initial mode selection (User/Ambulance)
│   ├── ambulance_driver/
│   │   ├── ambulance_verification_screen.dart  # Driver verification form
│   │   └── ambulance_dashboard_screen.dart     # Ambulance control dashboard
│   └── user/
│       ├── enable_location_screen.dart         # Location permission screen
│       ├── thank_you_screen.dart               # Post-registration confirmation
│       └── user_dashboard_screen.dart          # Main user interface
├── widgets/
│   └── ambulance_alert_popup.dart     # Emergency alert popup dialog
├── models/
│   └── app_models.dart                # Data models and constants
└── services/
    └── (placeholder for future API services)
```

## App Flow

### User Mode Flow
1. **Mode Selection** → Choose "User Mode"
2. **Enable Location** → Grant location permissions
3. **Thank You** → Confirmation screen (auto-navigates to dashboard)
4. **User Dashboard** → Access emergency features
   - SOS button for immediate help
   - Live ambulance tracking
   - Nearby hospitals directory
   - Available ambulance services

### Ambulance Driver Flow
1. **Mode Selection** → Choose "Ambulance Mode"
2. **Verification** → Complete driver verification form
3. **Ambulance Dashboard** → Manage emergency broadcasts
   - Current location display
   - Large TAP TO START button for alerts
   - Alert status monitoring
   - Location broadcasting

## UI/UX Highlights

### Color Scheme
- **User Mode**: Blue (#1E88E5) - Safe, trusted, welcoming
- **Ambulance Mode**: Red (#E53935) - Urgent, attention-grabbing, emergency-focused

### Key Screens

#### Mode Selection Screen
- Two prominent buttons for mode selection
- App branding and tagline
- Language selection option

#### Ambulance Verification Screen
- Driver name, license, and ambulance details
- Document upload sections
- Verify & Continue action button

#### User Dashboard
- Greeting with user's name
- Emergency SOS button (red gradient)
- Live ambulance alert card
- Horizontal scrollable hospital cards
- Horizontal scrollable service cards
- Bottom navigation bar

#### Ambulance Dashboard
- Current location card
- Large circular TAP TO START button
- Alert status indicator
- Simple, driver-focused interface

#### Alert Popup
- Full-screen red background
- Ambulance icon
- Distance information
- Clear call-to-action button

## Technical Stack

- **Framework**: Flutter (Latest Stable)
- **Language**: Dart
- **UI Library**: Material Design 3
- **State Management**: StatefulWidget
- **Navigation**: MaterialPageRoute

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK (included with Flutter)
- Android Studio / Xcode for testing

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd raksha
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Available Commands

```bash
# Get dependencies
flutter pub get

# Clean build
flutter clean

# Build APK
flutter build apk

# Build for iOS
flutter build ios

# Run with specific device
flutter run -d <device-id>
```

## Future Enhancements

- Real-time GPS tracking integration
- Firebase backend for user/ambulance management
- Push notifications for emergency alerts
- Chat/Call functionality between users and ambulance drivers
- Multiple language support
- Dark mode support
- Payment integration for premium services
- Analytics and reporting dashboard

## File Descriptions

### main.dart
- App initialization and root widget configuration
- Material theme setup with color schemes

### Mode Selection Screen
- Entry point for app
- User chooses between User Mode and Ambulance Mode

### Ambulance Verification Screen
- Form-based verification for ambulance drivers
- Collects driver and ambulance details
- Upload fields for license and ID proof

### Ambulance Dashboard Screen
- Displays current ambulance location
- Large TAP TO START button for emergency broadcasting
- Real-time status indicator

### Enable Location Screen
- Requests location permissions from user
- Displays map preview
- Location access reasoning

### Thank You Screen
- Confirmation after location setup
- Auto-navigates to User Dashboard after 2 seconds

### User Dashboard Screen
- Main interface for regular users
- SOS emergency button
- Live ambulance alert section
- Nearby hospitals carousel
- Ambulance services carousel
- Bottom navigation bar

### Ambulance Alert Popup
- Full-screen dialog shown when ambulance is nearby
- Displays distance and call-to-action
- Non-dismissible until acknowledged

## Customization

### Changing Colors
Update the color constants in:
- `main.dart` - Theme configuration
- `mode_selection_screen.dart` - Mode button colors
- Individual screen files - Component colors

### Modifying Text
All static text can be updated in:
- Individual screen files
- `models/app_models.dart` - Centralized constants

## Notes

- This is a mock UI implementation without backend integration
- Current implementation uses mock data for hospitals and services
- Real location services require proper permissions and configuration
- Firebase or similar backend would be needed for production

## License

This project is provided as-is for educational and demonstration purposes.
