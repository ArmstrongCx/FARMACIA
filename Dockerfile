# ---------- Etapa 1: Build del proyecto con Maven ----------
FROM maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR /app

# Copiar archivos necesarios para descargar dependencias
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiar el resto del código
COPY src ./src

# Construir el JAR (sin correr los tests)
RUN mvn clean package -DskipTests

# ---------- Etapa 2: Imagen final ----------
FROM eclipse-temurin:21-jdk-alpine

WORKDIR /app

# Copiar el JAR compilado
COPY --from=build /app/target/*.jar app.jar

# Exponer el puerto que usará Spring Boot
EXPOSE 8080

# Comando de inicio
ENTRYPOINT ["java", "-jar", "app.jar"]
