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
    CONTAINER_NAME = 'mixlr/slackcast'

    RAILS_ENV = 'test'
    SLACK_BOT_API_TOKEN = 'foobar'
    AIRBRAKE_PROJECT_ID = 'DUMMY'
    AIRBRAKE_PROJECT_KEY = 'DUMMY'

    REPORT_PATH = 'spec/report.xml'
  }

  stages {
    stage('Build') {
      steps {
        notifySlack('started')

        sh "docker build -t ${env.CONTAINER_NAME} ."
      }
    }

    stage('Test') {
      steps {
        sh "docker run --rm \
          -v \"${env.WORKSPACE}\":/srv/app/ \
          -e RAILS_ENV=\"${env.RAILS_ENV}\" \
          -e SLACK_BOT_API_TOKEN=\"${env.SLACK_BOT_API_TOKEN}\" \
          ${env.CONTAINER_NAME} rspec --colour --tty --format doc \
          -r rspec_junit_formatter --format RspecJunitFormatter -o \"${env.REPORT_PATH}\""
      }

      post {
        always   { junit("${env.REPORT_PATH}") }
        success  { notifySlack('success') }
        failure  { notifySlack('failure')  }
        unstable { notifySlack('unstable') }
        aborted  { notifySlack('aborted')  }
      }
    }
  }
}
