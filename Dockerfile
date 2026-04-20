# Stage 1: Build and Setup
FROM eclipse-temurin:21-jdk-jammy AS builder

# Install curl to download the database driver
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 1. Download the PostgreSQL JDBC Driver manually
RUN mkdir lib && \
    curl -L https://jdbc.postgresql.org/download/postgresql-42.7.2.jar -o lib/postgresql.jar

# 2. Copy source code
COPY src ./src

# 3. Compile the Java code
# We include the postgresql.jar in the classpath (-cp) during compilation
RUN javac -d bin -cp "lib/postgresql.jar" src/com/university/Main.java

# Stage 2: Runtime
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# Copy the compiled class files and the library from the builder stage
COPY --from=builder /app/bin ./bin
COPY --from=builder /app/lib ./lib

# Run the application
# We must include the 'bin' folder and the 'postgresql.jar' in the classpath
ENTRYPOINT ["java", "-cp", "bin:lib/postgresql.jar", "com.university.Main"]