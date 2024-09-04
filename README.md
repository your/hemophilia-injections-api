# Patient injections API

This API allows for managing patient injections and adherence scores.

## Prerequisites

Docker and Docker compose are required to run this application and Swagger UI.

## Running the application

1. Clone the repository:

```bash
  git clone https://github.com/your/hemophilia-injections-api.git
  cd hemophilia-injections-api
  ```

2. Build and start the API and the Swagger UI using Docker Compose:

```bash
  docker-compose up --build injections-api swagger-ui
```

### Examples

The recommended way to test the endpoints is to use the Swagger UI at http://localhost:8080

You can also use `curl`:

1. Add a new patient

```bash
curl -X POST http://localhost:3000/api/v1/patients \
-H "Content-Type: application/json" \
-d '{
  "patient": {
    "first_name": "John",
    "last_name": "Doe",
    "email": "john.doe@example.com",
    "date_of_birth": "1990-01-01"
  }
}'
```

Important: take note of the `api_key` from the response as you'll need that to
authenticate to the other endpoints, passing it as a Bearer Authorization header.

2. Add a new injection

```bash
curl -X POST http://localhost:3000/api/v1/patients/1/injections \
-H "Content-Type: application/json" \
-H "Authorization: Bearer YOUR_PATIENT_API_KEY" \
-d '{
  "injection": {
    "dose_mm": 10,
    "lot_number": "LOT122",
    "drug_name": "Example Drug",
    "date": "2023-10-01"
  }
}'
```

3. List all injections

```bash
curl -X GET http://localhost:3000/api/v1/patients/1/injections \
-H "Authorization: Bearer YOUR_PATIENT_API_KEY"
```

4. Retrieve adherence score

```bash
curl -X GET http://localhost:3000/api/v1/patients/1/adherence_score \
-H "Authorization: Bearer YOUR_PATIENT_API_KEY"
```

## Running Tests

To run the test suite, use the following command:

```bash
docker-compose run --build --rm test
```

You can also run this locally using `bundle exec rspec`.

## CI/CD with GitHub Actions
This project uses GitHub Actions for continuous integration (CI) to automate the
testing and linting processes. The CI workflow is defined in the `.github/workflows/ci.yml`
file and includes the following jobs:

1. Scan Ruby: This job runs on every pull request and push to the main branch.
   It checks the code for common Rails security vulnerabilities using Brakeman.

2. Lint: This job also runs on every pull request and push to the main branch.
   It ensures that the code adheres to consistent style guidelines using RuboCop.

3. Test: This job runs the test suite using RSpec. It is triggered on every push and pull request.

By using GitHub Actions, we ensure that our code is continuously tested and linted,
helping to maintain code quality and catch issues early in the development process.

## API Documentation

For more details on the API endpoints and usage, refer to the API documentation provided in the Swagger UI at http://localhost:8080.

Please note: the Swagger UI instance should be running in a container when
using the `docker compose` command above. Make sure no other applications are
running at the same time on local ports 3000 and 8080.

## Metrics and healthcheck

Basic metrics with total requests, duration and exceptions are available for scraping at http://localhost:3000/metrics

Healthcheck endpoint available at http://localhost:3000/up

## Caveats and further improvements

* The application relies on a SQLite database for the purpose of the test and
  to keep dependencies to a minimum; it comes without saying that in a real
  production environment we'd need to use a *real* database, e.g. Postgres

* There is no caching mechanism in place, but that would definitely be
  recommended in a real production scenario, e.g. using Redis. It's an extra
  dependency we don't need for this challenge

* The endpoint to the create patients is not protected at the moment, but would
  definitely need to be e.g. using a service token and/or using an IP whitelist

* The patient `id` is an integer at the moment, but I'd have preferred the `uuid`
  type if we used Postgres (for instance), especially to ensure global uniqueness
  across databases and avoid enumeration attacks

* The treatement schedule is set to 3 days in a constant, but it should probably
  be moved to an attribute, perhaps on the `Patient` model. Or by creating a
  separate entity for the treatment schedule. Nevertherless, the current
  alghorithm will already work with any number of days

* The adherence score calculation is inside the `Patient` model for simplicity;
  it should probably be moved to a separate object, especially if the model
  keeps growing

* Still regarding the adherence score calculation, I've put a constraint to
  prevent multiple injections on the same day, but it's still theoretically
  possible to have multiple injections on the same day with different drugs...
  I expect this to be an edge case and potentially something not really possible,
  but I don't know for sure so I've put a cap, just in case. A similar constraint
  to the one I've introduced can easily be added otherwise

* The `/metrics` and `/up` endpoint should not be publicly accessible, but rather
  available behind basic authentication and/or IP whitelisting
