const express = require('express');
const router = express.Router();
const { authMiddleware } = require('../middleware/auth');
const {
  registerUser,
  getUserProfile,
  updateUserProfile,
  getUsersCount,
  getAllUsers,
  deleteUser,
} = require('../controllers/userController');

// Public routes
router.post('/register', registerUser);

// Protected routes
router.get('/profile', authMiddleware, getUserProfile);
router.put('/profile', authMiddleware, updateUserProfile);
router.get('/count', authMiddleware, getUsersCount);

// Admin routes
router.get('/all', authMiddleware, getAllUsers);
router.delete('/:userId', authMiddleware, deleteUser);

module.exports = router;
