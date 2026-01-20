# Vault integration with jenkins

## Approle auth 생성

```sh
# create approle jenkins-role
$ vault write auth/approle/role/jenkins-role \
  token_ttl=20m \
  token_max_ttl=60m \
  token_policies="secret-read-only"

# get role-id
$ vault read auth/approle/role/jenkins-role/role-id
Key        Value
---        -----
role_id    ****************

# create secret-id
$ vault write -force auth/approle/role/jenkins-role/secret-id
Key                   Value
---                   -----
secret_id             ****************
secret_id_accessor    af571548-eb24-4674-21a1-b1aca7e325aa
secret_id_num_uses    0
secret_id_ttl         0s
```

## Vault plugin 방식

> HashiCorp Vault Plugin, Pipeline Utility Steps 설치

### Credential 등록

```
1. Vault App Role Credential
2. Vault Token Credential
```

### Pipeline example

```groovy
pipeline {
    agent any
    environment {
        // Vault URL 설정
        VAULT_ADDR = 'https://vault.club012.com'
        // Jenkins Credentials에 저장한 AppRole Credential ID
        VAULT_CREDS = 'pi-vault-app' // credentials('pi-vault-app') 
    }
    stages {
        stage('Vault AppRole Login via Plugin') {
            steps {
                withVault([
                    vaultSecrets: [
                        [  
                            path: 'secret/vault-secret/local',
                            engineVersion: 2,
                            secretValues: [
                                [envVar: 'DATASOURCE_URL', vaultKey: 'spring.datasource.url']
                            ]
                        ]
                    ],
                    configuration: [
                        vaultUrl: "${VAULT_ADDR}",
                        vaultCredentialId: "${VAULT_CREDS}"
                    ]
                ]) {
                    sh '''
                    env
                    echo "Url from Vault: $DATASOURCE_URL"
                    echo "Token from Vault: $VAULT_TOKEN"
                    '''
                    script {
                        echo "Url (env): ${env.DATASOURCE_URL}"
                        echo "Token (env): ${env.VAULT_TOKEN}"
                    }
                }
            }
        }
    }
}
```

## Vault API 방식

> Approle role_id, secret_id를 이용하여 Token 생성

### Credentai 등록

> Username and password credential 등록

### Pipeline example

```groovy
pipeline {
    agent any
    stages {
        stage('Preparation') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'vault-approle-cred', usernameVariable: 'ROLE_ID', passwordVariable: 'SECRET_ID')]) {
                        // The variables 'ROLE_ID' and 'SECRET_ID' are available here
                        sh '''
                            echo "ROLE_ID: $ROLE_ID"
                            echo "SECRET_ID: $SECRET_ID"
                            # set +x
                            # curl -s -X POST https://vault.club012.com/v1/auth/approle/login \
                            #      -d '{\"role_id\":\"'${ROLE_ID}'\",\"secret_id\":\"'$SECRET_ID'\"}'
                        '''
                        def jsonResponseString = sh(script: "curl -s -X POST https://vault.club012.com/v1/auth/approle/login \
                                 -d '{\"role_id\":\"'${ROLE_ID}'\",\"secret_id\":\"'$SECRET_ID'\"}'", returnStdout: true).trim()
                        def jsonData = readJSON(text: jsonResponseString)
                        echo "The value of a specific field is: ${jsonData.auth.client_token}"
                    }// withCredentials
                }// script
            }// steps
        }// stage
    }// stages
}// pipeline
```
