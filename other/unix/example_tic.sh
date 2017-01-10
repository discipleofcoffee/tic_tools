#!/usr/bin/env bash

# TIC Environment Setup ======================================

export TIC_PATH=/Users/bkraft/PycharmProjects/

if [ ! -d $TIC_PATH ]; then

    echo
    echo "$TIC_PATH does not exist. Please edit your $HOME/.tic/tic.sh file."
    echo
    sleep 10

fi


export HOME_TIC_PATH=$HOME/.tic

source ${HOME_TIC_PATH}/tic_wake_software_environment.sh

export TIC_TOOLS_PATH=$TIC_PATH/tic_tools/
source ${TIC_TOOLS_PATH}/tic_tools_bash_setup.sh


# TIC Modules ================================================

export TIC_LABELS_PATH=$TIC_PATH/tic_labels/ 
source ${TIC_LABELS_PATH}/tic_labels_bash_setup.sh

export TIC_CBF_PATH=$TIC_PATH/tic_cbf/  
source ${TIC_CBF_PATH}/tic_cbf_bash_setup.sh

export TIC_REDCAP_LINK_PATH=${TIC_PATH}/tic_redcap_link/
source ${TIC_REDCAP_LINK_PATH}/tic_redcap_link_bash_setup.sh

export TIC_FREESURFER_PATH=$TIC_PATH/tic_freesurfer/
source ${TIC_FREESURFER_PATH}/tic_freesurfer_bash_setup.sh


# Templates =================================================

# This a list of templates that have been collected and placed in a location that is easily accessible.  Information
# of how these templates were downloaded may (or may not) be found in the individual paths.

TEMPLATES_PATH=/cenc/software/imagewake2/release/templates/

TEMPLATE_INIA19=$TEMPLATES_PATH/inia19_rhesus_macaque
TEMPLATE_IXI=$TEMPLATES_PATH/ixi
TEMPLATE_MNI=$TEMPLATES_PATH/mni
TEMPLATE_LPBA40=$TEMPLATES_PATH/lpba40
TEMPLATE_OHSU_RHESUS=$TEMPLATES_PATH/ohsu_rhesus




