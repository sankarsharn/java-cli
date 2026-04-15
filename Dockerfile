# Stage 1: Build (Using Java 21)
FROM maven:3.9.6-eclipse-temurin-21 AS builder
COPY . /app
WORKDIR /app
RUN mvn clean package

# Stage 2: Runtime (Using Java 21)
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
COPY --from=builder /app/target/student-app-1.0-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]