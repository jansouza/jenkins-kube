Jenkins - Pipeline for Kubernetes on IBM Cloud
=========

Build
--------------

  ### Docker

  ```
  docker build -t jenkins .
  docker run -dit --name jenkins -p 32777:8080 -p 32776:50000 --env JENKINS_ADMIN_ID=admin --env JENKINS_ADMIN_PASSWORD=password jenkins

  ```

  ### DockerHub

  ```
  docker build -t jansouza/jenkins-kube .
  docker push jansouza/jenkins-kube:latest

  ```

  ### Kubernetes

  ```
  # Create Jenkins Secret
  PASSWD=$(date +%s | sha256sum | base64 | head -c 32 ; echo)
  echo $PASSWD
  kubectl create secret generic jenkins-secret --from-literal=JENKINS_ADMIN_ID=admin --from-literal=JENKINS_ADMIN_PASSWORD=$PASSWD

  # Create Persistent Volume Claims
  kubectl create -f k8s/jenkins-pvc.yaml

  # Create Jenkins Deployment
  kubectl create -f k8s/jenkins-deployment.yaml

  # Create Jenkins Service
  kubectl create -f k8s/jenkins-service.yaml

  ```

Author Information
------------------

Jan Souza
