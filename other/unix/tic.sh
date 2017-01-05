#!/usr/bin/env bash

export TIC_PATH=/cenc/tic/

alias cdtic='cd $TIC_PATH; echo; ls; echo'

HOME_TIC=$HOME/.tic

source $HOME_TIC/tic_wake_software_environment.sh
source $HOME_TIC/tic_aliases.sh

source $HOME_TIC/tic_freesurfer.sh
source $HOME_TIC/tic_tools.sh
source $HOME_TIC/cenc.sh
source $HOME_TIC/tic_labels.sh

# source $HOME/.tic/redcap_link.sh