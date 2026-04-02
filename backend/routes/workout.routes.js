const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const { body } = require('express-validator');
const validate = require('../middleware/validate');
const workoutController = require('../controllers/workout.controller');

router.get('/', auth, workoutController.getMyWorkouts);
router.get('/:id', auth, workoutController.getWorkout);

router.post('/', auth, [
  body('name').trim().notEmpty().withMessage('Workout name is required'),
], validate, workoutController.createWorkout);

router.put('/:id', auth, workoutController.updateWorkout);
router.delete('/:id', auth, workoutController.deleteWorkout);

module.exports = router;