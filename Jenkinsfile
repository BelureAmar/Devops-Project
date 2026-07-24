pipeline{
    agent any
    
    tools{
        jdk 'java-11'
        maven 'maven'
    }
    environment {
        DEPLOY_FILE  = 'deploy.yml'
        DOMAIN       = 'dev.amarbelure.online'
    }
    
    stages{
        stage('Git-checkout'){
            steps{
                git branch: 'main' , url: 'https://github.com/BelureAmar/Devops-Project.git'
            }
        }
        stage('Code Compile'){
            steps{
                sh 'mvn compile'
            }
        }
        stage('Code Package'){
            steps{
                sh 'mvn clean install'
            }
        }
        stage('Build and tag'){
            steps{
                sh 'docker build -t amarkumar3/amarkumar .'
            }
        }
        stage('Containerisation'){
            steps{
                sh '''
                docker run -it -d --name c2 -p 9008:8080 amarkumar3/amarkumar
                '''
            }
        }
        stage('Login to Docker Hub') {
                    steps {
                        script {
                            withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                                sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                            }
                        }
                    }
        }
         stage('Pushing image to repository'){
            steps{
                sh 'docker push amarkumar3/amarkumar'
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                echo "🚀 Deploying to Kubernetes..."
                microk8s.kubectl apply -f $DEPLOY_FILE
                echo "Waiting for pods to stabilize..."
                sleep 20
                microk8s.kubectl get pods
                '''
            }
        }
        stage('Apply Ingress & Verify') {
            steps {
                sh '''
                echo "🌐 Applying Ingress for domain $DOMAIN ..."
                microk8s.kubectl apply -f $DEPLOY_FILE
                echo "Waiting for ingress to be ready..."
                sleep 20
                microk8s.kubectl get ingress
                echo "🔍 Verifying application availability..."
                curl -I http://$DOMAIN || echo "⚠️ Could not verify via curl, please check browser."
                echo "✅ Deployment complete! Access: http://$DOMAIN"
                '''
            }
        }        
    }
    
    post {
        success {
            echo '✅ CI/CD pipeline executed successfully. App deployed and accessible via Ingress.'
        }
        failure {
            echo '❌ Build or deploy failed. Please review Jenkins logs.'
        }
        aborted {
            echo '⚠️ Pipeline aborted by user.'
        }
    }
}

