# Image de base Java 17 légère
FROM eclipse-temurin:17-jdk-alpine

# Argument : chemin du JAR généré par Maven
ARG JAR_FILE=target/student-management-0.0.1-SNAPSHOT.jar

# Répertoire de travail à l’intérieur du conteneur
WORKDIR /app

# Copier le jar dans le conteneur
COPY ${JAR_FILE} app.jar

# Exposer le port Spring Boot
EXPOSE 8080

# Commande de démarrage
ENTRYPOINT ["java", "-jar", "app.jar"]
