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
                REM gitsync --v8version ${env.VERSION_PLATFORM} sync "${env.repositoryReleaseStom}" "./src"
                """
            }
        }
        stage('Создание .cf файла') {
            steps {
                script {
                  bat """
                  chcp 65001
                 REM vrunner compile --src ./src --out "./cf/${new_version}.cf" --v8version "${env.VERSION_PLATFORM}"
                  """
                }
            }
        }    
    }
    post {
        success {
            withCredentials([usernamePassword(credentialsId: 'keygen', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                sh 'git push https://${USER}:${PASS}@github.com/Helix-QA/stoma1c.git HEAD:main'
            }
        }
    }
}
