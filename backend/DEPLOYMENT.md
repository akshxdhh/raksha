# Raksha Backend Deployment Guide

Guide to deploy the Raksha backend to production environments.

## Deployment Platforms

### Option 1: Railway (Recommended for beginners)

**Pros**: Simple, automatic deploys, free tier available

1. Go to [railway.app](https://railway.app)
2. Sign up with GitHub
3. Create new project
4. Select "Deploy from GitHub repo"
5. Connect your GitHub repository
6. Add environment variables from `.env`
7. Deploy automatically

### Option 2: Heroku (Requires credit card)

**Pros**: Easy setup, good documentation

1. Create account at [heroku.com](https://heroku.com)
2. Install Heroku CLI
3. Add Procfile to backend folder:
   ```
   web: node server.js
   ```
4. Deploy:
   ```bash
   heroku login
   heroku create raksha-ambulance
   git push heroku main
   heroku config:set KEY=VALUE
   ```

### Option 3: AWS Elastic Beanstalk

**Pros**: Scalable, enterprise-grade

1. Install AWS CLI
2. Create Elastic Beanstalk environment
3. Deploy:
   ```bash
   eb create raksha-ambulance
   eb deploy
   ```

### Option 4: Google Cloud Run

**Pros**: Serverless, pay-per-use, free tier

1. Install Google Cloud CLI
2. Create Dockerfile:
   ```dockerfile
   FROM node:18
   WORKDIR /app
   COPY package*.json ./
   RUN npm install
   COPY . .
   EXPOSE 5000
   CMD ["npm", "start"]
   ```
3. Deploy:
   ```bash
   gcloud run deploy raksha-ambulance --source .
   ```

## Pre-deployment Checklist

- [ ] `.env` configured with all required variables
- [ ] `.gitignore` includes `.env`
- [ ] `package.json` has all dependencies
- [ ] Tested locally with `npm run dev`
- [ ] Firebase credentials are correct
- [ ] Database security rules are updated
- [ ] JWT_SECRET is changed from default
- [ ] Node version specified in `package.json` or `.nvmrc`

## Environment Variables for Production

```
NODE_ENV=production
PORT=5000

# Firebase Config
FIREBASE_TYPE=service_account
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_PRIVATE_KEY_ID=your-key-id
FIREBASE_PRIVATE_KEY=-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n
FIREBASE_CLIENT_EMAIL=your-email
FIREBASE_CLIENT_ID=your-client-id
FIREBASE_DB_URL=https://your-project.firebaseio.com

# Security
JWT_SECRET=your-strong-random-secret-key-here

# CORS (specify your frontend domain)
CORS_ORIGIN=https://yourdomain.com
```

## After Deployment

1. Update Flutter app's API_SERVICE BASE_URL:
   ```dart
   static const String BASE_URL = 'https://your-backend-url.com/api';
   ```

2. Test health endpoint:
   ```bash
   curl https://your-backend-url.com/health
   ```

3. Monitor logs:
   - Railway: Web dashboard
   - Heroku: `heroku logs --tail`
   - AWS: CloudWatch
   - GCP: Cloud Logging

4. Set up error tracking:
   - Sentry
   - LogRocket
   - DataDog

## Production Security

### Update Firebase Rules

Replace test mode rules with production rules:

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid || root.child('users').child(auth.uid).child('userType').val() === 'admin'",
        ".write": "$uid === auth.uid",
        ".validate": "newData.hasChildren(['uid', 'email', 'name'])"
      }
    },
    "ambulances": {
      "$uid": {
        ".read": true,
        ".write": "$uid === auth.uid || root.child('users').child(auth.uid).child('userType').val() === 'admin'",
        ".validate": "newData.hasChildren(['uid', 'driverName'])"
      }
    },
    "emergencies": {
      "$emergencyId": {
        ".read": "auth != null",
        ".write": "auth != null && (root.child('emergencies').child($emergencyId).child('userId').val() === auth.uid || root.child('users').child(auth.uid).child('userType').val() === 'admin')",
        ".validate": "newData.hasChildren(['id', 'userId', 'latitude', 'longitude'])"
      }
    }
  }
}
```

### CORS Configuration

Update `server.js` for production:

```javascript
const corsOptions = {
  origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  optionsSuccessStatus: 200,
};

app.use(cors(corsOptions));
```

### SSL/TLS

- Use HTTPS only in production
- Let's Encrypt for free SSL
- Platform-provided SSL (Railway, Heroku)

## Monitoring & Logging

### Add Request Logging

```bash
npm install morgan
```

```javascript
const morgan = require('morgan');
app.use(morgan('combined'));
```

### Error Tracking with Sentry

```bash
npm install @sentry/node
```

```javascript
const Sentry = require('@sentry/node');

Sentry.init({ dsn: process.env.SENTRY_DSN });
app.use(Sentry.Handlers.requestHandler());
app.use(Sentry.Handlers.errorHandler());
```

## Scaling Considerations

As user base grows:

1. **Database**: Consider Firebase Realtime Database limitations
   - Consider Firestore for more complex queries
   - Set up backups

2. **API**: 
   - Add rate limiting
   - Implement caching
   - Use CDN for static assets

3. **Infrastructure**:
   - Auto-scaling
   - Load balancing
   - Database replication

## Cost Optimization

### Firebase Pricing

- **Database reads**: $1 per 100,000 reads
- **Database writes**: $1 per 100,000 writes
- **Authentication**: Free up to 50k MAU

### Optimize costs:

- Cache frequent reads
- Batch write operations
- Use scheduled cleanup for old data
- Monitor usage in Firebase Console

## Rollback Plan

1. Keep previous `.env` backed up
2. Tag releases in Git
3. Use platform's rollback features
4. Keep database backups

```bash
# For Git tags
git tag -a v1.0.0 -m "Production release"
git push origin v1.0.0
```

## Monitoring Checklist

- [ ] Set up error tracking (Sentry, etc.)
- [ ] Configure log aggregation
- [ ] Set up uptime monitoring
- [ ] Alert on high error rates
- [ ] Daily review of log files
- [ ] Weekly performance review

## Support Resources

- Railway Docs: https://docs.railway.app
- Heroku Docs: https://devcenter.heroku.com
- AWS Docs: https://docs.aws.amazon.com
- Firebase Docs: https://firebase.google.com/docs
- Node.js Best Practices: https://github.com/goldbergyoni/nodebestpractices

## Next: Update Flutter Frontend

Once backend is deployed and stable:

1. Build release APK for Android
2. Build release IPA for iOS
3. Submit to Play Store / App Store
4. Monitor user feedback

---

**Need help?** Check platform-specific documentation or open an issue on GitHub.
