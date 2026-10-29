# Akenzhan Assanali — Student API

Student management service built with Spring Boot, PostgreSQL and Docker (DevOps midterm, Akenzhan Assanali).

- **Student:** Akenzhan Assanali
- **Stack:** Java 17, Spring Boot, Gradle, PostgreSQL, Docker, Jenkins
- **Image:** `akenzhan-assanali-student-api:v1.0-akenzhan-assanali`

## API

| Method | URL | Description |
|---|---|---|
| GET | `/` | Application info (student name, version) |
| GET | `/api/students` | List all students |
| GET | `/api/students/{id}` | Get one student |
| POST | `/api/students` | Create a student |
| PUT | `/api/students/{id}` | Update a student |
| DELETE | `/api/students/{id}` | Delete a student |

## Run

```bash
cp .env.example .env      # set your own password
docker compose up -d --build
curl http://localhost:8080/api/students
```

## Changes by Akenzhan Assanali

- Added the **Update** operation: `PUT /api/students/{id}` replaces the student's
  first name, last name, email and course.
- Updating a student that does not exist returns `404 Not Found` with a JSON error message.
- Added automated tests for successful update and for the missing-student case.
