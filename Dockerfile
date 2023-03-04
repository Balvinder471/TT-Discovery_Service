FROM maven:3-amazoncorretto-11 as build
WORKDIR /app
COPY pom.xml ./
COPY src/ ./src/
RUN mvn clean install -DskipTests

FROM amazoncorretto:11
COPY --from=build /app/target/*.jar app.jar
CMD ["java", "-jar", "app.jar"]
