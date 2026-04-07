pipeline {
    agent { label "OneS" }
    stages {
        stage('Выгрузка конфигурации из хранилища') {
            steps {
                script {
                    env.releaseBase = "VAStoma"
                    env.dumpPathRelease = "${env.WORKSPACE}/src"
                    bat """
                    chcp 65001
                    @call vrunner session kill --db ${env.releaseBase} --db-user Админ --db-pwd "" --v8version "${env.VERSION_PLATFORM}" --uccode BUILDER
                    @call vrunner loadrepo --storage-name ${env.repository} --storage-user ${env.VATest2} --ibconnection /Slocalhost/${env.releaseBase} --db-user Админ --db-pwd "" --v8version "${env.VERSION_PLATFORM}" --uccode BUILDER
                    @call vrunner updatedb --ibconnection /Slocalhost/${env.releaseBase} --db-user Админ --db-pwd "" --v8version "${env.VERSION_PLATFORM}" --uccode BUILDER
                    @call vrunner decompile --out ${env.dumpPathRelease} --current --ibconnection /Slocalhost/${env.releaseBase} --db-user Админ --v8version "${env.VERSION_PLATFORM}" --uccode BUILDER
                    """
                }
            }
        }  
    }
}

        // stage('Создание .cf файла') {
        //     steps {
        //         script {
        //           bat """
        //           chcp 65001
        //           vrunner compile --src ./src --out "./cf/${new_version}.cf" --v8version "${env.VERSION_PLATFORM}"
        //           """
        //         }
        //     }
        // }  