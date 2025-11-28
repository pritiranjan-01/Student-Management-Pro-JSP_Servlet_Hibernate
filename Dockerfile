# ========== 1) Build WAR ==========

FROM maven:3.9.5-eclipse-temurin-17 AS build
WORKDIR /app

COPY . .
RUN mvn clean package -DskipTests


# ========== 2) Deploy WAR to Tomcat ==========

FROM tomcat:10.1-jdk17-corretto

RUN rm -rf /usr/local/tomcat/webapps/ROOT

COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
