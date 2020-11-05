# Tomcat Docker 빌드

- [openjdk](https://hub.docker.com/_/openjdk) 1.8.0_272-b10
- [apache-tomcat](http://tomcat.apache.org/) 9.0.39
- [jpetsore](https://github.com/mybatis/jpetstore-6) 6

## 1. Docker 컨테이너 이미지 생성하기

### 1.1 Dockerfile 생성
```
FROM openjdk:8

USER root
LABEL MAINTAINER="shkim@rockplace.co.kr"

ARG CATALINA_MAJOR_VER=9
ARG CATALINA_VERSION=9.0.39 
ENV CATALINA_HOME=/usr/local/apache-tomcat-${CATALINA_VERSION} \
    CATALINA_BASE=${CATALINA_HOME}

ADD https://downloads.apache.org/tomcat/tomcat-${CATALINA_MAJOR_VER}/v${CATALINA_VERSION}/bin/apache-tomcat-${CATALINA_VERSION}.tar.gz /usr/local

RUN cd /usr/local && tar -xf apache-tomcat-${CATALINA_VERSION}.tar.gz -C /usr/local && rm -f apache-tomcat-${CATALINA_VERSION}.tar.gz \
    && useradd -u 1000 -G root tomcat && chown -R tomcat:root ${CATALINA_HOME}

WORKDIR $CATALINA_HOME

USER 1000

EXPOSE 8080
EXPOSE 8009 
 
ENTRYPOINT ["./bin/catalina.sh","run"]
```

### 1.2 Docker 빌드하기
```
#!/usr/bin/env bash
docker build -t rockplace/tomcat:9 .
```

### 1.3 Docker 컨테이너 실행하기
```
docker run --rm -p 8080:8080 rockplace/tomcat:9
```
### 1.4 Docker 컨테이너 실행 확인하기
```
http://localhost:8080
```
![tomcat](./images/tomcat.png)

## 2. Spring 프레임워크 데모 빌드하기
```
git clone https://github.com/mybatis/jpetstore-6.git

docker run -v "${PWD}:/usr/app/myapp" -v "${PWD}/m2/:/root/.m2/" -w /usr/app/myapp maven:3-jdk-8 ./mvnw clean package
```

## 3. Spring 프래임워크 데모 Docker 컨테이너에 배포하기
### 3.1 빌드된 Spring 프레임워크 를 Tomcat 배포디렉토리로 복사
> jpetstore.war 파일을 docker 빌드 디렉토리로 복사후 진행
```
ADD jpetstore.war $CATALINA_HOME/webapps/
```
### 3.2 빌드가 불가능한 환경은 빌드된 버전을 다운로드
```
ADD https://github.com/nationminu/tomcat-docker-build-demo/blob/master/jpetstore.war $CATALINA_HOME/webapps/
```
### 3.2 변경된 내용을 적용하기 위해 Docker 빌드를 다시 실행
```
docker build -t rockplace/tomcat:9 .
```
### 3.3 Docker 컨테이너 실행하기
```
docker run --rm -p 8080:8080 rockplace/tomcat:9
```
### 3.4 Docker 컨테이너 실행 확인하기
```
http://localhost:8080/jpetstore
```
![demo1](./images/demo1.png)
![demo2](./images/demo2.png)