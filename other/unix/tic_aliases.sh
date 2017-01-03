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

function meas_strip {

    for ii in *.dat; do jj=$(echo $ii | cut -c 24- ); mv $ii $jj; done

}

function hcount {
    
    dim4=${2-100}

    fslstats  $1 -k $1 -h $dim4 | cat -n | grep -v 0.000000
}


function lsplit(){
inFile=${1}
nLines=${2-10}
prefix=${3-lsplit}

awk -v fileName=$inFile 'NR%10==1{x=sprintf("lsplit%02d.%s", ++i, $fileName );}{print > x}' $inFile
# '{ printf("%02d\n", $1) 
}

function labelstats() {

    labelImage=${1}
    weightImage=${2}

    if [ ! -z "$weightImage" ]; then
	statsCsv=${weightImage/%nii.gz/csv}

    else
	statsCsv=${labelImage/%nii.gz/csv}
    fi

    # echo $statsCsv $labelImage $weightImage 

    ImageMath 4 $statsCsv LabelStats $labelImage $weightImage
    #echo $cmd
    #$cmd

    echo
    echo $labelImage
    fslinfo $labelImage
    echo
    cat $statsCsv
    echo
}


function labelstats4D() {

    labelImage=${1}
    weightImage=${2}

    if [ ! -z "$weightImage" ]; then
	statsCsv=${weightImage/%nii.gz/csv}

    else
	statsCsv=${labelImage/%nii.gz/csv}
    fi

    # echo $statsCsv $labelImage $weightImage 

    for ii in $(seq -f "%05g" 0 24); do 
	
       fslroi $labelImage  $ii.$labelImage   0 -1 0 -1 0 -1 $ii 1
       fslroi $weightImage $ii.$weightImage  0 -1 0 -1 0 -1 $ii 1

       ImageMath 3 $ii.$statsCsv LabelStats $ii.$labelImage $ii.$weightImage

    done

    echo
    echo $labelImage
    fslinfo $labelImage
    echo
    cat $statsCsv
    echo
}


function ras_to_lps_world() { 
    awk -F, 'NR==1 {print}; NR > 1 {$1=-$1; $2=-$2; print}' OFS=, $1
}

function csa_to_ras_image() {
    awk -F, 'NR==1 {print}; NR > 1 {cMeg=$1; sMeg=$2; aMeg=$3; rFreeView=sMeg; aFreeView=255-cMeg; sFreeView=255-aMeg; $1=rFreeView; $2=aFreeView; $3=sFreeView; print}' OFS=, $1
}

function csa_to_lps_image() {
    awk -F, 'NR==1 {print}; NR > 1 {cMeg=$1; sMeg=$2; aMeg=$3;      rFreeView=256-sMeg; aFreeView=cMeg; sFreeView=aMeg;       $1=rFreeView; $2=aFreeView; $3=sFreeView; print}' OFS=, $1
}

function ras_to_lps_image() {
    awk -F, 'NR==1 {print}; NR > 1 {l=256-$1; p=256-$2; s=$3;  $1=l; $2=p; $3=s; print}' OFS=, $1
}


function labelmerge() {

    export FSLDIR=${IMAGEWAKE2_SOFTWARE}/fsl
    source ${FSLDIR}/etc/fslconf/fsl.sh
    export FSLOUTPUTTYPE=NIFTI_GZ
    export PATH=${FSLDIR}/bin:$PATH
 
    out_file=$1
    merge_files=${@:2}
    n_merge_files=$#;        n_merge_files=$(( n_merge_files -1 ))

#    echo $out_file
#    echo $merge_files
#    echo $n_merge_files

     cmd1="fslmerge -t $out_file $merge_files"
     cmd2="fslmaths $out_file  -Tmean -mul $n_merge_files $out_file"

     echo
     echo $cmd1
     echo $cmd2
     echo

     $cmd1
     $cmd2
}



function fsl_mc_qa() {
    inDir=${1-$PWD}
    threshold=2

    cd $inDir

    nAbsVolumes=$(sort -n prefiltered_func_data_mcf_abs.rms | grep "^[2-9]" | wc -l)
    nRelVolumes=$(sort -n prefiltered_func_data_mcf_rel.rms | grep "^[2-9]" | wc -l)

    printf "%3d, %3d, %s \n"  $nAbsVolumes  $nRelVolumes $inDir
}

function sedpwd() {

    sed "s#\$PWD#$PWD#" $@

}

function frv() {

freeview $@ 2> /dev/null

}

function fsv() {

fslview $@

}

function fsvall() {

	 for ii in $@; do 
	     fslview $ii & 
	 done

}

function killbranch() {
    
#   http://stackoverflow.com/questions/392022/best-way-to-kill-all-child-processes

    local _pid=$1
    local _sig=${2-9}
    kill -stop ${_pid} # needed to stop quickly forking parent from producing children between child killing and parent killing

    for _child in $(ps -o pid --no-headers --ppid ${_pid}); do

        cmd="killbranch ${_child} ${_sig}"
	echo $cmd
	$cmd
    done

    cmd="kill -${_sig} ${_pid}"
    echo $cmd
    $cmd
}


function cdls() {
    cd $1;
    lsreport
}


#
# Copy the file and add a date stamp to it. 
#

function cpds() {

    for ii in $@; do 
	cp $ii $ii.d$( date +"%m%d%y")
    done
}

#
# Rename file by adding a date stamp on the end
#

function mvds() {

    for ii in $@; do 
	mv $ii $ii.d$( date +"%m%d%y")
    done
}

function lsreport() {
    
    echo
    ls
    echo
}