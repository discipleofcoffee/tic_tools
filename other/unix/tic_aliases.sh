#!/usr/bin/env bash

alias cdtic='cd $TIC_PATH; lsreport_function'
alias cdstudies='cd $STUDIES_PATH; lsreport_function'

alias cdsd='cd $SUBJECTS_DIR; lsreport_function'

alias  fsvinia='fslview $IMAGEWAKE2_PATH/templates/inia19_rhesus_macaque/inia19_e_T1wFullImage.nii.gz &'
alias  fsvfsl='fslview $FSL_DIR/data/standard/MNI152_T1_1mm_brain.nii.gz &'
alias  fsvixi='fslview $IMAGEWAKE2_PATH/templates/ixi/cerebellum/ixiTemplate2_e_T1wFullImage.nii.gz &'

alias cda='echo; echo $PWD; cd $(pwd -P); echo $PWD; echo; ls; echo'

alias redcm='source $IMAGEWAKE2_SCRIPTS/dcm_functions.sh'


alias ag='alias | grep'
alias hg='history | grep '
alias eg='env | grep '
alias lg='ls | grep '


alias frv='freeview'
alias fsv='fslview'
alias fsvall='fslview_all_function'

alias lsreport='lsreport_function'

alias tic_reorient='iwReorient2Std.sh ../../reorient *.gz'

# Aliases to TIC Python functions

alias tic_plot_overlay='$TIC_TOOLS_PYTHONPATH/plot_overlay.py'
