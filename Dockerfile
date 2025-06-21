FROM openjdk:17-slim

WORKDIR /app

RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

RUN mkdir -p src/servlets \
    && mkdir -p web/WEB-INF \
    && mkdir -p out/WEB-INF/classes \
    && mkdir -p lib

COPY src/ src/
COPY web/ web/

RUN wget https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/6.0.0/jakarta.servlet-api-6.0.0.jar -P lib

# Compila todos os .java dentro de src/ recursivamente
RUN find src -name "*.java" > sources.txt && \
    javac -cp lib/jakarta.servlet-api-6.0.0.jar -d out/WEB-INF/classes @sources.txt

RUN cp web/WEB-INF/web.xml out/WEB-INF/

# Ao rodar o container, compila tudo novamente
ENTRYPOINT ["sh", "-c", "find src -name '*.java' > sources.txt && javac -cp lib/jakarta.servlet-api-6.0.0.jar -d out/WEB-INF/classes @sources.txt && cp web/WEB-INF/web.xml out/WEB-INF/ && bash"]
