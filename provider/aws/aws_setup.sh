#!/bin/bash

###########################################################################################################
# import parameters and utility functions 
###########################################################################################################

. /app/cli_assist/provider/aws/utils.sh



#####################################################
#       Step 1: install the aws cli
#####################################################
install_aws_cli

#####################################################
#	Step 2: install the JQ cli
#####################################################
install_jq_cli

#####################################################
#       Step 3: install the Terraform cli
#####################################################
#install_terraform_cli

#####################################################
#       Step 4: install python 3.7 from source
#####################################################
install_python37

#####################################################
#       Step 5: install cdp cli
#####################################################
install_cdpcli


# return to start directory
cd $starting_dir

