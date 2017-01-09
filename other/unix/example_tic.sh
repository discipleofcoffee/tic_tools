#!/usr/bin/env bash

# TIC Environment Setup ======================================

export TIC_PATH=/Users/bkraft/PycharmProjects/
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


# Studies ======================================


STUDIES_PATH=$HOME/PycharmProjects/

#WBI Study
export WBI_PATH=$STUDIES_PATH/wbi/
source $WBI_PATH/wbi_bash_setup.sh

#RADCORE Study
export RADCORE_PATH=$STUDIES_PATH/radcore/
export RADCORE_MRI_SUBJECT_DATA=/RadCCORE_MRI/subjects
source $RADCORE_PATH/radcore_bash_setup.sh


# CENC Study
export CENC_PATH=$STUDIES_PATH/cenc
export CENC_DISK=/Volumes/cenc/

source ${CENC_PATH}/cenc_bash_setup.sh
SUBJECTS_DIR=$CENC_SUBJECTS_DIR


