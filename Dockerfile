# Dockerfile
FROM eclipse-temurin:17-jdk-alpine

ARG JAR_FILE=target/*.jar

# Copy jar built by Maven
COPY ${JAR_FILE} app.jar

# Expose app port
EXPOSE 8080

# Run the jar
ENTRYPOINT ["java","-jar","/app.jar"]
