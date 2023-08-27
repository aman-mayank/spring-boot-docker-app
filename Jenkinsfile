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
                script{
                  waitForQualityGate abortPipeline: true, credentialsId: 'sonartoken'
                }
                
            }
        }

        stage('upload artifact to nexus'){
            steps{
                script{
                  def readPomVersion = readMavenPom file: 'pom.xml'
                  def nexusRepo = readPomVersion.version.endsWith("SNAPSHOT") ? "mysnapshotrepo" : "myreleaserepo"
                  nexusArtifactUploader artifacts: 
                  [
                    [artifactId: 'spring-boot-docker-app',
                     classifier: '',
                      file: 'target/spring-boot-docker-app.jar',
                       type: 'jar'
                       ]
                    ],
                     credentialsId: 'nexus-credentials', 
                     groupId: 'com.example', 
                     nexusUrl: '54.178.216.170:8081/', 
                     nexusVersion: 'nexus3', 
                     protocol: 'http', 
                     repository: nexusRepo,
                      version: "${readPomVersion.version}"
                }
                
            }
        }
    }
}