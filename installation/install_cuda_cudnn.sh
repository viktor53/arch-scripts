#!/bin/bash

##################################################################
#   INSTALL CUDA 10.1.243-2-x86_64 AND CUDNN 7.6.5.32-4-x86_64   #
#----------------------------------------------------------------#
# The script downloads CUDA nad CUDNN from archive.archlinux.org #
# page and stores it temporally into ~/Downloads folder. It will #
# ask you if you are sure about the installation. It needs to be #
# run with sudo. At the end it adds exporting of required paths  #
# into ~/.bashrc (PATH, CPATH and LD_LIBRARY_PATH).              #
##################################################################

# CONSTANTS
CUDA_VERSION=10.1.243-2-x86_64
CUDNN_VERSION=7.6.5.32-4-x86_64
DOWNLOAD_FOLDER=~/Downloads
FILE_FOR_EXPORTING=~/.bashrc 

echo "It is going to install cuda ${CUDA_VERSION} and cudnn ${CUDNN_VERSION} that is compatible with tensorflow 2.3.1. (It requires to run it with sudo)"

read -p "Are you sure you want to install it? (y/n): " answer

if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
	echo "Downloading cuda ${CUDA_VERSION}..."
	curl https://archive.archlinux.org/packages/c/cuda/cuda-${CUDA_VERSION}.pkg.tar.xz > ${DOWNLOAD_FOLDER}/cuda-${CUDA_VERSION}.pkg.tar.xz 

	echo "Running: pacman -U cuda-${CUDA_VERSION}.pkg.tar.xz"
	pacman -U ${DOWNLOAD_FOLDER}/cuda-${CUDA_VERSION}.pkg.tar.xz

	echo "Downloading cudnn ${CUDNN_VERSION}..."
	curl https://archive.archlinux.org/packages/c/cudnn/cudnn-${CUDNN_VERSION}.pkg.tar.zst > ${DOWNLOAD_FOLDER}/cudnn-${CUDNN_VERSION}.pkg.tar.zst

	echo "Running: pacman -U cudnn-${CUDNN_VERSION}.pkg.tar.zst"
	pacman -U ${DOWNLOAD_FOLDER}/cudnn-${CUDNN_VERSION}.pkg.tar.zst
	
	echo "Installation is completed."

	read -p "Do you want to export required paths (PATH, CPATH, LD_LIBRARY_PATH)? (y/n): " answer

	if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
		echo "" >> ${FILE_FOR_EXPORTING}
		echo "# CUDA and CUDNN paths" >> ${FILE_FOR_EXPORTING}
		echo 'export PATH="/opt/cuda/bin:$PATH"' >> ${FILE_FOR_EXPORTING}
		echo 'export CPATH="/opt/cuda/include:$CPATH"' >> ${FILE_FOR_EXPORTING}
		echo 'export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/opt/cuda/lib64:/opt/cuda/lib"' >> ${FILE_FOR_EXPORTING}
		echo "" >> ${FILE_FOR_EXPORTING}
	fi
		
	read -p "Do you want to remove downloaded files? (y/n): " answer

	if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
		echo "Removing files..."
	
		rm ${DOWNLOAD_FOLDER}/cuda-${CUDA_VERSION}.pkg.tar.xz
		rm ${DOWNLOAD_FOLDER}/cudnn-7.6.5.32-4-x86_64.pkg.tar.zst
	
		echo "Finished."
	fi
else
	echo "Nothing is going to be installed."
fi
