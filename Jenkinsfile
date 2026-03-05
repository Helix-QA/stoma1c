pipeline {

    agent { label "OneS" }
    environment {
       STORAGE_CREDS = credentials('userRelis')
    }
    stages {
        stage('Синхронизация с релизным хранилищем') {
            parallel {
                stage('Инициализация') {
                    steps {
                        bat """
                        chcp 65001
                        set GITSYNC_V8VERSION=${env.VERSION_PLATFORM}
                        gitsync init ^
                            --storage-user ${STORAGE_CREDS_USR} ^
                            --storage-pwd ${STORAGE_CREDS_PSW} ^
                            ${env.repositoryReleaseStom} ./cf
                        """
                    }
                }
                stage('Синхронизация хранилища 1С с git-репозиторием') {
                    steps {
                        bat """
                        chcp 65001
                        gitsync --v8version ${env.VERSION_PLATFORM} sync 
                        ${env.repositoryReleaseStom} ./cf
                        """
                    }
                }
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
}