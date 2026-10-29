# ---------- Stage 1: build the Spring Boot JAR with Gradle ----------
FROM eclipse-temurin:17-jdk AS build
WORKDIR /workspace

COPY gradlew settings.gradle build.gradle ./
COPY gradle ./gradle
RUN chmod +x gradlew && ./gradlew dependencies --no-daemon > /dev/null

COPY src ./src
RUN ./gradlew bootJar -x test --no-daemon

# ---------- Stage 2: small Java runtime image ----------
FROM eclipse-temurin:17-jre
LABEL maintainer="Akenzhan Assanali" \
      org.opencontainers.image.title="akenzhan-assanali-student-api"

ARG APP_VERSION=v1.0-akenzhan-assanali
ENV APP_VERSION=${APP_VERSION}

WORKDIR /app
COPY --from=build /workspace/build/libs/student-api.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
