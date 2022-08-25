const express = require("express");
const router = express.Router();
const cleanBody = require("../../../frameworks/middlewares/cleanbody");
const AuthController = require("./auth.controller");
//Define endpoints
router.post("/", cleanBody, AuthController.Login);
module.exports = router;
