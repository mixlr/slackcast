def notifySlack(event) {
  if (env.CHANGE_URL) {
    suffix = "<${env.CHANGE_URL}|${env.JOB_NAME}>: (<${env.BUILD_URL}|#${env.BUILD_ID}>)"
  } else {
    suffix = "<${env.GIT_URL}|${env.JOB_NAME}> (<${env.BUILD_URL}|#${env.BUILD_ID}>)"
  }

  channel = 'jenkins'

  switch(event) {
    case "started":
      message = ":building_construction: Building ${suffix}"
      color   = "#cccccc"
      break
    case "success":
      message = ":jenkins_success: Success ${suffix}"
      color   = "good"
      break
    case "failure":
      message = ":jenkins: Failure ${suffix}"
      color   = "danger"
      break
    case "aborted":
      message = ":jenkins: Aborted ${suffix}"
      color   = "danger"
      break
    case "unstable":
      message = ":jenkins: Unstable ${suffix}"
      color   = "danger"
      break
  }

  slackSend(message: message, channel: channel, color: color)
}

pipeline {
  agent {
    node {
      label 'docker'
    }
  }

  options {
    ansiColor('xterm')
  }

  environment {
    DOCKER_IMAGE = "mixlr/slackcast"
    DOCKER_TAG = "latest"
    RAILS_ENV = "test"
    RAILS_ROOT = "/src/app"
    SLACK_BOT_API_TOKEN = "foobar"
    AIRBRAKE_PROJECT_ID = "DUMMY"
    AIRBRAKE_PROJECT_KEY = "DUMMY"
  }

  stages {
    stage('Build') {
      steps {
        notifySlack('started')
        sh "docker build \
          --build-arg rails_root=${env.RAILS_ROOT} \
          --build-arg rails_env=${env.RAILS_ENV} \
          -t ${env.DOCKER_IMAGE}:${env.DOCKER_TAG} ."
      }
    }

    stage('Test') {
      steps {
        sh "docker run --rm \
          -v \"${env.WORKSPACE}/spec/\":\"${env.RAILS_ROOT}/spec/\" \
          -e RAILS_ENV=\"${env.RAILS_ENV}\" \
          -e SLACK_BOT_API_TOKEN=\"${env.SLACK_BOT_API_TOKEN}\" \
          ${env.DOCKER_IMAGE}:${env.DOCKER_TAG} rspec --colour --tty \
          --format doc \
          --format RspecJunitFormatter --out spec/report.xml"
      }

      post {
        always   { junit("spec/report.xml") }
        success  { notifySlack('success') }
        failure  { notifySlack('failure')  }
        unstable { notifySlack('unstable') }
        aborted  { notifySlack('aborted')  }
      }
    }
  }
}
