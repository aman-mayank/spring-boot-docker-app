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
                       type: 'jar']
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

         stage('create image'){
        steps{
            sh "docker build -t $JOB_NAME:v1.$BUILD_ID ." 
            sh "docker tag $JOB_NAME:v1.$BUILD_ID amanmayank97/$JOB_NAME:v1.$BUILD_ID"
            sh "docker tag $JOB_NAME:v1.$BUILD_ID amanmayank97/$JOB_NAME:latest"
        }
    }

        stage('push image to dockerhub'){
        steps{
            withCredentials([string(credentialsId: 'dockercredentials', variable: 'dockerpasswd')]) {
              sh "docker login -u amanmayank97 -p ${dockerpasswd}"
              sh "docker push amanmayank97/$JOB_NAME:v1.$BUILD_ID"
              sh "docker push amanmayank97/$JOB_NAME:latest"
           }
        }

        stage('k8s deploy'){
        steps{
            sh 'kubectl apply -f deployment.yml'
        }
    }
    }

    }
}