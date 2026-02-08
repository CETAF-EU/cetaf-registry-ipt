FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /build

# Copy everything needed for the build
COPY . .

# Build (skip tests)
RUN mvn -B -DskipTests package

# ===== Run =====
FROM tomcat:9.0-jdk17-temurin

ENV IPT_DATA_DIR=/srv/ipt

RUN rm -rf /usr/local/tomcat/webapps/* \
 && mkdir -p /srv/ipt

COPY --from=build /build/target/*.war /usr/local/tomcat/webapps/ROOT.war

VOLUME ["/srv/ipt"]
EXPOSE 8080
CMD ["catalina.sh", "run"]