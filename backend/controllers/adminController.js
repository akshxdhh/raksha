const { db, auth } = require('../config/firebase');

// Get all pending ambulance registrations
const getPendingAmbulances = async (req, res) => {
  try {
    const snapshot = await db.ref('ambulances').get();
    
    if (!snapshot.exists()) {
      return res.status(200).json({
        error: false,
        data: [],
      });
    }

    const pending = [];
    snapshot.forEach((child) => {
      const ambulance = child.val();
      if (!ambulance.isVerified) {
        pending.push(ambulance);
      }
    });

    res.status(200).json({
      error: false,
      data: pending,
    });
  } catch (error) {
    console.error('Error fetching pending ambulances:', error);
    res.status(500).json({
      error: true,
      message: error.message,
    });
  }
};

// Verify ambulance registration
const verifyAmbulance = async (req, res) => {
  try {
    const { ambulanceId } = req.params;
    const { isApproved } = req.body;

    const ambulanceRef = db.ref(`ambulances/${ambulanceId}`);
    const snapshot = await ambulanceRef.get();

    if (!snapshot.exists()) {
      return res.status(404).json({
        error: true,
        message: 'Ambulance not found',
      });
    }

    if (isApproved) {
      await ambulanceRef.update({
        isVerified: true,
        status: 'active',
        verifiedAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      });

      res.status(200).json({
        error: false,
        message: 'Ambulance verified and activated successfully',
      });
    } else {
      // Delete if rejected
      await ambulanceRef.remove();

      res.status(200).json({
        error: false,
        message: 'Ambulance registration rejected',
      });
    }
  } catch (error) {
    console.error('Error verifying ambulance:', error);
    res.status(500).json({
      error: true,
      message: error.message,
    });
  }
};

// Get all ambulances (for admin)
const getAllAmbulances = async (req, res) => {
  try {
    const snapshot = await db.ref('ambulances').get();
    
    if (!snapshot.exists()) {
      return res.status(200).json({
        error: false,
        data: [],
      });
    }

    const ambulances = [];
    snapshot.forEach((child) => {
      ambulances.push(child.val());
    });

    res.status(200).json({
      error: false,
      data: ambulances,
    });
  } catch (error) {
    console.error('Error fetching ambulances:', error);
    res.status(500).json({
      error: true,
      message: error.message,
    });
  }
};

// Deactivate ambulance
const deactivateAmbulance = async (req, res) => {
  try {
    const { ambulanceId } = req.params;

    await db.ref(`ambulances/${ambulanceId}`).update({
      status: 'inactive',
      isOnline: false,
      updatedAt: new Date().toISOString(),
    });

    res.status(200).json({
      error: false,
      message: 'Ambulance deactivated successfully',
    });
  } catch (error) {
    console.error('Error deactivating ambulance:', error);
    res.status(500).json({
      error: true,
      message: error.message,
    });
  }
};

// Activate ambulance
const activateAmbulance = async (req, res) => {
  try {
    const { ambulanceId } = req.params;

    await db.ref(`ambulances/${ambulanceId}`).update({
      status: 'active',
      updatedAt: new Date().toISOString(),
    });

    res.status(200).json({
      error: false,
      message: 'Ambulance activated successfully',
    });
  } catch (error) {
    console.error('Error activating ambulance:', error);
    res.status(500).json({
      error: true,
      message: error.message,
    });
  }
};

// Get statistics
const getStatistics = async (req, res) => {
  try {
    const usersSnapshot = await db.ref('users').get();
    const ambulancesSnapshot = await db.ref('ambulances').get();
    const emergenciesSnapshot = await db.ref('emergencies').get();

    const totalUsers = usersSnapshot.exists() ? Object.keys(usersSnapshot.val()).length : 0;
    const totalAmbulances = ambulancesSnapshot.exists() ? Object.keys(ambulancesSnapshot.val()).length : 0;
    const verifiedAmbulances = ambulancesSnapshot.exists()
      ? Object.values(ambulancesSnapshot.val()).filter((a) => a.isVerified).length
      : 0;
    const totalEmergencies = emergenciesSnapshot.exists()
      ? Object.keys(emergenciesSnapshot.val()).length
      : 0;

    let completedEmergencies = 0;
    if (emergenciesSnapshot.exists()) {
      Object.values(emergenciesSnapshot.val()).forEach((emergency) => {
        if (emergency.status === 'completed') {
          completedEmergencies++;
        }
      });
    }

    res.status(200).json({
      error: false,
      data: {
        totalUsers,
        totalAmbulances,
        verifiedAmbulances,
        pendingAmbulances: totalAmbulances - verifiedAmbulances,
        totalEmergencies,
        completedEmergencies,
        ongoingEmergencies: totalEmergencies - completedEmergencies,
      },
    });
  } catch (error) {
    console.error('Error fetching statistics:', error);
    res.status(500).json({
      error: true,
      message: error.message,
    });
  }
};

module.exports = {
  getPendingAmbulances,
  verifyAmbulance,
  getAllAmbulances,
  deactivateAmbulance,
  activateAmbulance,
  getStatistics,
};
