###
##
#

alias iwbeta="export IMAGEWAKE2_PATH=$IMAGEWAKE2_BETA; echo $IMAGEWAKE_PATH;  source $IMAGEWAKE2_PATH/imagewake_bashrc.sh"
alias iwrelease="export IMAGEWAKE2_PATH=$IMAGEWAKE2_RELEASE; echo $IMAGEWAKE_PATH; source $IMAGEWAKE2_PATH/imagewake_bashrc.sh"

alias cdiw='cd $IMAGEWAKE2_PATH'
alias cdiws='cd $IMAGEWAKE2_PATH/scripts'
alias cdiwm='cd $IMAGEWAKE2_PATH/matlab'

alias cdsubs='cd $SUBJECTS_DIR'


alias  fsvinia='fslview $IMAGEWAKE2_PATH/templates/inia19_rhesus_macaque/inia19_e_T1wFullImage.nii.gz &'
alias  fsvfsl='fslview $FSL_DIR/data/standard/MNI152_T1_1mm_brain.nii.gz &'
alias  fsvixi='fslview $IMAGEWAKE2_PATH/templates/ixi/cerebellum/ixiTemplate2_e_T1wFullImage.nii.gz &'

alias cda='echo; echo $PWD; cd $(pwd -P); echo $PWD; echo; ls; echo'

alias redcm='source $IMAGEWAKE2_SCRIPTS/dcm_functions.sh'


alias frv='freeview'
alias fsv='fslview'
alias fsvall='fslview_all_function'

alias lsreport='lsreport_function'


# Aliases to TIC Python functions

alias tic_plot_overlay='$TIC_TOOLS_PYTHONPATH/plot_overlay.py'
