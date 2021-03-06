1. 编译nodejs项目

解决`/usr/bin/env: node: No such file or directory`的问题

```bash
ln -s /opt/tools/node-v12.13.0-linux-x64/bin/node /usr/bin/node
ln -s /opt/tools/node-v12.13.0-linux-x64/bin/npm /usr/bin/npm
npm install -g cnpm --registry=https://registry.npm.taobao.org
ln -s /opt/tools/node-v12.13.0-linux-x64/bin/cnpm /usr/bin/cnpm
```

```groovy
node {
    def nodeHome
    def buildNumber = ${env.BUILD_NUMBER}
    def buildJob = ${env.JOB_NAME}
    def workDir = '${buildJob}/${buildNumber}'
    stage('Check Out Gitee Code'){
        dir('${workDir}'){
            git branch: "master" , credentialsId: "chensj-gitee-key" , url: 'https://gitee.com/ssgj-winning/mbk-vue.git'
        }
        nodeHome = tool 'node-v10.16.3-linux-x64'
    }
    stage('Install Dependecy'){
         withEnv(["NODE_HOME=$nodeHome"]) {
             dir('${workDir}'){
                 if (isUnix()) {
                     sh 'cnpm install'
                 }else {
                     bat 'cnpm install'
                 }
             }
         }
    }
    stage('Build Node Project'){
        withEnv(["NODE_HOME=$nodeHome"]) {
           dir('${workDir}'){
               if (isUnix()) {
                    sh '"$NODE_HOME/bin/npm" run build'
                 } else {
                    bat(/"%$NODE_HOME%\bin\npm" run build/)
                 }
           }
            
        }
    }
    stage('Zip'){
        withEnv(["NODE_HOME=$nodeHome"]) {
           dir('${workDir}'){
               if (isUnix()) {
                    sh 'cd mbk && zip -r mbk.zip ./*'
                 } else {
                    bat(/"%$NODE_HOME%\bin\npm" run build/)
                 }
           }
            
        }
    }
    // 归档 
    stage('Artifacts'){
        dir('${workDir}'){
        	archiveArtifacts 'mbk/*.zip'
        }
    }
    // 清理工作空间
    stage('Clean Workspace'){
        cleanWs()
    }
    
}
```

