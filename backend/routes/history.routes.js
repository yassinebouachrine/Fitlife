const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const { body } = require('express-validator');
const validate = require('../middleware/validate');
const historyController = require('../controllers/history.controller');

router.get('/', auth, historyController.getHistory);
router.get('/:id', auth, historyController.getHistoryDetail);

router.post('/', auth, [
  body('workout_name').trim().notEmpty().withMessage('Workout name is required'),
  body('duration_min').isInt({ min: 1 }).withMessage('Duration must be at least 1 minute'),
], validate, historyController.logWorkout);

module.exports = router;