pipeline{
    agent any
    stages{
        stage('Setup image, test and build'){
            steps{
                script{
                    docker.image('node:10').inside('-u root --privileged'){
                sh 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && echo \'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main\' | tee /etc/apt/sources.list.d/google-chrome.list'
                sh 'apt-get update -y && apt-get upgrade -y'
                sh 'apt-get install python google-chrome-stable -y'
                sh 'export CHROME_BIN=\'/usr/bin/google-chrome-stable\''
                sh 'npm install'
                sh 'npm run postinstall'
                sh 'npm run e2e'
                sh 'npm run build --prod'
                }
            }
        }
    }

        stage('Deploy'){
            steps{
                script{
                    docker.withRegistry('', 'docker_id'){
                    def image = docker.build("enimal/nginx-test", "-f dockerfile_jenkins .")
                    sh 'docker push enimal/nginx-test:latest'
                            }
                        }
                    }
                }
            }
        }
    