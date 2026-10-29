# Akenzhan Assanali — Student API

Spring Boot CRUD application for managing students (DevOps midterm).

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
| DELETE | `/api/students/{id}` | Delete a student |

## Run

```bash
cp .env.example .env      # set your own password
docker compose up -d --build
curl http://localhost:8080/api/students
```
