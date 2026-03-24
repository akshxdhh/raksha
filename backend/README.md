# Raksha Backend - Emergency Ambulance Alert System

A complete Node.js/Express backend for the Raksha emergency ambulance alert system powered by Firebase.

## Features

- 🔐 Firebase Authentication (Email/Password)
- 🚑 Ambulance driver registration and verification
- 📍 Real-time location tracking
- 🆘 Emergency request management
- 👨‍⚖️ Admin dashboard with statistics
- 📱 REST API for Flutter frontend
- 🗄️ Firebase Realtime Database

## Tech Stack

- **Framework**: Express.js
- **Database**: Firebase Realtime Database
- **Authentication**: Firebase Auth
- **Runtime**: Node.js
- **Additional**: CORS, dotenv, JWT

## Installation

### Prerequisites

- Node.js (v14 or higher)
- npm or yarn
- Firebase project with Admin SDK credentials

### Setup Steps

1. **Clone and navigate to backend**
   ```bash
   cd backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Create `.env` file** from `.env.example`
   ```bash
   cp .env.example .env
   ```

4. **Download Firebase Credentials**
   - Go to Firebase Console → Project Settings
   - Download Service Account JSON
   - Copy credentials to `.env` file

5. **Configure `.env` file**
   ```
   FIREBASE_TYPE=service_account
   FIREBASE_PROJECT_ID=your-project-id
   FIREBASE_PRIVATE_KEY_ID=your-key-id
   FIREBASE_PRIVATE_KEY=your-private-key
   FIREBASE_CLIENT_EMAIL=your-email
   FIREBASE_CLIENT_ID=your-client-id
   FIREBASE_AUTH_URI=https://accounts.google.com/o/oauth2/auth
   FIREBASE_TOKEN_URI=https://oauth2.googleapis.com/token
   FIREBASE_DB_URL=https://your-project.firebaseio.com
   PORT=5000
   JWT_SECRET=your-secret-key
   ```

6. **Start the server**
   ```bash
   # Development with auto-reload
   npm run dev
   
   # Production
   npm start
   ```

The backend will start on `http://localhost:5000`

## Firebase Database Structure

```
├── users/
│   ├── {userId}
│   │   ├── uid
│   │   ├── email
│   │   ├── name
│   │   ├── phone
│   │   ├── userType (user, ambulance_driver, admin)
│   │   ├── isVerified
│   │   ├── createdAt
│   │   └── emergencies/
│   │       └── {emergencyId}: true
│
├── ambulances/
│   ├── {userId}
│   │   ├── uid
│   │   ├── driverName
│   │   ├── licenseNumber
│   │   ├── ambulanceRegistration
│   │   ├── ambulanceId
│   │   ├── status (pending, active, inactive)
│   │   ├── isVerified
│   │   ├── isOnline
│   │   ├── currentLocation
│   │   │   ├── latitude
│   │   │   ├── longitude
│   │   │   └── address
│   │   ├── rating
│   │   ├── totalTrips
│   │   └── createdAt
│
├── emergencies/
│   ├── {emergencyId}
│   │   ├── id
│   │   ├── userId
│   │   ├── latitude
│   │   ├── longitude
│   │   ├── address
│   │   ├── emergencyType
│   │   ├── description
│   │   ├── contactPerson
│   │   ├── contactPhone
│   │   ├── status (pending, accepted, completed, cancelled)
│   │   ├── assignedAmbulance
│   │   ├── createdAt
│   │   ├── acceptedAt
│   │   └── completedAt
```

## API Endpoints

### Authentication
- `POST /api/auth/login` - Login with email/password
- `POST /api/auth/verify-token` - Verify JWT token
- `POST /api/auth/logout` - Logout

### Users
- `POST /api/users/register` - Register new user
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update user profile
- `GET /api/users/all` - Get all users (Admin)
- `DELETE /api/users/:userId` - Delete user (Admin)

### Ambulances
- `POST /api/ambulances/register` - Register ambulance
- `GET /api/ambulances/details` - Get ambulance details
- `PUT /api/ambulances/location` - Update location
- `PUT /api/ambulances/status` - Update status
- `GET /api/ambulances/nearby` - Get nearby ambulances

### Emergencies
- `POST /api/emergencies/create` - Create emergency request
- `GET /api/emergencies/:emergencyId` - Get emergency details
- `GET /api/emergencies` - Get user emergencies
- `PUT /api/emergencies/:emergencyId` - Update emergency status
- `GET /api/emergencies/pending/list` - Get pending emergencies (Admin)
- `GET /api/emergencies/all/list` - Get all emergencies (Admin)

### Admin
- `GET /api/admin/ambulances/pending` - Get pending ambulances
- `PUT /api/admin/ambulances/:ambulanceId/verify` - Verify ambulance
- `GET /api/admin/ambulances/all` - Get all ambulances
- `PUT /api/admin/ambulances/:ambulanceId/deactivate` - Deactivate ambulance
- `PUT /api/admin/ambulances/:ambulanceId/activate` - Activate ambulance
- `GET /api/admin/stats` - Get admin statistics

## Health Check

```bash
curl http://localhost:5000/health
```

## Frontend Integration

Update your Flutter app's API base URL in the location service:

```dart
const String apiBaseUrl = 'http://your-backend-url/api';
```

## Security Notes

- ✅ All sensitive endpoints require authentication
- ✅ Firebase Admin SDK handles secure credential management
- ✅ Environment variables protect sensitive data
- ✅ CORS enabled for frontend communication
- ✅ Token validation on protected routes

## Troubleshooting

### Database Connection Error
- Verify Firebase URL in `.env`
- Check Firebase service account permissions
- Ensure Realtime Database is enabled in Firebase Console

### Authentication Issues
- Confirm Firebase credentials are correctly set
- Check JWT_SECRET is configured
- Verify token is sent with Authorization header

### CORS Errors
- CORS is enabled for all origins in `server.js`
- For production, modify CORS settings in `server.js`

## License

ISC

## Support

For issues or questions, please contact the development team.
