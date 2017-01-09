#!/bin/bash
#
# This file will clone repositories from GitHub to run TIC.
#
#
# git clone https://github.com/bkraft4257/tic_tools

#
#
#

TIC_REPOSITORY_PATH=${1-$PWD}
TIC_SETUP_PATH=$HOME/.tic

if [ ! -d $TIC_SETUP_PATH ]; then

    mkdir $TIC_SETUP_PATH

    cp $TIC_REPOSITORY_PATH/tic_tools/other/unix/example_tic.sh                           $TIC_SETUP_PATH/tic.sh
    cp $TIC_REPOSITORY_PATH/tic_tools/other/unix/example_tic_wake_software_environment.sh $TIC_SETUP_PATH/tic_wake_software_environment.sh
fi