const { db } = require('../config/firebase');

// Create emergency request
const createEmergency = async (req, res) => {
  try {
    const userId = req.userId;
    const {
      latitude,
      longitude,
      address,
      emergencyType,
      description,
      contactPerson,
      contactPhone,
    } = req.body;

    if (!latitude || !longitude || !contactPhone) {
      return res.status(400).json({
        error: true,
        message: 'Latitude, longitude, and contact phone are required',
      });
    }

    const emergencyId = db.ref('emergencies').push().key;

    const emergencyData = {
      id: emergencyId,
      userId,
      latitude,
      longitude,
      address: address || '',
      emergencyType: emergencyType || 'general',
      description: description || '',
      contactPerson: contactPerson || '',
      contactPhone,
      status: 'pending', // pending, accepted, completed, cancelled
      assignedAmbulance: null,
      createdAt: new Date().toISOString(),
      acceptedAt: null,
      completedAt: null,
    };

    await db.ref(`emergencies/${emergencyId}`).set(emergencyData);

    // Store in user's emergencies
    await db.ref(`users/${userId}/emergencies/${emergencyId}`).set(true);

    res.status(201).json({
      error: false,
      message: 'Emergency request created successfully',
      data: emergencyData,
    });
  } catch (error) {
    console.error('Error creating emergency:', error);
    res.status(400).json({
      error: true,
      message: error.message,
    });
  }
};

// Get emergency details
const getEmergency = async (req, res) => {
  try {
    const { emergencyId } = req.params;

    const snapshot = await db.ref(`emergencies/${emergencyId}`).get();
    
    if (!snapshot.exists()) {
      return res.status(404).json({
        error: true,
        message: 'Emergency not found',
      });
    }

    res.status(200).json({
      error: false,
      data: snapshot.val(),
    });
  } catch (error) {
    console.error('Error fetching emergency:', error);
    res.status(500).json({
      error: true,
      message: error.message,
    });
  }
};

// Get user's emergencies
const getUserEmergencies = async (req, res) => {
  try {
    const userId = req.userId;

    const snapshot = await db.ref(`users/${userId}/emergencies`).get();
    
    if (!snapshot.exists()) {
      return res.status(200).json({
        error: false,
        data: [],
      });
    }

    const emergencyIds = Object.keys(snapshot.val());
    const emergencies = [];

    for (const id of emergencyIds) {
      const emSnapshot = await db.ref(`emergencies/${id}`).get();
      if (emSnapshot.exists()) {
        emergencies.push(emSnapshot.val());
      }
    }

    // Sort by created date (newest first)
    emergencies.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

    res.status(200).json({
      error: false,
      data: emergencies,
    });
  } catch (error) {
    console.error('Error fetching emergencies:', error);
    res.status(500).json({
      error: true,
      message: error.message,
    });
  }
};

// Update emergency status
const updateEmergencyStatus = async (req, res) => {
  try {
    const { emergencyId } = req.params;
    const { status, assignedAmbulance } = req.body;

    const updates = {
      updatedAt: new Date().toISOString(),
    };

    if (status) {
      updates.status = status;
      if (status === 'accepted') {
        updates.acceptedAt = new Date().toISOString();
      } else if (status === 'completed') {
        updates.completedAt = new Date().toISOString();
      }
    }

    if (assignedAmbulance) {
      updates.assignedAmbulance = assignedAmbulance;
    }

    await db.ref(`emergencies/${emergencyId}`).update(updates);

    res.status(200).json({
      error: false,
      message: 'Emergency status updated successfully',
    });
  } catch (error) {
    console.error('Error updating emergency:', error);
    res.status(500).json({
      error: true,
      message: error.message,
    });
  }
};

// Get pending emergencies (for admin)
const getPendingEmergencies = async (req, res) => {
  try {
    const snapshot = await db.ref('emergencies').orderByChild('status').equalTo('pending').get();
    
    if (!snapshot.exists()) {
      return res.status(200).json({
        error: false,
        data: [],
      });
    }

    const emergencies = [];
    snapshot.forEach((child) => {
      emergencies.push(child.val());
    });

    res.status(200).json({
      error: false,
      data: emergencies,
    });
  } catch (error) {
    console.error('Error fetching pending emergencies:', error);
    res.status(500).json({
      error: true,
      message: error.message,
    });
  }
};

// Get all emergencies (for admin)
const getAllEmergencies = async (req, res) => {
  try {
    const snapshot = await db.ref('emergencies').get();
    
    if (!snapshot.exists()) {
      return res.status(200).json({
        error: false,
        data: [],
      });
    }

    const emergencies = [];
    snapshot.forEach((child) => {
      emergencies.push(child.val());
    });

    // Sort by created date (newest first)
    emergencies.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

    res.status(200).json({
      error: false,
      data: emergencies,
    });
  } catch (error) {
    console.error('Error fetching emergencies:', error);
    res.status(500).json({
      error: true,
      message: error.message,
    });
  }
};

module.exports = {
  createEmergency,
  getEmergency,
  getUserEmergencies,
  updateEmergencyStatus,
  getPendingEmergencies,
  getAllEmergencies,
};
