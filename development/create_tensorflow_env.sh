#!/bin/bash

#######################################################
#         CREATE TENSORFLOW PYTHON ENVIRONEMT         #
#-----------------------------------------------------#
# The  script  creates tensorflow python environment. #
# Before creating the environment consider to install #
# CUDA and CUDNN to be able to run tensorflow on GPU. #
# See script "../installation/install_cuda_cudnn.sh". #
#                                                     # 
# Parameters:                                         #
# 	--env_folder=<env_folder>                     #
#		Folder where the python environment   #
#		will be created.                      #
#	--python_version=<version>                    #
#		Version of python. By default it uses #
#               the version 3.8                       #
#######################################################


if [ $# -ne 1 ] && [ $# -ne 2 ]; then
	echo "Wrong number of arguments!"
	echo "Possible usage:"
	echo "./create_tensorflow_env.sh --env_folder=<env_folder>"
	echo "./create_tensorflow_env.sh --env_folder=<env_folder> --python_version=<version>"
	exit -1
fi

for arg in "$@"; do
	case $arg in
		--env_folder=*)
			ENV_FOLDER="${arg#*=}"
			;;
		--python_version=*)
			VERSION="${arg#*=}"
			;;
		*)
			echo "Uknown option: ${arg}"
			exit -1
			;;
	esac
done

if [ -z "${VERSION}" ]; then
	VERSION=3.8
fi

echo  "The tensorflow python ${VERSION} environment  will be created in the ${ENV_FOLDER} folder."
read -p "Are you sure? (y/n): " answer

if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
	echo "Creating environment..."
	eval python${VERSION} -m venv ${ENV_FOLDER}
	eval source ${ENV_FOLDER}/bin/activate
	
	echo "Installing tensorflow 2.3.1 and numpy 1.18.5..."
	pip install wheel tensorflow==2.3.1 numpy==1.18.5

	echo "Done."
else
	echo "Nothing will be done."
fi

