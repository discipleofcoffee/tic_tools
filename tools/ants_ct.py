#!/usr/bin/env python2

"""

"""
import stat
import os                                               # system functions
import shutil
from distutils.dir_util import copy_tree

import argparse

import _qa_utilities as qa
import _utilities as util

def create_command(method, output_directory):

    callCommand = [ 'ants_ct_' + method + '.sh',  "-d", "3", "-t", t_option, "-w", "0.25",
                    "-e", e_option, "-m", m_option, "-f", f_option, "-p", p_option, "-o", output_directory + "/" + inArgs.out_prefix ]

    callCommand = callCommand + [ "-a", inArgs.t1full ]

    if not inArgs.t2full == None:
        callCommand = callCommand + [ "-a", inArgs.t2full ]

    if not inArgs.t2flair == None:
        callCommand = callCommand + [ "-a", inArgs.t2flair ]

    return callCommand


#
# Main Function
#

if __name__ == "__main__":

    ## Parsing Arguments
    #
    #

    usage = "usage: %prog [options] arg1 arg2"

    parser = argparse.ArgumentParser(prog='ants_ct')

    parser.add_argument("--t1full", help="Full T1w image (default = t1w.nii.gz)", default = "t1w.nii.gz")
    parser.add_argument("--t2full", help="T2 TSE used in QI and QO (default = None)", default = None)
    parser.add_argument("--t2flair", help="T2 Flair used in QI and QO (default = None)", default = None)
    parser.add_argument("--in_dir", help="Input directory", default = os.getcwd())
    parser.add_argument("--out_dir", help="Output directory", default = '..')
    parser.add_argument("--out_prefix", help="Output prefix", default = "")
    parser.add_argument("-d", "--display", help="Display Results", action="store_true", default=False)
    parser.add_argument("-t", "--template", help="Template", default='inia19', choices=['inia19', 'ixi'])
    parser.add_argument("-v", "--verbose", help="Verbose flag", action="store_true", default=False)
    parser.add_argument("--debug", help="Debug flag", action="store_true", default=False)

    parser.add_argument("--qi", help="QA inputs", action="store_true", default=False)
    parser.add_argument("--qo", help="QA outputs", action="store_true", default=False)

    parser.add_argument("--nohup", help="nohup", action="store_true", default=False)
    parser.add_argument("--methods", help="Run processing pipeline", action="store_true", default=False)

    parser.add_argument("--methods_stage", help="Stages to run in the processing pipeline [all, 1, 2, 3] (all)", type=str, nargs='*', default = [ 'all' ],
                        choices = [ 'all', '1','2','3' ])

    inArgs = parser.parse_args()

    # Change director to input directory
    os.chdir(os.path.abspath(inArgs.in_dir))

    input_files = [[ inArgs.t1full,":colormap=grayscale"]]

    optional_files = [[inArgs.t2flair, ":visible=0:colormap=grayscale"]]

    template_root_dir = os.getenv("TEMPLATES_PATH")

    if inArgs.template == "ixi":
        template_dir = os.path.join(os.getenv('TEMPLATE_IXI'),"cerebellum")
        template_prefix = "ixiTemplate2"

        e_option = os.path.join(template_dir, template_prefix + "_e_T1wFullImage.nii.gz")
        t_option = os.path.join(template_dir, template_prefix + "_t_T1wSkullStripped.nii.gz")
        m_option = os.path.join(template_dir, template_prefix + "_m_BrainCerebellumProbabilityMask.nii.gz")
        f_option = os.path.join(template_dir, template_prefix + "_f_BrainCerebellumExtractionMask.nii.gz")
        p_option = os.path.join(template_dir, "priors%d.nii.gz")

        p1_option = os.path.join(template_dir, "priors1.nii.gz")
        p2_option = os.path.join(template_dir, "priors2.nii.gz")
        p3_option = os.path.join(template_dir, "priors3.nii.gz")
        p4_option = os.path.join(template_dir, "priors4.nii.gz")
        p5_option = os.path.join(template_dir, "priors5.nii.gz")
        p6_option = os.path.join(template_dir, "priors6.nii.gz")

    elif inArgs.template == "inia19":

        template_dir = os.getenv('TEMPLATE_INIA19')
        template_prefix = "inia19"

        e_option = os.path.join(template_dir, template_prefix + "_e_T1wFullImage.nii.gz")
        t_option = os.path.join(template_dir, template_prefix + "_t_T1wSkullStripped.nii.gz")
        m_option = os.path.join(template_dir, template_prefix + "_m_BrainProbabilityMask.nii.gz")
        f_option = os.path.join(template_dir, template_prefix + "_f_BrainExtractionMask.nii.gz")
        p_option = os.path.join(template_dir, template_prefix + "_priors0%d.nii.gz")

        p1_option = os.path.join(template_dir, template_prefix + "_priors01.nii.gz")
        p2_option = os.path.join(template_dir, template_prefix + "_priors02.nii.gz")
        p3_option = os.path.join(template_dir, template_prefix + "_priors03.nii.gz")
        p4_option = os.path.join(template_dir, template_prefix + "_priors04.nii.gz")
        p5_option = os.path.join(template_dir, template_prefix + "_priors05.nii.gz")
        p6_option = os.path.join(template_dir, template_prefix + "_priors06.nii.gz")

    else:
        e_option = None
        t_option = None
        m_option = None
        f_option = None
        p_option = None

        p1_option = None
        p2_option = None
        p3_option = None
        p4_option = None
        p5_option = None
        p6_option = None

        print("Unknown template")
        quit()

    # Initialize input and output files.  A better way to do this is with dictionaries instead of arrays.

    input_directory = os.path.abspath(inArgs.in_dir)

    if os.path.isabs(inArgs.out_dir):
        output_directory = inArgs.out_dir
    else:
        output_directory = os.path.abspath(os.path.join(input_directory, inArgs.out_dir))

    outFull       = os.path.join(output_directory, inArgs.out_prefix)

    output1_files   = [[inArgs.t1full, ":visible=0:colormap=grayscale"],

                       [outFull+"BrainExtractionMask.nii.gz", ":visible=0:colormap=jet:opacity=0.5"],

                       [outFull+"ExtractedBrain0N4.nii.gz", ":visible=1:colormap=grayscale"],

                       [outFull+"BrainSegmentationPosteriors3.nii.gz",
                         ":visible=1:colormap=heat:heatscale=0.1,0.5,1:opacity=0.5"],

                       [outFull+"BrainSegmentationPosteriors2.nii.gz",
                         ":visible=1:colormap=heat:heatscale=0.1,0.5,1:opacity=0.5"],

                       [outFull+"BrainSegmentationPosteriors1.nii.gz",
                         ":visible=0:colormap=jet:colorscale=0.2,0.1:opacity=0.5"]]

    output2_files   = [[t_option, ":visible=1:colormap=grayscale"],
                       [outFull+"BrainNormalizedToTemplate.nii.gz", ":visible=1:colormap=grayscale"]]

    input_files = [[inArgs.t1full,":visible=1:colormap=grayscale"],
                   [inArgs.t2full,":visible=1:colormap=jet:opacity=0.5"],
                   [e_option, ":visible=0:colormap=grayscale"],
                   [t_option, ":visible=0:colormap=grayscale"],
                   [m_option, ":visible=0:colormap=grayscale"],
                   [f_option, ":visible=0:colormap=grayscale"],
                   [p1_option, ":visible=0:colormap=jet"],
                   [p2_option, ":visible=0:colormap=jet"],
                   [p3_option, ":visible=0:colormap=jet"],
                   [p4_option, ":visible=0:colormap=jet"],
                   [p5_option, ":visible=0:colormap=jet"],
                   [p6_option, ":visible=0:colormap=jet"]]

    if inArgs.debug:
        print("inArgs.qi       = " + str(inArgs.qi))
        print("inArgs.qo       = " + str(inArgs.qo))
        print("inArgs.display  = " + str(inArgs.display))
        print("inArgs.debug    = " + str(inArgs.debug))
        print("inArgs.verbose  = " + str(inArgs.verbose))
        print()
        print("template_root_dir = " + template_root_dir)

    # Quality Assurance input
    #

    if inArgs.qi:

        qa.qa_input_files(input_files, inArgs.verbose, False)

        qa.freeview(input_files[:2], inArgs.display, inArgs.verbose)
        qa.freeview(input_files[2:], inArgs.display, inArgs.verbose)


    # Methods
    # 

    stage_output_directory = [os.path.abspath(os.path.join(output_directory, '00-rename')),
                              os.path.abspath(os.path.join(output_directory, '01-brain_extraction')),
                              os.path.abspath(os.path.join(output_directory, '02-segmentation')),
                              os.path.abspath(os.path.join(output_directory, '03-registration'))]

    if inArgs.methods or inArgs.nohup:

        print()
        print('Runnning ants_ct.py')
        print()

        if '1' in inArgs.methods_stage:

            if qa.qa_input_files(input_files, False):

                util.mkcd_dir(stage_output_directory[1], False)
                callCommand = create_command('brain_extraction', stage_output_directory[1])
                util.iw_subprocess(callCommand, inArgs.verbose, inArgs.debug,  inArgs.nohup)

                shutil.copy2(os.path.abspath(os.path.join(stage_output_directory[1], 'BrainExtractionMask.nii.gz')),
                              os.path.abspath(os.path.join(stage_output_directory[1], 'BrainExtractionMask.auto.nii.gz')))

                os.chmod(os.path.abspath(os.path.join(stage_output_directory[1], 'BrainExtractionMask.auto.nii.gz')), stat.S_IRUSR | stat.S_IRGRP | stat.S_IROTH)

            else:
                print("Unable to run ants_ct.py. Failed input QA.")
                qa.qa_exist(input_files, True)
                print()



        if '2' in inArgs.methods_stage:

            if  qa.qa_input_files(input_files, False):

                util.mkcd_dir(stage_output_directory[2], False)
                copy_tree(stage_output_directory[1], stage_output_directory[2])
                callCommand = create_command('segmentation', stage_output_directory[2])
                util.iw_subprocess(callCommand, inArgs.verbose, inArgs.debug,  inArgs.nohup)

            else:
                print("Unable to run ants_ct.py. Failed input QA.")
                qa.qa_exist(input_files, True)
                print()


        if '3' in inArgs.methods_stage:

            if  qa.qa_input_files(input_files, False):

                util.mkcd_dir(stage_output_directory[3], False)
                copy_tree(stage_output_directory[2], stage_output_directory[3])

                callCommand = create_command('registration', stage_output_directory[3])
                util.iw_subprocess(callCommand, inArgs.verbose, inArgs.debug,  inArgs.nohup)

            else:
                print("Unable to run ants_ct.py. Failed input QA.")
                qa.qa_exist(input_files, True)
                print()

    # Quality Assurance output

    if inArgs.qo:

        if qa.qa_exist(output1_files, False):
            qa.freeview(output1_files, inArgs.display, inArgs.verbose)

        else:
            print("Unable to QO iwAntsCT.py. Failed output1 QA.")
            qa.qa_exist(output1_files, True)
            print()

        if qa.qa_exist(output2_files, False):
            qa.freeview(output2_files, inArgs.display)
        else:
            print("Unable to QO iwAntsCT.py. Failed output2 QA.")
            qa.qa_exist(output2_files, True)
            print()
