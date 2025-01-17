const express = require("express");
const app = express();

const PORT = 3000;

app.get("/health", (req, res) => {
  res.send("Server is healthy!");
});

app.listen(PORT, (req, res) => {
  console.log(`Server running on port ${PORT}`);
});
