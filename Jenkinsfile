pipeline {
  agent any

  options {
    timestamps()
    ansiColor('xterm')
    buildDiscarder(logRotator(numToKeepStr: '20'))
  }

  environment {
    DOCKERHUB = credentials('dockerhub-creds')   // exposes DOCKERHUB_USR / DOCKERHUB_PSW
    APP_NAME  = 'aws-eb-express-sample'
    IMAGE     = "docker.io/${DOCKERHUB_USR}/${APP_NAME}:${BUILD_NUMBER}"
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Install dependencies') {
      steps { sh 'npm install --save' }
    }

    stage('Vulnerability scan (fail on High/Critical)') {
      steps { sh 'npm audit --production --audit-level=high' }
    }

    stage('Docker build') {
      steps {
        sh '''
          echo "$DOCKERHUB_PSW" | docker login -u "$DOCKERHUB_USR" --password-stdin
          docker build -t "$IMAGE" .
        '''
      }
    }

    stage('Docker push') {
      steps {
        sh 'docker push "$IMAGE"'
        echo "Pushed: $IMAGE"
      }
    }
  }

  post {
    always { archiveArtifacts artifacts: 'npm-debug.log,*.log', allowEmptyArchive: true }
  }
}
