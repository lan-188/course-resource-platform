# ========== 构建阶段 ==========
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# 先复制 pom.xml，利用 Docker 缓存层加速构建
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 复制源码并构建
COPY src ./src
RUN mvn clean package -DskipTests -B

# ========== 运行阶段 ==========
FROM eclipse-temurin:21-jre
WORKDIR /app

# 从构建阶段复制 JAR
COPY --from=build /app/target/teaching-platform-1.0.0.jar app.jar

# 创建上传目录
RUN mkdir -p /tmp/uploads

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar", "--spring.profiles.active=prod"]
