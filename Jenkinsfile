pipeline {
    agent { label "OneS" }
    stages {
        stage('Выгрузка конфигурации из хранилища') {
            steps {
                script {
                    env.releaseBase = "VAStoma"
                    env.dumpPathRelease = "${env.WORKSPACE}/src"
                    env.cfPath = "${env.WORKSPACE}/cf/stoma1c.cf"
                    env.repository = "http://192.168.2.16/hran1c/repository.1ccr/stomatology2_release"
                    bat """
                    chcp 65001
                    @call vrunner session kill --db ${env.releaseBase} --db-user Админ --db-pwd "" --v8version "${env.VERSION_PLATFORM}" --uccode BUILDER
                    @call vrunner loadrepo --storage-name ${env.repository} --storage-user ${env.VATest2} --ibconnection /Slocalhost/${env.releaseBase} --db-user Админ --db-pwd "" --v8version "${env.VERSION_PLATFORM}" --uccode BUILDER
                    @call vrunner updatedb --ibconnection /Slocalhost/${env.releaseBase} --db-user Админ --db-pwd "" --v8version "${env.VERSION_PLATFORM}" --uccode BUILDER
                    @call vrunner decompile --out ${env.dumpPathRelease} --current --ibconnection /Slocalhost/${env.releaseBase} --db-user Админ --v8version "${env.VERSION_PLATFORM}" --uccode BUILDER
                    @call vrunner unload "${env.cfPath}" --ibconnection /Slocalhost/${env.releaseBase} --v8version "${env.VERSION_PLATFORM}" --db-user Админ --uccode BUILDER
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