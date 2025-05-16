# Loyalty Promotion System

## Overview

This project is a Ruby on Rails application designed to manage user transactions and rewards. It includes features for user authentication, transaction processing, and reward issuance based on user activity.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [API Documentation](#api-documentation)
- [Testing](#testing)
- [Scheduling](#scheduling)

## Installation

1. **Clone the repository:**

   ```bash
   git clone <repository-url>
   cd <project-directory>
   ```

2. **Install dependencies:**

   Make sure you have Ruby and Rails installed. Then run:

   ```bash
   bundle install
   ```

3. **Set up the database:**

   Create and migrate the database:

   ```bash
   rails db:create
   rails db:migrate
   rails db:seed  # Optional: to seed the database with initial data
   ```

4. **Start the server:**

   ```bash
   rails server
   ```

   You can now access the application at `http://localhost:3000`.

## Usage

### API Endpoints

The application provides a RESTful API for user registration, login, and transaction management. Below are some key endpoints:

- **User  Registration**
  - `POST /api/v1/auth/register`

- **User  Login**
  - `POST /api/v1/auth/login`

- **Create Transaction**
  - `POST /api/v1/transactions`

### Example Request

To create a transaction, you can use the following curl command:

```bash
curl -X POST http://localhost:3000/api/v1/transactions \
-H "Authorization: Bearer <your_token>" \
-H "Content-Type: application/json" \
-d '{
  "transaction": {
    "amount": 150.75,
    "country": "US"
  }
}'
```

## API Documentation

The API is built using Grape and can be accessed through the following endpoints. For detailed API documentation, you can use the integrated Swagger UI provided by the `grape-swagger` gem.

## Testing

To run the test suite, use the following command:

```bash
bundle exec rspec
```

This will execute all the tests defined in the `spec` directory.

## Scheduling

The application uses the `whenever` gem to schedule background jobs. The following jobs are defined:

- **Monthly Reward Check**
  - Runs on the monthly basis.

To update the crontab with the scheduled jobs, run:

```bash
whenever --update-crontab
```