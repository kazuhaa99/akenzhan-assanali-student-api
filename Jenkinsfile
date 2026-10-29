pipeline {
    agent any

    environment {
        STUDENT_NAME = 'Akenzhan Assanali'
        IMAGE_NAME   = 'akenzhan-assanali-student-api'
        IMAGE_TAG    = 'v1.0-akenzhan-assanali'
    }

    triggers {
        pollSCM('H/2 * * * *')
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Student: ${STUDENT_NAME}"
                checkout scm
                sh 'git log --oneline -5'
            }
        }

        stage('Build') {
            steps {
                sh 'chmod +x gradlew'
                sh './gradlew clean bootJar -x test --no-daemon'
            }
        }

        stage('Test') {
            steps {
                sh './gradlew test --no-daemon'
            }
            post {
                always {
                    junit 'build/test-results/test/*.xml'
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Verify') {
            steps {
                sh "docker image inspect ${IMAGE_NAME}:${IMAGE_TAG} --format 'Image {{.RepoTags}} created {{.Created}} size {{.Size}} bytes'"
                sh "docker images ${IMAGE_NAME}"
            }
        }
    }

    post {
        success {
            echo "Pipeline for ${STUDENT_NAME} finished successfully: ${IMAGE_NAME}:${IMAGE_TAG}"
        }
        failure {
            echo "Pipeline for ${STUDENT_NAME} FAILED - see the stage logs above"
        }
    }
}
