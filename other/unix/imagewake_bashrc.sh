
### For BASH Shell
#
#

############################################################################################
# Image Wake (formerly known as Image Co-op)

export IMAGEWAKE2_ENVIRONMENT=${IMAGEWAKE2_PATH}/env/
export IMAGEWAKE2_SCRIPTS=${IMAGEWAKE2_PATH}/scripts/
export IMAGEWAKE2_MATLAB=${IMAGEWAKE2_PATH}/matlab/
export IMAGEWAKE2_TEMPLATES=${IMAGEWAKE2_PATH}/templates

export IMAGEWAKE2_SOFTWARE=/aging1/software/


source ${IMAGEWAKE2_PATH}/imagewake_definitions.sh    # Load generic IC aliases



export PATH=${IMAGEWAKE2_PATH}:${IMAGEWAKE2_ENVIRONMENT}:${IMAGEWAKE2_SCRIPTS}:${IMAGEWAKE2_MATLAB}:${PATH}

export RECON_STATS_PATH=/cenc/software/freesurfer_recon_stats/recon-stats-master



source ${IMAGEWAKE2_PATH}/imagewake_alias.sh             # Load generic IC aliases

############################################################################################
# Nipype Configuration

export CAMINO_PATH=/cenc/software/camino/
export CAMINO_HEAP_SIZE=1800 
export MANPATH=$CAMINO_PATH/man:$MANPATH
export PATH=$CAMINO_PATH/bin:$PATH 
 
############################################################################################
# Nipype Configuration
#
#
#     export NIPYPE_PYTHON_PATH=/aging1/software/anaconda/bin
     export NIPYPE_PYTHON_PATH=/opt/anaconda2/bin/
     export NIBABEL_PATH=${IMAGEWAKE2_SOFTWARE}/nibabel
     export PATH=${NIPYPE_PYTHON_PATH}:$PATH
# 


############################################################################################
# ANTS Configuration
#
    export ANTS_PATH='/aging1/software/ants/bin/'
    export ANTSPATH=$ANTS_PATH
    export PATH=${ANTSPATH}:$PATH

#    case $HOSTNAME in
#        (aging1a)     export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=8     
#        (aging2a)     export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=8     
#    esac
#



############################################################################################
# MRIcron Configuration
# 
     export MRICRON_PATH=/opt/software/mricron
     export PATH=${MRICRON_PATH}:$PATH


############################################################################################
# 3D Slice Configuration
# 
#     export SLICER_3D_PATH /aging1/software/Slicer-4.3.1-linux-amd64
#     export PATH ${SLICER_3D_PATH}:$PATH
# 
#     alias slicer "Slicer &"
# 
# 


#############################################################################################3
# MIMP Configuration

    export MIMP_PATH=${IMAGEWAKE2_SOFTWARE}/MIMP143
    export RRI_NIFTI_TOOLS_PATH=${IMAGEWAKE2_SOFTWARE}/rri_nifti_tools


#############################################################################################3
# MIPAV Configuration
# 
#     export MIPAV_PATH /opt/software/mipav
#     export PATH ${MIPAV_PATH}:$PATH
#
#    alias mipav "/opt/software/mipav/mipav"
#


##########################################################################################
# ITKsnap Configuration
#
    export ITKSNAP_PATH=/aging1/software/itksnap3
    export PATH=${ITKSNAP_PATH}/bin:$PATH        



############################################################################################
# FSL Configuration
   export FSL509_DIR=${IMAGEWAKE2_SOFTWARE}/fsl5.09
   export FSL505_DIR=${IMAGEWAKE2_SOFTWARE}/fsl5.05

   export FSLDIR=${FSL509_DIR}
   source ${FSLDIR}/etc/fslconf/fsl.sh

   export PATH=${FSLDIR}/bin:$PATH        


############################################################################################
# FREE SURFER Configuration

   export TUTORIAL_DATA=/bkraft2/freesurfer
   export FREESURFER_HOME=${IMAGEWAKE2_SOFTWARE}/freesurfer

#
#  echo doesn't work with scp.  [-t 1 ] checks to see if the current terminal is an
#  interactive terminal.  If it is you can setup FreeSurfer. If it is not 
#
#  http://stackoverflow.com/questions/12440287/scp-doesnt-work-when-echo-in-bashrc
#
#  This assumes that I don't want to call FreeSurfer when I running an scp command from
#  a remote computer. 
#


if [ -t 1 ]; then 
   echo
   source $FREESURFER_HOME/SetUpFreeSurfer.sh
   echo
fi

############################################################################################
# Human Connectome Configuration
#  
   export HCP_WORKBENCH_PATH=/aging1/software/workbench/
   export PATH=${HCP_WORKBENCH_PATH}/bin_rh_linux64:$PATH        

   export HCPPIPEDIR=/aging1/software/hcp/Pipelines-master/
   export PATH=${HCPPIPEDIR}:$PATH        


############################################################################################
# CONN Configuration
# 
   export SPM_PATH=${IMAGEWAKE2_SOFTWARE}/SPM12
   export CONN_PATH=${IMAGEWAKE2_SOFTWARE}/conn/conn16a
   export W2MHS_PATH=${IMAGEWAKE2_SOFTWARE}/W2MHS/
   export DPABI_PATH=${IMAGEWAKE2_SOFTWARE}/dpabi/DPABI_V2.1_160415
   export GRAPHVAR_PATH=${IMAGEWAKE2_SOFTWARE}/graphvar/GraphVar_beta_v_06.2
   export JSON_PATH=${IMAGEWAKE2_SOFTWARE}/jsonlab/jsonlab-1.2

   export PYTHON3_PATH=/opt/anaconda3/bin

   if [ -z $PYTHONPATH ]; then
       export   PYTHONPATH=${IMAGEWAKE2_SCRIPTS}:${RECON_STATS_PATH}:${RECON_STATS_PATH}/recon-stats:${NIBABEL_PATH}
   else
       export   PYTHONPATH=${IMAGEWAKE2_SCRIPTS}:${RECON_STATS_PATH}:${RECON_STATS_PATH}/recon-stats:${NIBABEL_PATH}:$PYTHONPATH
   fi
   
   PYTHONPATH="/aging1/software/anaconda/lib/python2.7/site-packages/gradunwarp/core:${PYTHONPATH}"
   
   echo
   echo "\$IMAGEWAKE2_PATH =  $IMAGEWAKE2_PATH"
   echo