#!/bin/bash

export dcmFlatDir="dcmFlat"

export dcmConvertDir="../nifti"

export dcmConvertAll="dcmConvertAll.cfg"
export dcmConvert="dcmConvert.cfg"

export dcmReportInfo="dcmReport.info"


export dcmFormat="nii"
export dcmFormatExtension=".nii.gz"


dcm_source() {
    echo
    cmd="source ${IC_GIT_PATH}/scripts/dcm_functions.sh"
    echo $cmd
    $cmd
    echo
}


dcm_list() {
    echo 
    echo "dcm Enviroment Variables"
    echo
    echo "   dcmFlatDir    = " $dcmFlatDir
    echo "   dcmReportInfo = " $dcmReportInfo
    echo "   dcmConvertAll = " $dcmConvertAll
    echo "   dcmConvert    = " $dcmConvert
    echo "   dcmConvertDir = " $dcmConvertDir

    echo; 
    echo "dcm Functions"
    echo 

    declare -F | awk ' /declare -f dcm_/{print "   " $3} '

    echo;
}

dcm_mv_incoming(){

    mkdir -p $2/data/
    mv $1 $2/data/dicom

#    cd $2/data/dicom
#    dcm_scan 2*

}


dcm_scan() {

    dcm_search_dir=${1-$PWD}
    dcm_flat_dir=${2-$dcmFlatDir}
    dcm_report_info=${3-$dcmReportInfo}

    dcm_flatten       $dcm_search_dir
    dcm_report        $dcm_flat_dir $dcm_report_info
    dcm_parse_general $

}


dcm_auto() {

    startDir=$(pwd)

    dcm_scan $1

    dcm_convert $dcmConvertAll

    cd $dcmConvertDir
    dcm_clean

    cd $startDir

}

dcm_parse_general() {
    
    outFileName=${1-$dcmConvertAll}
    dcm_report_info=${2-$dcmReportInfo}

    echo
    echo ">>>>>>>>>>> ${FUNCNAME}: cat $dcmConvertAll ..."
    echo

    # Contents of dcmparse.sh
    # Eventually it should be integrated into this function
    #
    
     rm -rf ${outFileName}.tmp1 

     awk -v awkOutDir="$dcmConvertDir" \
         -v awkFormat="$dcmFormat" \
         -v awkExtension="$dcmFormatExtension" \
                'BEGIN { FS = " " } 
                { printf "%2d %s %s %s%s\n", $1, awkOutDir, awkFormat, $2, awkExtension }'  $dcm_report_info > ${outFileName}.tmp1

     sed -i -e '/Phoenix/d'  ${outFileName}.tmp1  # Remove Phoenix from the list

     dcm_add_rs ${outFileName}.tmp1 | tee ${outFileName}

     rm -rf ${outFileName}.tmp1 

    echo
}

dcm_add_rs() {

 # echo " "
 # echo ">>>>>>>>>> ${FUNCNAME}: Adding rs## numbering from $1 "

     awk 'BEGIN { FS = " " } 
                { gsub( ".nii", sprintf("_rs%02d.nii", $1), $4);
                  printf("%2d %s %s %s\n", $1, $2, $3, $4) }'  $1
#  echo " "
}

dcm_remove_rs() {
#  echo 
#  echo ">>>>>>>>>> ${FUNCNAME}: Removing rs## numbering from $1 "
#  echo 

  sed -e 's#_rs[[:digit:]][[:digit:]]##' $1

#  echo 
}

dcm_remove_rs01() {

#  echo " "
#  echo ">>>>>>>>>> ${FUNCNAME}: Removing Localizer images from $1 "
#  echo 

  sed -e 's#_rs01##' $1

#  echo " "
}

dcm_parse_secret1_t1ax_thigh() {

#  echo " "
#  echo ">>>>>>>>>> Selecting T1 axial images of the thigh "
#  echo " "

  grep  'T1AXDBLEFTTHIGH' $1 > ${1}.tmp
  mv -f ${1}.tmp ${1}

  cat $1
 
#  echo ""
}

dcm_remove_dti_color_fa() {
#  echo ""
#  echo ">>>>>>>>>> ${FUNCNAME}: Deleting DTI Color FA from $1 "
  
  sed -e '/ed2d.*_rs05/d' $1

#  echo ""
}

dcm_remove_localizers() {

#  echo ""
#  echo ">>>>>>>>>> ${FUNCNAME}: Removing Localizer images from $1 "

  sed  -e '/localizer/Id'  -e '/LOC/Id' $1

#  echo ""
}

dcm_flatten() {

  dcm_search_dir=${1-$PWD}
  dcm_flat_dir=${2-$dcmFlatDir}


    echo
    echo ">>>>>>>>>> ${FUNCNAME} : Finding all DCM files and creating hard links in $dcmFlatDir"
    
  lnflatten.sh $dcm_flat_dir $(find -L $dcm_search_dir -name '*.DCM' -o -name '*.IMA') 
}

dcm_report() {

    dcm_flat_dir=${1-$dcmFlatDir}
    dcm_report_info=${2-$dcmReportInfo}

    echo
    echo ">>>>>>>>>> ${FUNCNAME}: Scanning DCM files and creating $dcmReportInfo"

    unpacksdcmdir -src $dcm_flat_dir -targ . -scanonly $dcm_report_info
}

dcm_delete_duplicates(){
    awk '!seen[$4]++' $1
}

dcm_convert() {

    startDir=$PWD

    echo
    echo ">>>>>>>>>>> ${FUNCNAME}: Convert files according to $1 ...."
    echo
    cat $1

    echo
    echo ">>>>>>>>>>> ${FUNCNAME}: Unpacking ..."

    unpacksdcmdir -src $dcmFlatDir -targ . -cfg $1 -generic


    echo
    echo ">>>>>>>>>>> ${FUNCNAME}: dcm2nii conversion of dti and topup directories ..."

    iwDtiDcm2Nii.sh $1

    # Clean all dicom directories to rename files.

    echo
    echo ">>>>>>>>>>> ${FUNCNAME}: Clean NIFTI directories ..."

    cd ${startDir}

    dcmConvertDir=$(awk '{print $2}' $1 | uniq )

    for ii in $dcmConvertDir; do 
	iiDir="${startDir}/${ii}"
	cd $iiDir
	dcm_nifti_clean; 
    done

    echo
}

dcm_reorient2std() {

outputDir=${1}

if [ ! -d "${outputDir}" ]; then
   mkdir -p ${outputDir}
fi

echo

for ii in "${@:2}"; do

    echo "fslreorient2std $ii ${outputDir}/$ii"
    ${FSLDIR}/bin/fslreorient2std $ii ${outputDir}/$ii

done

echo

}


dcm_nifti_clean() {

    rename nii-infodump.dat info *.dat
    rename nii.gz-infodump.dat info *.dat
    rm -f flf
}

dcm_clean() {
    
    rm -rf ${dcmConvertAll} ${dcmConvert}
    rm -rf dicomdir.sumfile  
    rm -rf unpack.log
}

dcm_group() {

   dcm_remove_rs $1 > ${1}.dcmgroup.step1

   awk 'BEGIN{FS = " "}
     
       {

       outFileName=$4

       if (last == outFileName)
	   {
	       count++;

	   }
       else
	   {
	       count = 1;
	       last = $4;
      	   }

       gsub( ".nii.gz", sprintf("_rs%02d.nii.gz", count), outFileName);

       printf("%2d %s %s %s\n", $1, $2, $3, outFileName);

       }'  ${1}.dcmgroup.step1

   rm ${1}.dcmgroup.step1

}


