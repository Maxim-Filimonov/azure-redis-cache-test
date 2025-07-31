const express = require("express");
const { createClient } = require("redis");

const app = express();
const port = process.env.PORT || 3000;

// Redis configuration from environment variables
const redisUrl = process.env.REDIS_URL;
const redisKey = process.env.REDIS_ACCESS_KEY;

let redisClient;

// Initialize Redis client
async function initRedis() {
  try {
    if (!redisUrl || !redisKey) {
      throw new Error(
        "Redis configuration missing - REDIS_URL and REDIS_ACCESS_KEY required",
      );
    }

    redisClient = createClient({
      url: redisUrl,
      password: redisKey,
      socket: {
        tls: true,
        rejectUnauthorized: false,
      },
    });

    redisClient.on("error", (err) => {
      console.error("Redis Client Error:", err);
    });

    redisClient.on("connect", () => {
      console.log("Connected to Redis");
    });

    await redisClient.connect();
    console.log("Redis client initialized successfully");
  } catch (error) {
    console.error("Failed to initialize Redis:", error.message);
  }
}

// Routes
app.get("/", (req, res) => {
  res.json({
    message: "Redis Test Application",
    status: "running",
    redisConnected: redisClient?.isOpen || false,
  });
});

app.get("/health", async (req, res) => {
  try {
    if (!redisClient || !redisClient.isOpen) {
      return res.status(503).json({
        status: "error",
        message: "Redis not connected",
      });
    }

    // Test Redis connection with ping
    const pong = await redisClient.ping();

    res.json({
      status: "healthy",
      redis: "connected",
      ping: pong,
    });
  } catch (error) {
    res.status(503).json({
      status: "error",
      message: error.message,
    });
  }
});

app.get("/set/:key/:value", async (req, res) => {
  try {
    if (!redisClient || !redisClient.isOpen) {
      return res.status(503).json({
        status: "error",
        message: "Redis not connected",
      });
    }

    const { key, value } = req.params;
    await redisClient.set(key, value);

    res.json({
      status: "success",
      message: `Set ${key} = ${value}`,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: error.message,
    });
  }
});

app.get("/get/:key", async (req, res) => {
  try {
    if (!redisClient || !redisClient.isOpen) {
      return res.status(503).json({
        status: "error",
        message: "Redis not connected",
      });
    }

    const { key } = req.params;
    const value = await redisClient.get(key);

    res.json({
      status: "success",
      key: key,
      value: value,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: error.message,
    });
  }
});

// Start server
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
  console.log(`Redis URL: ${redisUrl ? "configured" : "missing"}`);
  console.log(`Redis Key: ${redisKey ? "configured" : "missing"}`);

  // Initialize Redis connection
  initRedis();
});

// Graceful shutdown
process.on("SIGTERM", async () => {
  console.log("SIGTERM received, shutting down gracefully");
  if (redisClient) {
    await redisClient.quit();
  }
  process.exit(0);
});
