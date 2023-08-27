FROM maven as build
WORKDIR /app
COPY . . 
RUN mvn install

FROM openjdk:11
WORKDIR /app
COPY --from=build /app/target/spring-boot-docker-app.jar /app/
EXPOSE 9090
CMD ["java","-jar","spring-boot-docker-app.jar"]
ENTRYPOINT ["java", "-jar", "spring-boot-docker-app.jar"]
