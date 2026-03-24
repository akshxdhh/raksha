# Firebase Setup Guide for Raksha Backend

This guide will help you set up Firebase for the Raksha Emergency Ambulance Alert System.

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project"
3. Enter project name: `raksha-ambulance` (or your preferred name)
4. Accept the terms and click "Create project"
5. Wait for project to be created

## Step 2: Set Up Firebase Realtime Database

1. In Firebase Console, go to **Build > Realtime Database**
2. Click **Create Database**
3. Choose your region (closest to your users)
4. Select **Start in test mode** for development
5. Click **Enable**

### Change Security Rules (Important!)

1. Go to **Realtime Database > Rules**
2. Replace the rules with:

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid",
        ".validate": "newData.hasChildren(['uid', 'email', 'name', 'phone'])"
      }
    },
    "ambulances": {
      "$uid": {
        ".read": true,
        ".write": "$uid === auth.uid || root.child('users').child(auth.uid).child('userType').val() === 'admin'",
        ".validate": "newData.hasChildren(['uid', 'driverName', 'licenseNumber'])"
      }
    },
    "emergencies": {
      "$emergencyId": {
        ".read": true,
        ".write": "root.child('users').child(auth.uid).exists()",
        ".validate": "newData.hasChildren(['id', 'userId', 'latitude', 'longitude'])"
      }
    }
  }
}
```

3. Click **Publish**

## Step 3: Set Up Firebase Authentication

1. In Firebase Console, go to **Build > Authentication**
2. Click **Get Started**
3. Enable **Email/Password** sign-in method
4. Click **Enable** and **Save**

## Step 4: Download Service Account Key

1. Go to **Project Settings** (gear icon in top-right)
2. Click **Service Accounts** tab
3. Click **Generate New Private Key**
4. Save the JSON file securely

## Step 5: Configure Backend Environment

1. Open `backend/.env` file
2. Copy values from the downloaded JSON:

```
FIREBASE_TYPE=service_account
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_PRIVATE_KEY_ID=your-private-key-id
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxx@your-project.iam.gserviceaccount.com
FIREBASE_CLIENT_ID=your-client-id
FIREBASE_AUTH_URI=https://accounts.google.com/o/oauth2/auth
FIREBASE_TOKEN_URI=https://oauth2.googleapis.com/token
FIREBASE_AUTH_PROVIDER_CERT_URL=https://www.googleapis.com/oauth2/v1/certs
FIREBASE_CLIENT_CERT_URL=your-cert-url
FIREBASE_DB_URL=https://your-project.firebaseio.com
```

3. Add additional configuration:

```
PORT=5000
NODE_ENV=development
JWT_SECRET=your-super-secret-jwt-key-change-this
```

## Step 6: Set Up Flutter Frontend

### Add HTTP Package

In `pubspec.yaml`, add:

```yaml
dependencies:
  http: ^1.1.0
```

### Update API Service

Copy `API_SERVICE_FLUTTER.dart` to `lib/services/api_service.dart`

Update the BASE_URL:

```dart
// For development (Android emulator)
static const String BASE_URL = 'http://10.0.2.2:5000/api';

// For development (iOS simulator)
// static const String BASE_URL = 'http://localhost:5000/api';

// For production
// static const String BASE_URL = 'https://your-deployed-backend.com/api';
```

### Initialize API Service in main.dart

```dart
import 'services/api_service.dart';

void main() {
  Get.put(ApiService());
  runApp(const MyApp());
}
```

## Step 7: Install Dependencies

```bash
cd backend
npm install
```

## Step 8: Run Backend

```bash
# Development
npm run dev

# Production
npm start
```

Expected output:
```
🚑 Raksha Backend running on port 5000
```

## Step 9: Test Backend

```bash
curl http://localhost:5000/health
```

Expected response:
```json
{
  "status": "OK",
  "message": "Raksha Backend is running"
}
```

## Troubleshooting

### Firebase Connection Error

**Error**: `Cannot read properties of undefined`

**Solution**:
1. Verify Firebase credentials in `.env`
2. Ensure database URL is correct
3. Check Firebase project has Realtime Database enabled

### Authentication Error

**Error**: `Invalid service account`

**Solution**:
1. Re-download service account JSON
2. Verify all fields are correctly set in `.env`
3. Ensure private key escapes newlines with `\n`

### CORS Error in Frontend

**Error**: `Access to XMLHttpRequest blocked by CORS policy`

**Solution**:
1. Backend already has CORS enabled
2. For production, add specific origins:

```javascript
app.use(cors({
  origin: ['https://yourdomain.com'],
  credentials: true,
}));
```

### Port Already in Use

**Error**: `Error: listen EADDRINUSE: address already in use :::5000`

**Solution**:
```bash
# Change port in .env
PORT=5001
```

## Database Structure

The backend automatically creates the following structure:

```
Firebase Realtime Database
├── users/
├── ambulances/
├── emergencies/
```

No manual setup needed - data is created when users register.

## Security Checklist

- ✅ Service account key is secured in `.env`
- ✅ `.env` file is in `.gitignore`
- ✅ Database rules restrict unauthorized access
- ✅ JWT_SECRET is configured
- ✅ Authentication middleware on protected routes
- ✅ CORS configured for your domain

## Next Steps

1. Deploy backend to a hosting service (Heroku, Railway, AWS, etc.)
2. Update frontend API_SERVICE BASE_URL to production backend
3. Set `NODE_ENV=production` in production `.env`
4. Enable stricter Firebase security rules
5. Set up monitoring and logging

## Useful Firebase Console URLs

- [Firebase Console](https://console.firebase.google.com)
- Realtime Database: `Build > Realtime Database`
- Authentication: `Build > Authentication`
- Project Settings: Gear icon > Project Settings
- Service Accounts: Project Settings > Service Accounts

## Support

For issues or questions:
- Check Firebase Documentation: https://firebase.google.com/docs
- Node.js Documentation: https://nodejs.org/docs
- Express Documentation: https://expressjs.com
