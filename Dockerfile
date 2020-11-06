FROM openjdk:8

USER root
LABEL MAINTAINER="shkim@rockplace.co.kr"

ARG CATALINA_MAJOR_VER=9
ARG CATALINA_VERSION=9.0.39 
ENV CATALINA_HOME=/usr/local/apache-tomcat-${CATALINA_VERSION} \
    CATALINA_BASE=${CATALINA_HOME}

ADD https://downloads.apache.org/tomcat/tomcat-${CATALINA_MAJOR_VER}/v${CATALINA_VERSION}/bin/apache-tomcat-${CATALINA_VERSION}.tar.gz /usr/local

RUN cd /usr/local && tar -xf apache-tomcat-${CATALINA_VERSION}.tar.gz -C /usr/local && rm -f apache-tomcat-${CATALINA_VERSION}.tar.gz \
    && useradd -u 1000 -G root tomcat && chown -R tomcat:root ${CATALINA_HOME} \
    && chmod 750 $CATALINA_HOME/conf && chmod 640 $CATALINA_HOME/conf/* \  
    && chmod 777 $CATALINA_HOME/temp $CATALINA_HOME/work $CATALINA_HOME/logs $CATALINA_HOME/webapps 

ADD jpetstore.war $CATALINA_HOME/webapps/

WORKDIR $CATALINA_HOME

USER 1000

EXPOSE 8080 
 
ENTRYPOINT ["./bin/catalina.sh","run"]
