# Akenzhan Assanali — Student API

Spring Boot CRUD REST API for managing IITU students, built with PostgreSQL and Docker
(DevOps midterm, Akenzhan Assanali).

- **Student:** Akenzhan Assanali
- **Stack:** Java 17, Spring Boot, Gradle, PostgreSQL, Docker, Jenkins
- **Image:** `akenzhan-assanali-student-api:v1.0-akenzhan-assanali`
- **CI:** Jenkins job `Akenzhan_Assanali_Student_API` (SCM polling every 2 minutes)

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

## Project structure

```
akenzhan-assanali-student-api/
├── scripts/      # Akenzhan_Assanali_system_report.sh, Akenzhan_Assanali_api_test.sh
├── logs/         # Akenzhan_Assanali_system_report.log, Akenzhan_Assanali_log_analysis.txt
├── backups/      # README_Akenzhan_Assanali_backup.md
├── src/          # Spring Boot source code and tests
├── Dockerfile    # multi-stage build (Gradle JDK 17 -> JRE 17)
├── docker-compose.yml
├── Jenkinsfile
├── build.gradle
└── README.md
```

## Explanations

### `>` vs `>>` in Linux
- `>` redirects output to a file and **overwrites** it (the old contents are lost).
- `>>` redirects output to a file and **appends** to the end (the old contents are kept).
  The system report script uses `tee -a` (append), so every run adds a new report to the log.

### Why `.env` files, passwords and DB credentials must not be committed
Git keeps the full history: once a secret is pushed it can be read by anyone with access to the
repository (or by everyone if it is public), even after it is deleted in a later commit. Leaked
credentials let attackers access the database and other systems. Secrets are kept in a local
`.env` file (ignored by `.gitignore`), in Jenkins Credentials or in a secret manager; only
`.env.example` with placeholder values is committed.

### Continuous Integration vs Continuous Deployment
- **Continuous Integration (CI)** — every commit is automatically checked out, built and tested
  (here: Checkout → Build → Test → Docker Build → Verify in Jenkins), so errors are found early.
- **Continuous Deployment** — every change that passes the pipeline is automatically released to
  production without manual approval. (Continuous *Delivery* also prepares a release
  automatically, but deployment is started manually.) This project implements CI only.

## Jenkins CI (job `Akenzhan_Assanali_Student_API`)

Local Jenkins runs in Docker (`jenkins/`): JDK 17 tool `jdk-17`, Gradle wrapper, Docker CLI
connected to the host Docker engine, job and credentials created with Configuration as Code.
The admin password and the DB password are read from `jenkins/.env` (not committed); the DB
password is stored in Jenkins Credentials as `akenzhan-assanali-db-password`.

```bash
cd jenkins && cp .env.example .env && docker compose up -d --build   # http://localhost:8081
```

Pipeline stages: **Checkout → Build → Test → Docker Build → Verify**. A failing build or test
stops the pipeline, the later stages are skipped.

### Controlled failure (branch `test/akenzhan-assanali-pipeline-failure`)
1. Build #4 — the test `showsStudentNameOnRootPage` was changed to expect `"Assanali Akenzhan"`
   while the application returns `"Akenzhan Assanali"`. Gradle reported
   `8 tests completed, 1 failed`, the **Test** stage failed and **Docker Build** / **Verify**
   were skipped.
2. The expectation was restored in the next commit; build #5 passed all stages.

### Automation
The job polls GitHub (`pollSCM('H/2 * * * *')`); a new commit on `main` starts the pipeline
automatically ("Started by an SCM change"). A GitHub webhook is not used because this Jenkins
runs on `localhost` and is not reachable from GitHub.
