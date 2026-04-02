const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const programController = require('../controllers/program.controller');

router.get('/', auth, programController.getPrograms);
router.get('/:id', auth, programController.getProgram);

module.exports = router;