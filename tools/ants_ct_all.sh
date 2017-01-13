#!/usr/bin/env bash

# The goal of this script is to mimic antsCorticalThickness.sh in it's entirety. antsCorticalThickness.sh runs in three
# stages: brain_extraction, registration, and segmentation.  The ants_ct.py script breaks these three steps up. This was
# necessary to determine how the BrainExtractionMask.nii.gz could be edited and the antsCorticalThickness.sh script run
# with the edited mask.  T
#
# The problem is that running the script with nohup prevents the whole script from running. As a work around I have
# created this function to call each bash script through a single bash script.

#

t_option=${1}
e_option=${2}
m_option=${3}
f_option=${4}
p_option=${5}
output_directory=${6}
out_prefix=${7}
a_option=${8}

ants_ct_brain_extraction.sh -d 3 -t {t_option} -w 0.25 -e {e_option} -m {m_option} -f {f_option} -p {p_option} \
    -o {output_directory} + "/" + {out_prefix} -a ${a_option}

ants_ct_registration.sh -d 3 -t {t_option} -w 0.25 -e {e_option} -m {m_option} -f {f_option} -p {p_option} \
    -o {output_directory} + "/" + {out_prefix} -a ${a_option}

ants_ct_segmentation.sh -d 3 -t {t_option} -w 0.25 -e {e_option} -m {m_option} -f {f_option} -p {p_option} \
    -o {output_directory} + "/" + {out_prefix} -a ${a_option}