const express = require('express');
const router = express.Router();
const { authMiddleware } = require('../middleware/auth');
const {
  createEmergency,
  getEmergency,
  getUserEmergencies,
  updateEmergencyStatus,
  getPendingEmergencies,
  getAllEmergencies,
} = require('../controllers/emergencyController');

// Create emergency request
router.post('/create', authMiddleware, createEmergency);

// Get specific emergency
router.get('/:emergencyId', authMiddleware, getEmergency);

// Get user's emergencies
router.get('/', authMiddleware, getUserEmergencies);

// Update emergency status
router.put('/:emergencyId', authMiddleware, updateEmergencyStatus);

// Get pending emergencies (admin)
router.get('/pending/list', authMiddleware, getPendingEmergencies);

// Get all emergencies (admin)
router.get('/all/list', authMiddleware, getAllEmergencies);

module.exports = router;
