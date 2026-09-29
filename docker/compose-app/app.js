const express = require("express");
const redis = require("redis");

const app = express();
const client = redis.createClient({
  url: "redis://redis:6379"
});

(async () => { await client.connect(); })();

app.get("/", async (req, res) => {
  let count = await client.get("visits");
  count = count ? parseInt(count) + 1 : 1;
  await client.set("visits", count);
  res.send(`Visited ${count} times`);
});

app.listen(3000, () => {
  console.log("Server running on port 3000");
});
