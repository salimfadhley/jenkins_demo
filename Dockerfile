FROM jenkins/jenkins AS jenkins
USER root
RUN apt-get update -y
RUN apt-get update -y && apt-get install -y \
       python3 \
       apt-transport-https \
       ca-certificates \
       curl \
       gnupg-agent \
       software-properties-common \
       less && \
       rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) \
       stable"
RUN apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io
RUN python3 -m pip install docker-compose


COPY src/jenkins_tmp /tmp/jenkins_tmp
RUN install-plugins.sh docker-slaves ssh-agent
RUN rm -rf /tmp/jenkins_tmp
RUN usermod -a -G docker jenkins
RUN usermod -a -G sudo jenkins
RUN echo "jenkins:jenkins" | chpasswd

FROM jenkins/slave AS jenkinsslave
USER root
RUN apt-get update -y && apt-get install -y \
       apt-transport-https \
       ca-certificates \
       curl \
       gnupg-agent \
       software-properties-common \
       less && \
       rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) \
       stable"
RUN apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io