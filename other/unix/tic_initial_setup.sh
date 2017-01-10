#!/bin/bash
#
# This file will clone repositories from GitHub to run TIC.
#
#
# git clone https://github.com/bkraft4257/tic_tools

#
#
#

"${TIC_TOOLS_PATH:?Need to set TIC_TOOLS_PATH to the location of TIC_TOOLS}"

if [ ! -f $TIC_TOOLS_PATH/tic_tools_bash_setup.sh ]; then
    echo "TIC_TOOLS_PATH is not correct. Please try again"
fi

TIC_SETUP_PATH=$HOME/.tic

if [ ! -d $TIC_SETUP_PATH ]; then

    mkdir $TIC_SETUP_PATH

    cp $TIC_TOOLS_PATH/other/unix/example_tic.sh                           $TIC_SETUP_PATH/tic.sh
    cp $TIC_TOOLS_PATH/other/unix/example_tic_wake_software_environment.sh $TIC_SETUP_PATH/tic_wake_software_environment.sh
fi