@Library("jenkins-pipeline-library") _

pipeline {
    agent { label 'skynet' }
    options {
        timeout(time: 2, unit: 'HOURS')
    }
    environment {
        JAVA_HOME = '/usr/lib/jvm/java-1.8.0'
        SKYNET_APP = 'kube-applier'
    }
    parameters {
        string(name: "BUILD_NUMBER", defaultValue: "", description: "Replay build value")
    }
    stages {
        stage('Build') {
            steps {
                githubCheck(
                    'Build Image': {
                        buildImage()
                        echo "Just built image with id ${builtImage.imageId}"
                    }
                )
            }
        }
        stage('Deploy to DSV31') {
            when { branch 'master' }
            steps {
                deploy cluster: 'dsv31', app: SKYNET_APP
            }
        }
        stage('End to End Test DSV31') {
            when { branch 'master' }
            steps {
                sh './e2e-test.sh applier.octoproxy.dsv31.boxdc.net'
            }
        }
        stage('Deploy to LV7') {
            when { branch 'master' }
            steps {
                deploy cluster: 'lv7', app: SKYNET_APP
            }
        }
        stage('Deploy to VSV1') {
            when { branch 'master' }
            steps {
                deploy cluster: 'vsv1', app: SKYNET_APP
            }
        }
        stage('Deploy to VE') {
            when { branch 'master' }
            steps {
                deploy cluster: 've', app: SKYNET_APP
            }
        }
    }
    post {
        always {
            slackBuildNotify to: "@${thisBuild.gitInfo.authorLogin}"
            slackBuildNotify to: '#eng-skynet-team', onlyWhenFailed: true, onlyWhenFixed: true, onlyWhenBranchIsMaster: true
        }
    }
}
