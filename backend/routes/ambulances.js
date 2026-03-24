const express = require('express');
const router = express.Router();
const { authMiddleware } = require('../middleware/auth');
const {
  registerAmbulance,
  getAmbulanceDetails,
  updateAmbulanceLocation,
  updateAmbulanceStatus,
  getNearbyAmbulances,
} = require('../controllers/ambulanceController');

// Register ambulance
router.post('/register', authMiddleware, registerAmbulance);

// Get ambulance details
router.get('/details', authMiddleware, getAmbulanceDetails);

// Update location
router.put('/location', authMiddleware, updateAmbulanceLocation);

// Update status
router.put('/status', authMiddleware, updateAmbulanceStatus);

// Get nearby ambulances (public - no auth needed but could be from user request)
router.get('/nearby', getNearbyAmbulances);

module.exports = router;
