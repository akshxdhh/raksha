const express = require('express');
const router = express.Router();
const { auth } = require('../config/firebase');
const { authMiddleware } = require('../middleware/auth');

// Login with email and password
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        error: true,
        message: 'Email and password are required',
      });
    }

    // Note: Firebase Admin SDK doesn't provide a direct password login.
    // Use Firebase REST API or Firebase SDK from client side, then pass the token here.
    // For now, we'll return an instruction message.

    res.status(200).json({
      error: false,
      message: 'Please use client-side Firebase authentication and send the idToken',
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(400).json({
      error: true,
      message: error.message,
    });
  }
});

// Verify token
router.post('/verify-token', authMiddleware, async (req, res) => {
  try {
    res.status(200).json({
      error: false,
      message: 'Token is valid',
      data: {
        uid: req.userId,
        email: req.user.email,
      },
    });
  } catch (error) {
    console.error('Token verification error:', error);
    res.status(400).json({
      error: true,
      message: error.message,
    });
  }
});

// Logout (client-side mainly, but can invalidate tokens if needed)
router.post('/logout', authMiddleware, async (req, res) => {
  try {
    res.status(200).json({
      error: false,
      message: 'Logged out successfully',
    });
  } catch (error) {
    console.error('Logout error:', error);
    res.status(400).json({
      error: true,
      message: error.message,
    });
  }
});

module.exports = router;
