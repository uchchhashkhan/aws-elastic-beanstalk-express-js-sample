pipeline {
  agent { docker { image 'node:16' } }   // use Node 16

  environment {
    DOCKERHUB = credentials('dockerhub-creds')   // set this in Jenkins once
    APP_NAME  = 'aws-eb-express-sample'
    IMAGE     = "docker.io/${DOCKERHUB_USR}/${APP_NAME}:${BUILD_NUMBER}"
  }

  stages {
    stage('Checkout'){ steps{ checkout scm } }
    stage('Install'){  steps{ sh 'npm install --save' } }
    stage('Scan'){     steps{ sh 'npm audit --production --audit-level=high' } } // fail on High/Critical
    stage('Build'){    steps{
      sh 'echo "$DOCKERHUB_PSW" | docker login -u "$DOCKERHUB_USR" --password-stdin'
      sh 'docker build -t "$IMAGE" .'
    }}
    stage('Push'){     steps{ sh 'docker push "$IMAGE"' } }
  }
}
