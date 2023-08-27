pipeline{
    agent any
    stages{
        stage('git checkout'){
            steps{
                git branch: 'feature', url: 'https://github.com/aman-mayank/spring-boot-docker-app.git'
            }
        }
      
        stage('unit testing'){
            steps{
                sh 'mvn test'
            }
        }
  
        stage('integration testing'){
            steps{
                sh 'mvn verify -DskipUnitTests'
            }
        }

        stage('maven build'){
            steps{
                sh 'mvn clean install'
            }
        }

        stage('static code analysis'){
            steps{
                withSonarQubeEnv('sonarserver') {
             	sh "mvn sonar:sonar"
              }
            }
        }

        stage('quality gate status check'){
            steps{
                waitForQualityGate abortPipeline: false, credentialsId: 'sonartoken'
            }
        }
    }
}