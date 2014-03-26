#!/bin/bash

#ansible version cmd
ANSIBLE_VERSION_CHECK="ansible --version"

#ping google.com url for Net connectiving connection
GOOGLE_CON_CHECK="ping google.com -c 2"

#Net success msg
NET_SUCCESS="Net Connection is success"

#Net Failure msg
NET_FAILURE="Problem with Net connection"

#Ansible Suc msg
ANSIBLE_SUC_MSG="Ansible already installed"

#Ansible Failure msg
ANSIBLE_FAILURE_MSG="Ansible not installed"

#Ansible Remove Msg
ANSIBLE_REMOVE_MSG="Ansible Folder Exists. Deleting the existing folder before cloning from git"

ANSIBLE_FOLDER_NOT_EXIST="Ansible Folder not exists"

#Ansible Config Msg
Ansible_CONFIG_MSG="Ansible folder not exists"

#Ansible Base Path
ANSIBLE_BASE_PATH="/opt"

#Ansible Git URL
ANSIBLE_GIT_URL="git://github.com/ansible/ansible.git"

#PIP Install command
PIP_INSTALL="pip"

# Python dependencies
PYTHON_DEPS="paramiko PyYAML jinja2 httplib2"

#Ansible Path
ANSIBLE_PATH="$ANSIBLE_BASE_PATH/ansible"

CLUSTER_CONFIG_PATH="$HOME/test"
CLUSTER_CONFIG_REPO="git://github.com/raghavakumar/ansible-clusterconfig.git"

CLUSTER_CONFIG_FOLDER_PATH="$CLUSTER_CONFIG_PATH/ansible-clusterconfig"
CLUSTER_CONFIG_FOLDER_EXISTS="ansible-clusterconfig folder created in $CLUSTER_CONFIG_PATH"
CLUSTER_CONFIG_FOLDER_NOT_EXISTS="ansible-clusterconfig folder not created in $CLUSTER_CONFIG_PATH"


#
#checkCmdStatus
#
checkCmdStatus() {
 #echo "check cmd status"

 #passed command  as Param
 cmd=$1
 sucMsg=$2
 errMsg=$3

  output=$( {
        eval "${cmd}";
    } 2>&1; );
    errcode=$?;

  if [[ "$errcode" -ne 0 ]]; then
   echo "$errMsg"
   return 1
  else
   echo "$sucMsg"
   return 0
  fi
}

#
#Verify Net connection
#

verifyNetConnection() {
 echo "verify net connection"

 checkCmdStatus "$GOOGLE_CON_CHECK" "$NET_SUCCESS" "$NET_FAILURE"
 errorResponse=$?

 if [[ "$errorResponse" -ne 0 ]]; then 
  exit 999
 fi
 
}

#
#Verify whether Ansible already installed. If not install/configure ansible
#
verifyansiblestatus() {

  checkCmdStatus "$ANSIBLE_VERSION_CHECK" "$ANSIBLE_SUC_MSG" "$ANSIBLE_FAILURE_MSG"
  errorResponse=$?

  if [[ "$errorResponse" -ne 0 ]]; then
   configureAnsible
  #else
  # exit 999
  fi
}

#
#Delete existing /opt/ansible folder if already exists
#
deleteAnsibleSource() {
 #echo "delete existing folder"

 if [ -d $ANSIBLE_PATH ]; then
   echo "$ANSIBLE_REMOVE_MSG"
   sudo /bin/rm -rf $ANSIBLE_PATH
 else
   echo "$ANSIBLE_FOLDER_NOT_EXIST"
 fi
}

#
# Configure Ansible from git repo
#

configureAnsible() {
 #echo "configure ansible here"
 deleteAnsibleSource

 cloneAnsible=`cd $ANSIBLE_BASE_PATH && sudo git clone $ANSIBLE_GIT_URL`
 pipInstall=`sudo easy_install $PIP_INSTALL && sudo apt-get install git && sudo pip install $PYTHON_DEPS`
 chgPermission=`sudo chown -R $USER:$USER $ANSIBLE_PATH`
 envSetup=`source $ANSIBLE_PATH/hacking/env-setup`

 envVar=`sudo bash -c "echo 'source $ANSIBLE_PATH/hacking/env-setup' >> $HOME/.bashrc"`
 
 verifyAnsibleAfterInstall
}

#
#Verify Ansible after successful configuration
#
verifyAnsibleAfterInstall() {
  
  checkCmdStatus "$ANSIBLE_VERSION_CHECK" "$ANSIBLE_SUC_MSG" "$ANSIBLE_FAILURE_MSG"
  errorConfigResponse=$?

  if [[ "$errorConfigResponse" -ne 0 ]]; then
   echo "Ansible Not configured properly. Contact Administrator"
  fi

}

#
#Clone ClusterConfig Git Repo after installing/verifying Ansible status
#
cloneClusterConfig() {

 echo "Cloning cluster-config git repo to $CLUSTER_CONFIG_FOLDER_PATH"

 if [ -d $CLUSTER_CONFIG_FOLDER_PATH ]; then
   sudo /bin/rm -rf $CLUSTER_CONFIG_FOLDER_PATH
 fi

 # clone cluster config repo
 cloneClusterConfig=`cd $CLUSTER_CONFIG_PATH && sudo git clone $CLUSTER_CONFIG_REPO`

 if [ -d $CLUSTER_CONFIG_FOLDER_PATH ]; then
   echo "$CLUSTER_CONFIG_FOLDER_EXISTS"
 else
   echo "$CLUSTER_CONFIG_FOLDER_NOT_EXISTS"
 fi
}

#verify internet connectivity
verifyNetConnection

#verify whether ansible configured in control machine
verifyansiblestatus

#clone ansible-clusterconfig from git repo
cloneClusterConfig
