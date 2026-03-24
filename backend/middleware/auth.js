const { auth } = require('../config/firebase');

const authMiddleware = async (req, res, next) => {
  try {
    const token = req.headers.authorization?.split('Bearer ')[1];
    
    if (!token) {
      return res.status(401).json({
        error: true,
        message: 'No token provided',
      });
    }

    const decodedToken = await auth.verifyIdToken(token);
    req.user = decodedToken;
    req.userId = decodedToken.uid;
    next();
  } catch (error) {
    console.error('Auth error:', error);
    res.status(401).json({
      error: true,
      message: 'Invalid or expired token',
    });
  }
};

module.exports = {
  authMiddleware,
};
