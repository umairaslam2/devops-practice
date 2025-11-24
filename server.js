const express = require("express");
const app = express();
const PORT = process.env.PORT || 8080;

app.get("/", (req, res) => {
  res.send(" container successfullly create hogiya ");
});

app.get("/healthz", (req, res) => {
  res.json({ status: "ok", time: new Date().toISOString() });
});

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

