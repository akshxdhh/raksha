# Raksha Backend - Quick Start Guide

Get your Raksha backend up and running in 5 minutes!

## Prerequisites

- Node.js 14+ installed
- npm installed  
- Firebase account (free)
- Text editor (VS Code recommended)

## 🚀 Quick Setup (5 minutes)

### 1. Firebase Setup (2 minutes)

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project → name it `raksha`
3. Go to **Build > Realtime Database** → Create Database
4. Go to **Build > Authentication** → Enable Email/Password
5. Go to **Project Settings > Service Accounts** → Generate Key
6. Copy the JSON key (you'll need this)

**Detailed setup**: See [FIREBASE_SETUP.md](./FIREBASE_SETUP.md)

### 2. Backend Setup (2 minutes)

```bash
# Navigate to backend folder
cd backend

# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Edit .env with your Firebase credentials
# (Open .env and paste values from the JSON key you downloaded)
```

### 3. Start Server (1 minute)

```bash
# Development mode (auto-restart on file changes)
npm run dev

# Or production mode
npm start
```

You should see:
```
🚑 Raksha Backend running on port 5000
```

## ✅ Test Backend

```bash
# Test health endpoint
curl http://localhost:5000/health

# Expected response:
# {"status":"OK","message":"Raksha Backend is running"}
```

## 🎯 Next Steps

### Update Flutter Frontend

1. Open `lib/services/api_service.dart`
2. Update BASE_URL:
   ```dart
   // For Android emulator
   static const String BASE_URL = 'http://10.0.2.2:5000/api';
   
   // For iOS simulator
   // static const String BASE_URL = 'http://localhost:5000/api';
   ```

3. In `lib/main.dart`, initialize API service:
   ```dart
   import 'services/api_service.dart';
   
   void main() {
     Get.put(ApiService());
     runApp(const MyApp());
   }
   ```

4. Run Flutter:
   ```bash
   flutter pub get
   flutter run
   ```

## 📚 API Endpoints

### Authentication
- `POST /api/auth/login` - Login
- `POST /api/auth/verify-token` - Verify token

### Users
- `POST /api/users/register` - Register user
- `GET /api/users/profile` - Get profile
- `PUT /api/users/profile` - Update profile

### Ambulances
- `POST /api/ambulances/register` - Register ambulance
- `GET /api/ambulances/nearby` - Get nearby ambulances
- `PUT /api/ambulances/location` - Update location
- `PUT /api/ambulances/status` - Update online/offline status

### Emergencies
- `POST /api/emergencies/create` - Create emergency request
- `GET /api/emergencies` - Get your emergencies
- `PUT /api/emergencies/:id` - Update emergency status

### Admin
- `GET /api/admin/ambulances/pending` - Get pending ambulances
- `PUT /api/admin/ambulances/:id/verify` - Verify ambulance
- `GET /api/admin/stats` - Get statistics

**Full API docs**: See [API Endpoints](#api-reference)

## 🔧 Common Issues

### "Cannot find module 'firebase-admin'"
```bash
npm install
```

### "Firebase connection failed"
1. Check `.env` file is properly formatted
2. Verify Firebase credentials are correct
3. Ensure Realtime Database is enabled in Firebase Console

### "Port 5000 already in use"
```bash
# Use different port
PORT=5001 npm run dev

# Or kill process on port 5000
# Windows: netstat -ano | findstr :5000
# Mac/Linux: lsof -i :5000
```

### "CORS error in Flutter"
- CORS is already enabled in `server.js`
- For production, update allowed origins in `server.js`

## 📦 Project Structure

```
backend/
├── config/
│   └── firebase.js              # Firebase initialization
├── middleware/
│   └── auth.js                  # Authentication middleware
├── controllers/
│   ├── userController.js        # User operations
│   ├── ambulanceController.js   # Ambulance operations
│   ├── emergencyController.js   # Emergency operations
│   └── adminController.js       # Admin operations
├── routes/
│   ├── auth.js                  # Auth routes
│   ├── users.js                 # User routes
│   ├── ambulances.js            # Ambulance routes
│   ├── emergencies.js           # Emergency routes
│   └── admin.js                 # Admin routes
├── server.js                    # Main server file
├── package.json                 # Dependencies
├── .env.example                 # Environment template
└── README.md                    # Full documentation
```

## 🗄️ Database Structure

Automatically created in Firebase Realtime Database:

```
├── users/
│   └── {userId}
│       ├── email, name, phone
│       ├── userType: "user" | "ambulance_driver" | "admin"
│       └── emergencies/
│
├── ambulances/
│   └── {userId}
│       ├── driverName, licenseNumber, ambulanceId
│       ├── status: "pending" | "active" | "inactive"
│       ├── isVerified, isOnline
│       └── currentLocation { latitude, longitude }
│
└── emergencies/
    └── {emergencyId}
        ├── userId, latitude, longitude, address
        ├── status: "pending" | "accepted" | "completed"
        └── contactPhone
```

## 🚢 Deploy to Production

For production deployment options:

1. **Railway** (Recommended - easiest)
2. **Heroku** (Popular)
3. **AWS** (Scalable)
4. **Google Cloud Run** (Serverless)

See [DEPLOYMENT.md](./DEPLOYMENT.md) for detailed instructions

## 🆘 Getting Help

### Documentation
- [Firebase Setup Guide](./FIREBASE_SETUP.md) - Detailed Firebase instructions
- [Full README](./README.md) - Complete API reference
- [Deployment Guide](./DEPLOYMENT.md) - Production deployment

### Troubleshooting Checklist
- [ ] Node.js installed? `node --version`
- [ ] Dependencies installed? `npm list`
- [ ] Firebase credentials in `.env`?
- [ ] Realtime Database enabled in Firebase?
- [ ] Authentication enabled in Firebase?
- [ ] Backend running? Check port 5000

### Debug Mode

Enable verbose logging:

```javascript
// In server.js, add:
if (process.env.NODE_ENV === 'development') {
  app.use((req, res, next) => {
    console.log(`${req.method} ${req.path}`);
    next();
  });
}
```

## 📱 Flutter Integration

### 1. Add HTTP Package

In `pubspec.yaml`:
```yaml
dependencies:
  http: ^1.1.0
```

### 2. Add API Service

Copy `lib/services/api_service.dart` (already included in frontend)

### 3. Initialize Service

In `lib/main.dart`:
```dart
import 'services/api_service.dart';

void main() {
  Get.put(ApiService());  // Initialize API service
  runApp(const MyApp());
}
```

### 4. Use in Screens

```dart
final apiService = Get.find<ApiService>();

// Register user
final result = await apiService.registerUser(
  email: 'user@example.com',
  password: 'password',
  name: 'John Doe',
  phone: '+1234567890',
);

// Get nearby ambulances
final nearby = await apiService.getNearbyAmbulances(
  latitude: 40.7128,
  longitude: -74.0060,
  radiusKm: 5,
);

// Create emergency
final emergency = await apiService.createEmergency(
  latitude: 40.7128,
  longitude: -74.0060,
  address: '123 Main St',
  contactPhone: '+1234567890',
);
```

## 🔐 Security Checklist

- ✅ All sensitive data in `.env`
- ✅ `.env` is in `.gitignore`
- ✅ Firebase credentials secured
- ✅ Authentication on protected routes
- ✅ CORS configured
- ✅ Database rules updated

## 📊 Monitoring

View logs while running:
```bash
npm run dev
```

Check database in Firebase Console:
- **Build > Realtime Database > Data** tab

## 🎓 Learning Resources

- [Express.js Documentation](https://expressjs.com/)
- [Firebase Admin SDK](https://firebase.google.com/docs/database)
- [Node.js Best Practices](https://github.com/goldbergyoni/nodebestpractices)
- [REST API Design](https://restfulapi.net/)

## 💡 Tips

1. **Use Postman** to test APIs: [Postman](https://www.postman.com/)
2. **Enable request logging**: `npm install morgan`
3. **Add error tracking**: `npm install @sentry/node`
4. **Monitor performance**: Use Firebase Console stats

---

**You're all set!** 🎉 Your Raksha backend is ready. Next, deploy it and connect your Flutter frontend!

For detailed information, see:
- Full documentation: [README.md](./README.md)
- Firebase setup: [FIREBASE_SETUP.md](./FIREBASE_SETUP.md)
- Deployment: [DEPLOYMENT.md](./DEPLOYMENT.md)
