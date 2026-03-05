pipeline {

    agent { label "OneS" }
    environment {
       STORAGE_CREDS = credentials('userRelis')
    }
    stages {
        stage('Синхронизация с релизным хранилищем') {
            steps {
                bat """
                chcp 65001
                gitsync --v8version ${env.VERSION_PLATFORM} sync "${env.repositoryReleaseStom}" "./src"
                """
            }
        }
        stage('Создание .cf файла') {
            steps {
                script {
                  bat """
                  chcp 65001
                  vrunner compile --src ./src --out "./cf/${new_version}.cf" --v8version "${env.VERSION_PLATFORM}"
                  """
                }
            }
        }    
    }
    post {
        success {  
            script {
                if (env.BRANCH_NAME == 'main') { 
                    sshagent(credentials: ['keygen']) {
                        sh 'git push origin main'  
                    }
                }
            }
        }
    }
}
