#!/usr/bin/env groovy

properties([
  parameters([
    booleanParam(defaultValue: false, description: 'Enable deployment', name: 'deploy_enabled'),
    booleanParam(defaultValue: false, description: 'Destroy infrastructure', name: 'destroy_enabled')
  ])
])

def podDefinition = """
apiVersion: v1
kind: Pod
spec:
  nodeSelector:
    env: dev
  containers:
  - name: iac-tools
    image: 'ecr----URL/hcm/iac-tools:v1.0.2'
    imagePullPolicy: Always
    tty: true
    command:
    - 'cat'
"""

lock(resource: "terraform-vra-vm") {
    podTemplate(yaml: podDefinition) {
        node(POD_LABEL) {
            timestamps {
                ansiColor('xterm') {
                    container("iac-tools") {
                        try {
                            stage('Setup environment') {
                                deleteDir()
                                checkout scm
                            }
                            stage("vRA-Jenkins-Connection-check") {
                                withCredentials([usernamePassword(credentialsId: "vra", usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]){
                                  deploy_infrastructure("dev")
                                }
			     
                            }
                        } catch (err) {
                            throw (err)
                        }
                    }
                }
            }
        }
    }
}

def deploy_infrastructure(def environment) {
  env.TARGET_ENV = environment

  stage("Terraform Init") {
    sh "make terraform-init"
  }

  stage("Terraform Validate") {
    sh "make terraform-validate"
  }
  
  if (params.destroy_enabled) {
    stage("Terraform Plan") {
      sh "make terraform-plan-destroy"
    }

    stage("Terraform Destroy") {
      sh "make terraform-destroy"
    }
  } else {
    stage("Terraform Plan") {
      sh "make terraform-plan"
    }

    if (params.deploy_enabled) {
      try {
        stage("Terraform Apply") {
          sh "make terraform-apply"
        }
      } catch (err) {
        echo "TERRAFORM APPLY FAILED. PLEASE CHECK THE BUILD LOGS"
        throw (err)
      }
    }
  }
​}
