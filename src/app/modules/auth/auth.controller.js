const User = require("../../../frameworks/models/user.model");
const { generateJwt } = require("../../../frameworks/utils/helpers/generateJWT");
const bcrypt = require("bcryptjs");

exports.Login = async (req, res) => {
    try {
      const { email, password } = req.body;
      if (!email || !password) {
        return res.status(400).json({
          error: true,
          message: "Cannot authorize user.",
        });
      }

      const user = await User.findOne({ email: email });
      // NOT FOUND - Throw error
      if (!user) {
        return res.status(404).json({
          error: true,
          message: "Account not found",
        });
      }
      const isValid = await bcrypt.compare(password, user.password);
      if (!isValid) {
        return res.status(400).json({
          error: true,
          message: "Invalid credentials",
        });
      }

      //Generate Access token
    const { error, token } = await generateJwt(user.email, user.userId)
    if (error) {
      return res.status(500).json({
        error: true,
        message: "Couldn't create access token. Please try again later",
      });
    }
    user.accessToken = token;

      await user.save();
      
      //Success
      return res.send({
        success: true,
        message: "User logged in successfully",
        accessToken: token,
       });
    } catch (err) {
      console.error("Login error", err);
      return res.status(500).json({
        error: true,
        message: "Couldn't login. Please try again later.",
      });
    }
  };
