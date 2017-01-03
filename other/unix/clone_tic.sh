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


git clone https://github.com/bkraft4257/tic_outliers
git clone https://github.com/crhamilt/tic_redcap_link
git clone https://github.com/crhamilt/tic_protocol_check
git clone https://github.com/bkraft4257/tic_labels

if [ ! -d $TIC_SETUP_PATH ]; then

    cp $TIC_REPOSITORY_PATH/tic_freesurfer/other/unix/tic_freesurfer.sh $TIC_SETUP_PATH
    cp $TIC_REPOSITORY_PATH/tic_freesurfer/other/unix/tic_labels.sh $TIC_SETUP_PATH
    cp $TIC_REPOSITORY_PATH/tic_freesurfer/other/unix/tic_outliers.sh $TIC_SETUP_PATH
    cp $TIC_REPOSITORY_PATH/tic_freesurfer/other/unix/tic_protocol_check.sh $TIC_SETUP_PATH
    cp $TIC_REPOSITORY_PATH/tic_freesurfer/other/unix/tic_redcap_link.sh $TIC_SETUP_PATH
fi