FROM nhantran/oraclejdk17
MAINTAINER Nhan Tran <tranphanquocnhan@gmail.com>

# Download and install Sonarqube
RUN wget http://downloads.sonarsource.com/sonarqube/sonarqube-5.1.1.zip

RUN unzip -d /opt sonarqube-5.1.1.zip
RUN mv /opt/sonarqube-5.1.1 /opt/sonarqube
RUN rm -f sonarqube-5.1.1.zip

RUN sed -i 's|#wrapper.java.additional.6=-server|wrapper.java.additional.6=-server|g' /opt/sonarqube/conf/wrapper.conf

RUN PASSWD=Passw0rd && sed -i -e"s/#sonar.jdbc.password=sonar/sonar.jdbc.password=$PASSWD/g" /opt/sonarqube/conf/sonar.properties
RUN sed -i 's|sonar.jdbc.url=jdbc:h2|#sonar.jdbc.url=jdbc:h2|g' /opt/sonarqube/conf/sonar.properties
RUN sed -i 's|#sonar.jdbc.url=jdbc:postgresql://localhost|sonar.jdbc.url=jdbc:postgresql://${env:SONARDB_PORT_5432_TCP_ADDR}|g' /opt/sonarqube/conf/sonar.properties
RUN cat /opt/sonarqube/conf/sonar.properties
EXPOSE 9000

CMD ["/opt/sonarqube/bin/linux-x86-64/sonar.sh", "console", "/bin/bash"]
