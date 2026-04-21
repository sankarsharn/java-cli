# Stage 1: Build and Setup
FROM eclipse-temurin:21-jdk-jammy AS builder
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
WORKDIR /app
RUN mkdir lib && \
    curl -L https://jdbc.postgresql.org/download/postgresql-42.7.2.jar -o lib/postgresql.jar
COPY src ./src
RUN javac -d bin -cp "lib/postgresql.jar" src/com/university/Main.java
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
COPY --from=builder /app/bin ./bin
COPY --from=builder /app/lib ./lib
ENTRYPOINT ["java", "-cp", "bin:lib/postgresql.jar", "com.university.Main"]