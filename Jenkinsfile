pipeline{
    agent any
    stages{
        stage('git checkout'){
            steps{
                git branch: 'feature', url: 'https://github.com/aman-mayank/spring-boot-docker-app.git'
            }
        }
    }
}