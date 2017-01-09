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
TIC_TOOLS_PATH=${TIC_REPOSITORY_PATH}/tic_tools/

TIC_SETUP_PATH=$HOME/.tic

cd $TIC_REPOSITORY_PATH

for ii in tic_cbf tic_freesurfer tic_labels tic_protocol_check tic_redcap_link; do
    [ -d $TIC_REPOSITORY_PATH/${ii} ] || git clone https://github.com/bkraft4257/${ii}
done

#git clone https://github.com/bkraft4257/tic_freesurfer
#git clone https://github.com/bkraft4257/tic_labels
#git clone https://github.com/crhamilt/tic_protocol_check
#git clone https://github.com/bkraft4257/tic_redcap_link

source  $TIC_TOOLS_PATH/other/unix/tic_initial_setup.sh
