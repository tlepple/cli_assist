#!/bin/bash

export starting_dir="/app/cli_assist"

########################################################################################################
# Define Functions:
########################################################################################################

#####################################################
# Function to install jq
#####################################################

install_jq_cli() {

	#####################################################
	# first check if JQ is installed
	#####################################################
	echo "Installing jq"
	yum install -y unzip

	jq_v=`jq --version 2>&1`
	if [[ $jq_v = *"command not found"* ]]; then
	  curl -L -s -o jq "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64"
	  chmod +x ./jq
	  cp jq /usr/bin
	else
	  echo "jq already installed. Skipping"
	fi

	jq_v=`jq --version 2>&1`
	if [[ $jq_v = *"command not found"* ]]; then
	  #log "error installing jq. Please see README and install manually"
	  echo "Error installing jq. Please see README and install manually"
	  exit 1 
	fi  

}


#####################################################
# Function to install aws cli
#####################################################

install_aws_cli() {

	#########################################################
	# BEGIN
	#########################################################
	echo "BEGIN setup.sh"
	yum install -y unzip


	#####################################################
	# first check if JQ is installed
	#####################################################
	echo "Installing jq"

        jq_v=`jq --version 2>&1`
        if [[ $jq_v = *"command not found"* ]]; then
          curl -L -s -o jq "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64"
          chmod +x ./jq
          cp jq /usr/bin
        else
          echo "jq already installed. Skipping"
        fi

        jq_v=`jq --version 2>&1`
        if [[ $jq_v = *"command not found"* ]]; then
          echo "Error installing jq. Please see README and install manually"
          exit 1
        fi

	####################################################
 	# then install AWS CLI
	#####################################################
  	echo "Installing AWS_CLI"
  	aws_cli_version=`aws --version 2>&1`
  	echo "Current CLI version: $aws_cli_version"
  	if [[ $aws_cli_version = *"aws-cli"* ]]; then
    		echo "AWS CLI already installed. Skipping"
    		return
#  	fi
        else
  		curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  		unzip awscliv2.zip
  		./aws/install -i /usr/local/aws -b /usr/local/bin 
  		rm -rf aws*
  	echo "Done installing AWS CLI v2"
        fi
}

#####################################################
# Function to install standalone python 3.7.4
#####################################################
install_python37() {

   py_v=`python3.7 --version 2>&1`
   if [[ $py_v = *"command not found"* ]]; then 

	# install some tools:
	log "Install needed yum tools"
	yum groupinstall -y 'development tools'
	yum install -y zlib-dev openssl-devel sqlite-devel bzip2-devel xz-libs xz-devel wget libffi-devel cyrus-sasl-devel

	log "Install python3.7.4 from source"
	# create directory
	mkdir -p /usr/local/downloads

	# change to dir
	cd /usr/local/downloads

	# download source
	wget https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tar.xz

	# unzip and untar this file:
	xz -d Python-3.7.4.tar.xz
	tar -xvf Python-3.7.4.tar

	# change dir
	cd Python-3.7.4

	# build from source and install
	./configure --prefix=/usr/local
	make
	make altinstall

	# Update PATH and re-initialize
	log "Update PATH for python3"
	sed -i '/^PATH=/ s/$/:\/usr\/local\/bin/' ~/.bash_profile

	log "source bash_profile"
	source ~/.bash_profile

	# change back to start directory
	cd $starting_dir

   else
	log "python3.7 already installed.  Skipping"
   fi
}

#####################################################
# Function to install CDPCLI
#####################################################
install_cdpcli() {
	
	cdp_v=`${starting_dir:?}/provider/aws/cloudera/cdpclienv/env/bin/cdp --version 2>&1`
	if [[ $cdp_v = *"No such file or directory"* ]]; then 
		# setup repos?
		log "installing cdpcli ..."
       
		#create directories:
		mkdir -p ${starting_dir:?}/provider/aws/cloudera/cdpclienv
       
		# change 2 dir
		cd ${starting_dir:?}/provider/aws/cloudera/cdpclienv
        
		# create virtual env
		log "create the venv..."
		python3.7 -m venv env
        
		# set the env active:
		. ${starting_dir:?}/provider/aws/cloudera/cdpclienv/env/bin/activate
        
		# pip install the cdpcli client
		pip install cdpcli
        
		# upgrade the client:
		pip install --upgrade cdpcli
       
		# deactive the venv
		deactivate 

		# add to PATH in .bash_profile
		echo "PATH=$PATH:/app/cli_assist/provider/aws/cloudera/cdpclienv/env/bin" >> ~/.bash_profile
		echo " " >> ~/.bash_profile
		echo "export PATH" >> ~/.bash_profile
		
		#  re-initialize the .bash_profile
		. ~/.bash_profile
		
		# install ruby
		yum install -y ruby
	else
		log "cdpcli already installed.  Skipping"
	fi
}
