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

git clone https://github.com/bkraft4257/tic_cbf
git clone https://github.com/bkraft4257/tic_freesurfer
git clone https://github.com/bkraft4257/tic_labels
git clone https://github.com/crhamilt/tic_protocol_check
git clone https://github.com/bkraft4257/tic_redcap_link

source  $TIC_REPOSITORY_PATH/other/unix/tic_initial_setup.sh
