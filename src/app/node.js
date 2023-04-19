const { time } = require('console');
const express = require('express')
const app = express()
const port = 3000
const timestamp = Date.now()
const environment = process.env.ENVIRONMENT

app.get('/', function (req, res) {
  res.json({
    message: "Automate all the things!!!",
    timestamp: Date.now(),
    environment: environment
  });
});

app.listen(3000, () => {
 console.log("Server running on port 3000");
});
