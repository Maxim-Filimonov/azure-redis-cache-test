# Azure Redis Cache Test Application

A simple Node.js Express application for testing Azure Redis Cache connectivity and basic operations.

## Quick Start

For easy deployment and cleanup, use the provided Terraform-based scripts:

### Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) installed (>= 1.0)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed and logged in (`az login`)
- Node.js >= 20.0.0

### Automated Deployment
```bash
# Optional: Copy and customize variables
cp terraform.tfvars.example terraform.tfvars

# Deploy infrastructure and application
./deploy.sh
```
This script will:
- Initialize Terraform
- Create an Azure resource group using Terraform
- Create a Redis Cache instance (Basic SKU)
- Create an App Service Plan and Web App
- Configure environment variables automatically
- Deploy the application using `az webapp up`

### Cleanup Resources
```bash
./cleanup.sh
```
This script removes all Azure resources created by Terraform using `terraform destroy`.

## Features

- Health check endpoint to verify Redis connectivity
- Set and get key-value pairs in Redis
- Proper error handling and logging
- Environment variable configuration
- Graceful shutdown handling

## Prerequisites

- Node.js >= 20.0.0
- [Terraform](https://www.terraform.io/downloads.html) (>= 1.0)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) logged in (`az login`)
- Azure subscription with sufficient permissions

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

### Terraform Variables

Customize deployment by copying and editing the variables file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Available variables:
- `resource_group_name`: Name of the Azure resource group (default: "redis-cache-test-rg")
- `location`: Azure region (default: "australiasoutheast")
- `redis_name`: Base name for Redis cache (default: "redis-cache-test")
- `app_service_plan_name`: App Service Plan name (default: "redis-cache-test-plan")
- `app_name`: Base name for web app (default: "redis-cache-test-app")
- `tags`: Resource tags

### Environment Variables (Auto-configured)

Terraform automatically configures these environment variables:
- `REDIS_URL`: Azure Redis Cache URL
- `REDIS_ACCESS_KEY`: Redis access key
- `PORT`: Server port (defaults to 3000)

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

### Infrastructure as Code with Terraform

The deployment uses Terraform for infrastructure management:

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Plan deployment:**
   ```bash
   terraform plan
   ```

3. **Apply infrastructure:**
   ```bash
   terraform apply
   ```

4. **Deploy application:**
   ```bash
   cd app
   az webapp up --name $(terraform output -raw app_service_name) \
     --resource-group $(terraform output -raw resource_group_name) \
     --plan $(terraform output -raw app_service_plan_name) \
     --runtime "NODE:22-lts" --sku F1
   ```

### Manual Configuration (if needed)

```bash
az webapp config appsettings set \
  --name your-app-name \
  --resource-group your-resource-group \
  --settings REDIS_URL="your-redis-url" REDIS_ACCESS_KEY="your-key"
```

## Project Structure

```
azure-redis-cache-test/
├── app/
│   ├── package.json          # Node.js dependencies
│   ├── package-lock.json     # Locked dependency versions
│   └── server.js             # Main application file
├── main.tf                   # Main Terraform configuration
├── variables.tf              # Terraform variables
├── outputs.tf                # Terraform outputs
├── terraform.tfvars.example  # Example Terraform variables
├── deploy.sh                 # Terraform-based deployment script
├── cleanup.sh               # Terraform destroy script
├── .gitignore              # Git ignore rules
└── README.md               # This file
```

## Terraform Resources

The Terraform configuration creates:
- **Resource Group**: Container for all resources
- **Redis Cache**: Basic SKU with C0 capacity
- **App Service Plan**: Linux-based F1 (Free) tier
- **Linux Web App**: Node.js 22-lts runtime
- **App Settings**: Automatic Redis connection configuration

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