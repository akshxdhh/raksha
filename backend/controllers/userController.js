const { db, auth } = require('../config/firebase');

// Register user (sign up)
const registerUser = async (req, res) => {
  try {
    const { email, password, name, phone } = req.body;

    if (!email || !password || !name || !phone) {
      return res.status(400).json({
        error: true,
        message: 'All fields are required',
      });
    }

    // Create user in Firebase Auth
    const userRecord = await auth.createUser({
      email,
      password,
      displayName: name,
      phoneNumber: phone,
    });

    // Store user info in Realtime Database
    await db.ref(`users/${userRecord.uid}`).set({
      uid: userRecord.uid,
      email,
      name,
      phone,
      userType: 'user', // user, ambulance_driver, admin
      isVerified: false,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    });

    // Generate custom token
    const customToken = await auth.createCustomToken(userRecord.uid);

    res.status(201).json({
      error: false,
      message: 'User registered successfully',
      data: {
        uid: userRecord.uid,
        email,
        name,
        token: customToken,
      },
    });
  } catch (error) {
    console.error('Registration error:', error);
    res.status(400).json({
      error: true,
      message: error.message,
    });
  }
};

// Get user profile
const getUserProfile = async (req, res) => {
  try {
    const userId = req.userId;

    const snapshot = await db.ref(`users/${userId}`).get();
    
    if (!snapshot.exists()) {
      return res.status(404).json({
        error: true,
        message: 'User not found',
      });
    }

    res.status(200).json({
      error: false,
      data: snapshot.val(),
    });
  } catch (error) {
    console.error('Error fetching user profile:', error);
    res.status(500).json({
      error: true,
      message: error.message,
    });
  }
};

// Update user profile
const updateUserProfile = async (req, res) => {
  try {
    const userId = req.userId;
    const updates = req.body;

    // Remove sensitive fields
    delete updates.uid;
    delete updates.userType;
    delete updates.createdAt;

    updates.updatedAt = new Date().toISOString();

    await db.ref(`users/${userId}`).update(updates);

    res.status(200).json({
      error: false,
      message: 'Profile updated successfully',
      data: updates,
    });
  } catch (error) {
    console.error('Error updating profile:', error);
    res.status(500).json({
      error: true,
      message: error.message,
    });
  }
};

// Get users count (for admin)
const getUsersCount = async (req, res) => {
  try {
    const snapshot = await db.ref('users').get();
    const usersCount = snapshot.exists() ? Object.keys(snapshot.val()).length : 0;

    res.status(200).json({
      error: false,
      data: {
        totalUsers: usersCount,
      },
    });
  } catch (error) {
    console.error('Error fetching users count:', error);
    res.status(500).json({
      error: true,
      message: error.message,
    });
  }
};

// Get all users (for admin)
const getAllUsers = async (req, res) => {
  try {
    const snapshot = await db.ref('users').get();
    
    if (!snapshot.exists()) {
      return res.status(200).json({
        error: false,
        data: [],
      });
    }

    const users = [];
    snapshot.forEach((child) => {
      users.push(child.val());
    });

    res.status(200).json({
      error: false,
      data: users,
    });
  } catch (error) {
    console.error('Error fetching users:', error);
    res.status(500).json({
      error: true,
      message: error.message,
    });
  }
};

// Delete user (admin only)
const deleteUser = async (req, res) => {
  try {
    const { userId } = req.params;

    // Delete from Firebase Auth
    await auth.deleteUser(userId);

    // Delete from Realtime Database
    await db.ref(`users/${userId}`).remove();

    res.status(200).json({
      error: false,
      message: 'User deleted successfully',
    });
  } catch (error) {
    console.error('Error deleting user:', error);
    res.status(500).json({
      error: true,
      message: error.message,
    });
  }
};

module.exports = {
  registerUser,
  getUserProfile,
  updateUserProfile,
  getUsersCount,
  getAllUsers,
  deleteUser,
};
