const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const { body } = require('express-validator');
const validate = require('../middleware/validate');
const aiController = require('../controllers/ai.controller');

router.post('/chat', auth, [
  body('message').trim().notEmpty().withMessage('Message is required'),
], validate, aiController.chat);

router.get('/history', auth, aiController.getChatHistory);
router.delete('/clear', auth, aiController.clearChat);

module.exports = router;