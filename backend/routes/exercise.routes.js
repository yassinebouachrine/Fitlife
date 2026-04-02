const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const exerciseController = require('../controllers/exercise.controller');

router.get('/', auth, exerciseController.getExercises);
router.get('/:id', auth, exerciseController.getExercise);

module.exports = router;