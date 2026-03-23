# Raksha App - Quick Start Guide

## 🚀 Running the App

### From Command Line
```bash
cd d:\raksha\raksha
flutter pub get
flutter run
```

### In VS Code
1. Open the workspace folder: `d:\raksha\raksha`
2. Run > Run Without Debugging (Ctrl+F5)
3. Or use the Flutter extension in VS Code

## 📱 App Navigation Flow

### Starting the App
You'll see the **Mode Selection Screen** with two options:

### Option 1: User Mode (Blue Button)
1. **Enable Location Screen** - Tap "Allow Location Access"
2. **Thank You Screen** - Auto-navigates after 2 seconds
3. **User Dashboard** - Main interface with:
   - 👋 Greeting section
   - 🆘 Emergency SOS button (red)
   - 🚑 Live Ambulance Alert card
   - 🏥 Nearby Hospitals carousel
   - 🚗 Ambulance Services carousel
   - Bottom navigation bar

### Option 2: Ambulance Mode (Red Button)
1. **Ambulance Verification Screen** - Fill in details:
   - Driver Name
   - License Number
   - Ambulance Registration
   - Hospital Name
   - Upload License
   - Upload ID Proof
   - Tap "Verify & Continue"
2. **Ambulance Dashboard** - Control center with:
   - 📍 Current Location display
   - 🔴 Large "TAP TO START" button
   - 📊 Alert status indicator

## 🎨 UI/UX Features

### Color Scheme
- **User Mode**: Blue (#1E88E5) - Safe and trustworthy
- **Ambulance Mode**: Red (#E53935) - Urgent and emergency-focused

### Interactive Elements
- **SOS Button**: Triggers ambulance alert popup
- **TAP TO START**: Initiates emergency broadcast
- **Carousel Cards**: Swipeable hospital and service listings
- **Navigation Bar**: Bottom tab navigation for user dashboard

## 🚨 Alert Popup

When you trigger an SOS or TAP TO START:
- Full-screen red popup appears
- Shows "Ambulance Approaching - 500m Away"
- Displays "Please give way" message
- "OK I WILL MOVE" button to dismiss

## 📁 Project Structure

```
lib/
├── main.dart                    ← App entry point
├── screens/
│   ├── mode_selection_screen.dart
│   ├── ambulance_driver/
│   │   ├── ambulance_verification_screen.dart
│   │   └── ambulance_dashboard_screen.dart
│   └── user/
│       ├── enable_location_screen.dart
│       ├── thank_you_screen.dart
│       └── user_dashboard_screen.dart
├── widgets/
│   └── ambulance_alert_popup.dart
├── models/
│   └── app_models.dart
└── services/
```

## 🔧 Technical Details

- **Framework**: Flutter
- **Language**: Dart
- **UI**: Material Design 3
- **Architecture**: Clean folder structure with screens, widgets, and models

## 💡 Key Features Implemented

✅ Mode selection (User/Ambulance)
✅ User location permission flow
✅ Ambulance driver verification form
✅ User dashboard with emergency features
✅ Ambulance driver dashboard
✅ Alert popup notifications
✅ Responsive UI design
✅ Color-coded themes
✅ Carousel sections for hospitals and services
✅ Bottom navigation bar

## 🎯 Testing Scenarios

### Test User Mode:
1. Select "User Mode" → Allow location → See dashboard
2. Tap SOS button → See alert popup
3. Explore nearby hospitals and services

### Test Ambulance Mode:
1. Select "Ambulance Mode"
2. Fill verification form (any values work)
3. Tap "TAP TO START" → See alert popup
4. Check location display and status indicator

## 📝 Notes

- All data is mock/hardcoded for demonstration
- No real GPS or backend integration yet
- Suitable for UI/UX testing and prototyping
- Ready for backend integration

## 🚀 Next Steps (For Production)

1. Implement Firebase authentication
2. Add real GPS tracking
3. Set up backend services
4. Implement push notifications
5. Add payment gateway
6. Integrate actual hospital APIs
7. Add analytics
8. Implement data persistence

---

**Happy Testing!** 🎉
