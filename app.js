const express = require("express");
const mongoose = require("mongoose");
const bodyParser = require('body-parser')
require("dotenv").config();
const app = express();

const PORT = process.env.PORT || 5000;

const restrictOrigin = require("./src/frameworks/middlewares/restrictOrigin");

mongoose 
  .connect(process.env.MONGO_URL)   
  .then(() => {
    console.log("Database connection Success!");
  })
  .catch((err) => {
    console.error("Mongo Connection Error", err);
  });

app.use(restrictOrigin);

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.get("/ping", (req, res) => {
  return res.send({
    status: "Server is up and running",
  });
});

app.use("/users", require("./src/app/modules/users/user.route.js"));
app.use("/auth", require("./src/app/modules/auth/auth.route.js"));

app.listen(PORT, () => {
  console.log("Server started listening on port : ", PORT);
});