pipeline {

    agent { label "OneS" }
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
            sshagent(credentials: ['keygen']) {
                sh 'git push git@github.com:Helix-QA/stoma1c.git HEAD:main'
            }
        }
}  
}
