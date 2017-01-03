#!/usr/bin/env bash
export TIC_PATH=/cenc/tic/

alias cdtic='cd $TIC_PATH; echo; ls; echo'

source $HOME/.tic/tic_freesurfer.sh
source $HOME/.tic/tic_labels.sh


# CENC
export CENC_PATH=/cenc/tic/studies/cenc/
source $CENC_PATH/other/unix/cenc_bashrc.sh


#
# TIC Setup
#

export TIC_OUTLIERS_PATH=${TIC_PATH}/tic_outliers/
export TIC_PROTOCOL_CHECK_PATH=${TIC_PATH}/tic_protocol_check/
export TIC_REDCAP_LINK_PATH=${TIC_PATH}/tic_redcap_link/

export TIC_TOOLS_PATH=${TIC_PATH}/tic_tools/
export TIC_TOOLS_PYTHONPATH=${TIC_TOOLS_PATH}/tools/
export PYTHONPATH=${TIC_TOOLS_PYTHONPATH}:$PYTHONPATH


TIC_MODULES=${TIC_LABELS_PATH}/labels:${TIC_OUTLIERS_PATH}/outliers:${TIC_PROTOCOL_CHECK_PATH}/protocol_check
TIC_MODULES=${TIC_REDCAP_LINK_PATH}/redcap:${TIC_MODULES}
export TIC_MODULES

export PATH=$TIC_MODULES}/$PATH

PYTHONPATH=${TIC_LABELS_PATH}/labels:${TIC_OUTLIERS_PATH}/outliers:${TIC_PROTOCOL_CHECK_PATH}/protocol_check:${PYTHONPATH}
export PYTHONPATH=${TIC_REDCAP_LINK_PATH}/redcap_link:$PYTHONPATH


