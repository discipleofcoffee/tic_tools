
export TIC_TOOLS_PATH=$TIC_PATH/tic_tools/''  # Add path information here
export TIC_TOOLS_PYTHONPATH=${TIC_TOOLS_PATH}/tools

export PYTHONPATH=${TIC_TOOLS_PYTHONPATH}:$PYTHONPATH

source $TIC_TOOLS_PATH/other/unix/dcm_functions.sh
