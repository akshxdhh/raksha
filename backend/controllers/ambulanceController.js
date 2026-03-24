const { db } = require('../config/firebase');

// Register ambulance (driver)
const registerAmbulance = async (req, res) => {
  try {
    const userId = req.userId;
    const {
      driverName,
      licenseNumber,
      licenseExpiryDate,
      ambulanceRegistration,
      ambulanceId,
      ambulanceLicensePath,
      ambulanceIdCardPath,
      ambulancePhotoPath,
      phoneNumber,
      emergencyContact,
    } = req.body;

    if (!driverName || !licenseNumber || !ambulanceRegistration || !ambulanceId) {
      return res.status(400).json({
        error: true,
        message: 'Missing required fields',
      });
    }

    const ambulanceData = {
      uid: userId,
      driverName,
      licenseNumber,
      licenseExpiryDate,
      ambulanceRegistration,
      ambulanceId,
      ambulanceLicensePath,
      ambulanceIdCardPath,
      ambulancePhotoPath,
      phoneNumber,
      emergencyContact,
      status: 'pending', // pending, active, inactive
      isVerified: false,
      isOnline: false,
      currentLocation: {
        latitude: 0,
        longitude: 0,
        address: '',
      },
      rating: 5.0,
      totalTrips: 0,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };

    await db.ref(`ambulances/${userId}`).set(ambulanceData);

    // Update user type to ambulance_driver
    await db.ref(`users/${userId}`).update({
      userType: 'ambulance_driver',
      updatedAt: new Date().toISOString(),
    });

    res.status(201).json({
      error: false,
      message: 'Ambulance registered successfully. Awaiting admin verification.',
      data: ambulanceData,
    });
  } catch (error) {
    console.error('Registration error:', error);
    res.status(400).json({
      error: true,
      message: error.message,
    });
  }
};

// Get ambulance details
const getAmbulanceDetails = async (req, res) => {
  try {
    const userId = req.userId;

    const snapshot = await db.ref(`ambulances/${userId}`).get();
    
    if (!snapshot.exists()) {
      return res.status(404).json({
        error: true,
        message: 'Ambulance not found',
      });
    }

    res.status(200).json({
      error: false,
      data: snapshot.val(),
    });
  } catch (error) {
    console.error('Error fetching ambulance details:', error);
    res.status(500).json({
      error: true,
      message: error.message,
    });
  }
};

// Update ambulance location
const updateAmbulanceLocation = async (req, res) => {
  try {
    const userId = req.userId;
    const { latitude, longitude, address } = req.body;

    if (latitude === undefined || longitude === undefined) {
      return res.status(400).json({
        error: true,
        message: 'Latitude and longitude are required',
      });
    }

    await db.ref(`ambulances/${userId}/currentLocation`).set({
      latitude,
      longitude,
      address: address || '',
      updatedAt: new Date().toISOString(),
    });

    res.status(200).json({
      error: false,
      message: 'Location updated successfully',
    });
  } catch (error) {
    console.error('Error updating location:', error);
    res.status(500).json({
      error: true,
      message: error.message,
    });
  }
};

// Update ambulance online status
const updateAmbulanceStatus = async (req, res) => {
  try {
    const userId = req.userId;
    const { isOnline, status } = req.body;

    const updates = {};
    if (isOnline !== undefined) updates.isOnline = isOnline;
    if (status) updates.status = status;
    
    updates.updatedAt = new Date().toISOString();

    await db.ref(`ambulances/${userId}`).update(updates);

    res.status(200).json({
      error: false,
      message: 'Status updated successfully',
    });
  } catch (error) {
    console.error('Error updating status:', error);
    res.status(500).json({
      error: true,
      message: error.message,
    });
  }
};

// Get nearby ambulances (for users)
const getNearbyAmbulances = async (req, res) => {
  try {
    const { latitude, longitude, radiusKm = 5 } = req.query;

    if (!latitude || !longitude) {
      return res.status(400).json({
        error: true,
        message: 'Latitude and longitude are required',
      });
    }

    const snapshot = await db.ref('ambulances').get();
    
    if (!snapshot.exists()) {
      return res.status(200).json({
        error: false,
        data: [],
      });
    }

    const nearby = [];
    snapshot.forEach((child) => {
      const ambulance = child.val();
      if (ambulance.status === 'active' && ambulance.isOnline && ambulance.isVerified) {
        const distance = calculateDistance(
          latitude,
          longitude,
          ambulance.currentLocation.latitude,
          ambulance.currentLocation.longitude
        );

        if (distance <= radiusKm) {
          nearby.push({
            ...ambulance,
            distance: distance.toFixed(2),
          });
        }
      }
    });

    // Sort by distance
    nearby.sort((a, b) => parseFloat(a.distance) - parseFloat(b.distance));

    res.status(200).json({
      error: false,
      data: nearby,
    });
  } catch (error) {
    console.error('Error fetching nearby ambulances:', error);
    res.status(500).json({
      error: true,
      message: error.message,
    });
  }
};

// Calculate distance between two coordinates (Haversine formula)
const calculateDistance = (lat1, lon1, lat2, lon2) => {
  const R = 6371; // Radius of Earth in km
  const dLat = ((lat2 - lat1) * Math.PI) / 180;
  const dLon = ((lon2 - lon1) * Math.PI) / 180;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos((lat1 * Math.PI) / 180) *
      Math.cos((lat2 * Math.PI) / 180) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
};

module.exports = {
  registerAmbulance,
  getAmbulanceDetails,
  updateAmbulanceLocation,
  updateAmbulanceStatus,
  getNearbyAmbulances,
};
