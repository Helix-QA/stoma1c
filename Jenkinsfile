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
                if (env.GIT_BRANCH == 'origin/main') {
                    withCredentials([sshUserPrivateKey(
                        credentialsId: 'keygen',
                        keyFileVariable: 'SSH_KEY'
                    )]) {
                        bat '''
                        set GIT_SSH_COMMAND=ssh -i %SSH_KEY% -o StrictHostKeyChecking=no
            
                        git fetch origin
                        
                        git checkout -b main origin/main || git checkout main
                        
                        git push origin main
                        '''
                    }
                }
            }
        }
    }
}
