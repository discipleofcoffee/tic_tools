#!/bin/bash
#
# This file will clone repositories from GitHub to run TIC.
#
#
# git clone https://github.com/bkraft4257/tic_tools

#
#
#

# "${TIC_TOOLS_PATH:?Need to set TIC_TOOLS_PATH to the location of TIC_TOOLS}"

if [ ! -f $TIC_TOOLS_PATH/tic_tools_bash_setup.sh ]; then
    echo "TIC_TOOLS_PATH is not correct. Please try again"
    exit
fi

TIC_SETUP_PATH=$HOME/.tic

#
#
#

if [ ! -d $TIC_SETUP_PATH ]; then

    echo
    echo "Copying tic.sh and tic_wake_software_environment.sh to $HOME/.tic/.  These files can be used as a template"
    echo "for setting up your account."
    echo

    mkdir $TIC_SETUP_PATH

    cp $TIC_TOOLS_PATH/other/unix/example_tic.sh                           $TIC_SETUP_PATH/tic.sh
    cp $TIC_TOOLS_PATH/other/unix/example_tic_wake_software_environment.sh $TIC_SETUP_PATH/tic_wake_software_environment.sh
fi

#
echo
echo "Individual studies need to be added separately. The comamnds to do so are echoed below. I know there is a better"
echo " way to do this with a python script but for the moment I am being lazy. -BK"
echo
echo "tail -10 /cenc/tic/studies/cenc/other/unix/cenc_add_to_tic.sh >> $HOME/.tic/tic.sh"
echo "tail -10 /cenc/tic/studies/wbi/other/wbi_add_to_tic.sh >> $HOME/.tic/tic.sh"
echo "tail -13 /cenc/tic/studies/radcore/other/radcore_add_to_tic.sh >> $HOME/.tic/tic.sh"
echo
echo
