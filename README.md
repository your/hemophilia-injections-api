# Patient injections API

This API allows for managing patient injections and adherence scores.

## Prerequisites

Docker and Docker compose are required to run this application and Swagger UI.

## Running the application

1. Clone the repository:

```bash
  git clone <repository-url>
  cd <repository-directory>
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

## API Documentation

For more details on the API endpoints and usage, refer to the API documentation provided in the Swagger UI at http://localhost:8080.

Please note: the Swagger UI instance should be runinng in a container when
using the `docker compose` command above. Make sure no other applications are
running at the same time on local ports 3000 and 8080.

## Caveats and further improvements

* The application relies on a SQLite database for the purpose of the test and
  to keep dependencies to a minimum; it comes without saying that in a real
  production environment we'd need to use a *real* database, e.g. Postgres

* There is no caching mechanism in place, but that would definitely be
  recommended in a real production scenario, e.g. using Redis. It's an extra
  dependency we don't need for this challenge

* The endpoint to the create patients is not protected at the moment, but would
  definitely need to be e.g. using a service token and/or using an IP whitelist

* The treatement schedule is set to 3 days in a constant, but it should probably
  be moved to an attribute, perhaps on the Patient model. Or by creating a
  separate entity for the treatment schedule. Nevertherless, the current
  alghorithm should be able to work with any number of days

* The adherence score calculation is inside the Patient model for simplicity;
  it should probably be moved to a separate object, especially if the model
  keeps growing

* It would be beneficial to write an integration or contract test, especially
  if the endpoints need to be used by a separate service/engine.
