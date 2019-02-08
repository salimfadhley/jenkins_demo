FROM jenkins/jenkins AS jenkins
USER root
RUN apt-get install docker
RUN pip3 install docker-compose
COPY src/jenkins_tmp /tmp/jenkins_tmp
RUN install-plugins.sh docker-slaves ssh-agent
RUN rm -rf /tmp/jenkins_tmp
USER jenkins