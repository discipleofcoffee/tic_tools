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


git clone https://github.com/bkraft4257/tic_freesurfer
git clone https://github.com/bkraft4257/tic_labels
git clone https://github.com/crhamilt/tic_protocol_check
git clone https://github.com/crhamilt/tic_redcap_link

if [ ! -d $TIC_SETUP_PATH ]; then

    cp $TIC_REPOSITORY_PATH/tic_tools/other/unix/{tic,tic_tools}.sh $TIC_SETUP_PATH
    cp $TIC_REPOSITORY_PATH/tic_freesurfer/other/tic_freesurfer.sh $TIC_SETUP_PATH
    cp $TIC_REPOSITORY_PATH/tic_redcap_link/other/tic_redcap_link.sh $TIC_SETUP_PATH

fi