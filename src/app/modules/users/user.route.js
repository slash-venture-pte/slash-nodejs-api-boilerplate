const express = require("express");
const router = express.Router();
const cleanBody = require("../../../frameworks/middlewares/cleanbody");
const UserController = require("./user.controller");
//Define endpoints
router.post("/signup", cleanBody, UserController.Signup);
module.exports = router;
