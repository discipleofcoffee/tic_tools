#
# TIC Setup
#

export TIC_PATH=/cenc/tic/
export TIC_LABELS_PATH=${TIC_PATH}/tic_labels/
export TIC_OUTLIERS_PATH=${TIC_PATH}/tic_outliers/
export TIC_PROTOCOL_CHECK_PATH=${TIC_PATH}/tic_protocol_check/
export TIC_REDCAP_LINK_PATH=${TIC_PATH}/tic_redcap_link/

alias cdtic='cd $TIC_PATH; echo; ls; echo'

TIC_MODULES=${TIC_LABELS_PATH}/labels:${TIC_OUTLIERS_PATH}/outliers:${TIC_PROTOCOL_CHECK_PATH}/protocol_check
TIC_MODULES=${TIC_REDCAP_LINK_PATH}/redcap:${TIC_MODULES}
export TIC_MODULES

export PATH=$TIC_MODULES}/$PATH

PYTHONPATH=${TIC_LABELS_PATH}/labels:${TIC_OUTLIERS_PATH}/outliers:${TIC_PROTOCOL_CHECK_PATH}/protocol_check:${PYTHONPATH}
PYTHONPATH=${TIC_REDCAP_LINK_PATH}/redcap:$PYTHONPATH