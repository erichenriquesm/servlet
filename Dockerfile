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

RUN javac -cp lib/jakarta.servlet-api-6.0.0.jar -d out/WEB-INF/classes src/servlets/HelloServlet.java

RUN cp web/WEB-INF/web.xml out/WEB-INF/

# Ao rodar o container, já compila automaticamente
ENTRYPOINT ["sh", "-c", "javac -cp lib/jakarta.servlet-api-6.0.0.jar -d out/WEB-INF/classes src/servlets/HelloServlet.java && cp web/WEB-INF/web.xml out/WEB-INF/ && bash"]

