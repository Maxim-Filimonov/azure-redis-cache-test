# Azure Redis Cache Test Application

A simple Node.js Express application for testing Azure Redis Cache connectivity and basic operations.

## Features

- Health check endpoint to verify Redis connectivity
- Set and get key-value pairs in Redis
- Proper error handling and logging
- Environment variable configuration
- Graceful shutdown handling

## Prerequisites

- Node.js >= 20.0.0
- Azure Redis Cache instance
- Redis connection URL and access key

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd azure-redis-cache-test
```

2. Navigate to the app directory and install dependencies:
```bash
cd app
npm install
```

## Configuration

Set the following environment variables:

- `REDIS_URL`: Your Azure Redis Cache URL (e.g., `redis://your-cache-name.redis.cache.windows.net:6380`)
- `REDIS_ACCESS_KEY`: Your Azure Redis Cache access key
- `PORT`: (Optional) Port number for the server (defaults to 3000)

### Example

```bash
export REDIS_URL="redis://your-cache-name.redis.cache.windows.net:6380"
export REDIS_ACCESS_KEY="your-redis-access-key"
export PORT=3000
```

## Usage

### Running locally

```bash
cd app
npm start
```

### Available Endpoints

- `GET /` - Application status and Redis connection info
- `GET /health` - Health check with Redis ping test
- `GET /set/:key/:value` - Set a key-value pair in Redis
- `GET /get/:key` - Get a value from Redis by key

### Example API calls

```bash
# Check application status
curl http://localhost:3000/

# Health check
curl http://localhost:3000/health

# Set a value
curl http://localhost:3000/set/mykey/myvalue

# Get a value
curl http://localhost:3000/get/mykey
```

## Deployment

### Azure App Service

Deploy using Azure CLI:

```bash
cd app
az webapp up --name your-app-name --resource-group your-resource-group --location eastus
```

Then configure environment variables:

```bash
az webapp config appsettings set --name your-app-name --resource-group your-resource-group --settings \
  REDIS_URL="redis://your-cache-name.redis.cache.windows.net:6380" \
  REDIS_ACCESS_KEY="your-redis-access-key"
```

## Project Structure

```
azure-redis-cache-test/
├── app/
│   ├── package.json          # Node.js dependencies
│   ├── package-lock.json     # Locked dependency versions
│   └── server.js             # Main application file
├── deploy.sh                 # Azure deployment script
├── cleanup.sh               # Resource cleanup script
├── .gitignore              # Git ignore rules
└── README.md               # This file
```

## Error Handling

The application includes comprehensive error handling:

- Redis connection failures are logged and handled gracefully
- API endpoints return appropriate HTTP status codes
- Health check endpoint indicates Redis connectivity status
- Graceful shutdown on SIGTERM

## Security

- No hardcoded credentials - uses environment variables
- TLS connection to Redis enabled
- Proper error messages without exposing sensitive information

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

MIT License