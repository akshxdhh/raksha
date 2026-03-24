const express = require('express');
const router = express.Router();
const { authMiddleware } = require('../middleware/auth');
const {
  getPendingAmbulances,
  verifyAmbulance,
  getAllAmbulances,
  deactivateAmbulance,
  activateAmbulance,
  getStatistics,
} = require('../controllers/adminController');

// Get pending ambulance registrations
router.get('/ambulances/pending', authMiddleware, getPendingAmbulances);

// Verify ambulance
router.put('/ambulances/:ambulanceId/verify', authMiddleware, verifyAmbulance);

// Get all ambulances
router.get('/ambulances/all', authMiddleware, getAllAmbulances);

// Deactivate ambulance
router.put('/ambulances/:ambulanceId/deactivate', authMiddleware, deactivateAmbulance);

// Activate ambulance
router.put('/ambulances/:ambulanceId/activate', authMiddleware, activateAmbulance);

// Get statistics
router.get('/stats', authMiddleware, getStatistics);

module.exports = router;
