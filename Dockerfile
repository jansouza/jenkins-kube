FROM jenkins/jenkins:lts

ENV TZ='America/Sao_Paulo'

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /usr/share/jenkins/casc.yaml
COPY conf/casc.yaml /usr/share/jenkins/casc.yaml

#Install Plugins
COPY conf/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

USER root

# Install Maven
RUN apt-get update && apt-get install -y maven

#IBM Client
RUN curl -fsSL https://clis.cloud.ibm.com/install/linux | sh
RUN ibmcloud --version \
  && ibmcloud config --check-version=false \
  && ibmcloud plugin install -f kubernetes-service \
  && ibmcloud plugin install -f container-registry

#Docker
ENV DOCKERVERSION=18.03.1-ce
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
                 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

#Kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl
