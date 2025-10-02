pipeline {
  agent none

  stages {
    stage('Checkout + Install + Scan') {
      agent { docker { image 'node:16' } }
      stages {
        stage('Checkout') { steps { checkout scm } }
        stage('Install')  { steps { sh 'npm install --save' } }
        stage('Scan')     { steps { sh 'npm audit --production --audit-level=high' } } // fails on High/Critical
      }
    }

    stage('Docker build & push') {
      agent { label '' }  // run on controller (has docker CLI)
      environment {
        DOCKERHUB = credentials('dockerhub-creds')
        APP_NAME  = 'aws-eb-express-sample'
        IMAGE     = "docker.io/${DOCKERHUB_USR}/${APP_NAME}:${BUILD_NUMBER}"
      }
      steps {
        sh '''
          echo "$DOCKERHUB_PSW" | docker login -u "$DOCKERHUB_USR" --password-stdin
          docker build -t "$IMAGE" .
          docker push "$IMAGE"
        '''
      }
    }
  }
}
