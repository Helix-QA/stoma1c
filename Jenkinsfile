pipeline {

    agent { label "OneS" }
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
                def branch = env.BRANCH_NAME ?: 'main'   // работает и в Multibranch, и в обычном Pipeline

                withCredentials([usernamePassword(
                    credentialsId: 'git-credentials',          // ← ваш ID
                    usernameVariable: 'GIT_USERNAME',
                    passwordVariable: 'GIT_PASSWORD'
                )]) {
                    sh """
                        git checkout -B ${branch}
                        git config user.name "mishan3581"
                        git config user.email "mishan358.h@gmail.com"

                        git add .
                        if ! git diff --cached --quiet; then
                            git commit -m "Автоматический коммит от Jenkins [skip ci]"
                            
                            # Временный credential helper (без проблем со спецсимволами)
                            git config --local credential.helper "!f() { echo username=\\\${GIT_USERNAME}; echo password=\\\${GIT_PASSWORD}; }; f"
                            
                            git push origin HEAD:${branch}
                            echo "✅ Изменения закоммичены и запушены в ${branch}"
                        else
                            echo "ℹ️ Нет изменений для коммита"
                        fi
                    """
                }
            }
        } 
    }
}
