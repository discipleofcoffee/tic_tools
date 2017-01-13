#!/usr/bin/env python
"""
   Call antsCorticalThickness.sh in stages. This was a misguided attempt to understand antsCorticalThickness.sh.
   Users should just use ants_ct.py instead.
"""

import sys      
import os                                               # system functions
import glob
import shutil
import distutils

import argparse
import subprocess
import _qa_utilities as qa
import _utilities as util


def clean( imageFile ):

     delete_files = glob.glob('[0-1][0-9]'+ imageFile + '*')

     for ii in delete_files:
          os.remove( ii )


#
# Main Function
#

if __name__ == "__main__":

     ## Parsing Arguments
     #
     #

     usage = "usage: %prog [options] arg1 arg2"

     class MyParser(argparse.ArgumentParser):
         def error(self, message):
             sys.stderr.write('error: %s\n' % message)
             self.print_help()
             sys.exit(2)

     parser = argparse.ArgumentParser(prog='ants_ct')
     parser.add_argument("--t1full",          help="Full T1w image (default = t1w.nii.gz )", default = "t1w.nii.gz" )
     parser.add_argument("--t2full",          help="T2 TSE used in QI and QO (default = None )", default = None )
     parser.add_argument("--t2flair",         help="T2 Flair used in QI and QO (default = None )", default = None )
     parser.add_argument("--indir",           help="Input directory", default = os.getcwd() )
     parser.add_argument("--outdir",          help="Output directory", default = '../methods/' )
     parser.add_argument("--outprefix",       help="Output prefix", default = "" )
     parser.add_argument("-d","--display",    help="Display Results", action="store_true", default=False )
     parser.add_argument("-t","--template",   help="Template", default='inia19', choices=['inia19', 'ixi'])
     parser.add_argument("-v","--verbose",    help="Verbose flag",      action="store_true", default=False )
     parser.add_argument("--debug",           help="Debug flag",      action="store_true", default=False )
     parser.add_argument("--clean",           help="Clean directory by deleting intermediate files",      action="store_true", default=False )
     parser.add_argument("--qi",              help="QA inputs",      action="store_true", default=False )
     parser.add_argument("--qo",              help="QA outputs",      action="store_true", default=False )
     parser.add_argument("--nohup",           help="nohup",           action="store_true", default=False )
     parser.add_argument("-r", "--run",       help="Run processing pipeline",      action="store_true", default=False )

     inArgs = parser.parse_args()

     # Change director to input directory
     os.chdir( os.path.abspath(inArgs.indir) )

     input_files = [[ inArgs.t1full,":colormap=grayscale"]]

     optional_files = [[inArgs.t2flair, ":visible=0:colormap=grayscale"]]

     template_root_dir =  os.getenv("IMAGEWAKE2_TEMPLATES")
     print(template_root_dir)

     if inArgs.template == "ixi":
          template_dir    =  os.path.join(template_root_dir,"ixi/cerebellum/")
          template_prefix = "ixiTemplate2"

          e_option = template_dir +  template_prefix + "_e_T1wFullImage.nii.gz"
          t_option = template_dir +  template_prefix + "_t_T1wSkullStripped.nii.gz"
          m_option = template_dir +  template_prefix + "_m_BrainCerebellumProbabilityMask.nii.gz"
          f_option = template_dir +  template_prefix + "_f_BrainCerebellumExtractionMask.nii.gz"
          p_option = template_dir + "priors%d.nii.gz"
          
          p1_option = template_dir + "priors1.nii.gz"
          p2_option = template_dir + "priors2.nii.gz"
          p3_option = template_dir + "priors3.nii.gz"
          p4_option = template_dir + "priors4.nii.gz"
          p5_option = template_dir + "priors5.nii.gz"
          p6_option = template_dir + "priors6.nii.gz"

     elif inArgs.template == "inia19":

          template_dir    = os.path.join(template_root_dir, "inia19_rhesus_macaque")
          template_prefix = "inia19"

          e_option = os.path.join( template_dir, template_prefix + "_e_T1wFullImage.nii.gz")
          t_option = os.path.join( template_dir, template_prefix + "_t_T1wSkullStripped.nii.gz")
          m_option = os.path.join( template_dir, template_prefix + "_m_BrainProbabilityMask.nii.gz")
          f_option = os.path.join( template_dir, template_prefix + "_f_BrainExtractionMask.nii.gz")
          p_option = os.path.join( template_dir, template_prefix + "_priors0%d.nii.gz")
          
          p1_option = os.path.join( template_dir, template_prefix + "_priors01.nii.gz")
          p2_option = os.path.join( template_dir, template_prefix + "_priors02.nii.gz")
          p3_option = os.path.join( template_dir, template_prefix + "_priors03.nii.gz")
          p4_option = os.path.join( template_dir, template_prefix + "_priors04.nii.gz")
          p5_option = os.path.join( template_dir, template_prefix + "_priors05.nii.gz")
          p6_option = os.path.join( template_dir, template_prefix + "_priors06.nii.gz")
          
     else:
          print "Unknown template"
          quit()

     out_directory = os.path.abspath(inArgs.outdir)
     outFull       = os.path.join(out_directory, inArgs.outprefix)

     output1_files   = [[ inArgs.t1full,                                ":visible=0:colormap=grayscale"],
                       [ outFull+"BrainExtractionMask.nii.gz",          ":visible=0:colormap=jet:opacity=0.5"],
                       [ outFull+"ExtractedBrain0N4.nii.gz",            ":visible=1:colormap=grayscale"],
                       [ outFull+"BrainSegmentationPosteriors3.nii.gz", ":visible=1:colormap=heat:heatscale=0.1,0.5,1:opacity=0.5"],
                       [ outFull+"BrainSegmentationPosteriors2.nii.gz", ":visible=1:colormap=heat:heatscale=0.1,0.5,1:opacity=0.5"],
                       [ outFull+"BrainSegmentationPosteriors1.nii.gz", ":visible=0:colormap=jet:colorscale=0.2,0.1:opacity=0.5"]]

     output2_files   = [[ t_option,                                    ":visible=1:colormap=grayscale"],
                        [ outFull+"BrainNormalizedToTemplate.nii.gz",  ":visible=1:colormap=grayscale"            ]]



     input_files = [[ inArgs.t1full,":visible=1:colormap=grayscale"],
                    [ inArgs.t2full,":visible=1:colormap=jet:opacity=0.5"],
                    [ e_option, ":visible=0:colormap=grayscale"],
                    [ t_option, ":visible=0:colormap=grayscale"],
                    [ m_option, ":visible=0:colormap=grayscale"],
                    [ f_option, ":visible=0:colormap=grayscale"],
                    [ p1_option, ":visible=0:colormap=jet"],
                    [ p2_option, ":visible=0:colormap=jet"],
                    [ p3_option, ":visible=0:colormap=jet"],
                    [ p4_option, ":visible=0:colormap=jet"],
                    [ p5_option, ":visible=0:colormap=jet"],
                    [ p6_option, ":visible=0:colormap=jet"]]
     
     if inArgs.debug:
         print "inArgs.qi       = " +  str(inArgs.qi)
         print "inArgs.qo       = " +  str(inArgs.qo)
         print "inArgs.display  = " +  str(inArgs.display)
         print "inArgs.debug    = " +  str(inArgs.debug)
         print "inArgs.verbose  = " +  str(inArgs.verbose)
         print
         print "template_root_dir = " + template_root_dir




     # Quality Assurance input
     #
         
     if  inArgs.qi:

         qa.qa_input_files( input_files, inArgs.verbose, False )

         qa.freeview( input_files[:2], inArgs.display, inArgs.verbose )
         qa.freeview( input_files[2:], inArgs.display, inArgs.verbose )

     
     # Run    
     # 
   
     if  inArgs.run or inArgs.nohup:

          print("\nRunnning ants_ct.py\n")

          if  qa.qa_input_files( input_files, False):

               if not os.path.exists( out_directory ):
                    os.makedirs( out_directory )

               callCommand = ["antsCorticalThickness.sh", "-d", "3", "-t", t_option, "-w", "0.25",
                          "-e", e_option, "-m", m_option, "-f", f_option, "-p", p_option, "-o", inArgs.outdir + "/" + inArgs.outprefix ]
               
               callCommand = callCommand + [ "-a", inArgs.t1full ] 

               if not inArgs.t2full == None:
                    callCommand = callCommand + [ "-a", inArgs.t2full ] 

               if not inArgs.t2flair == None:
                    callCommand = callCommand + [ "-a", inArgs.t2flair ] 
                     
               util.iw_subprocess( callCommand, inArgs.verbose, inArgs.debug,  inArgs.nohup )

          else:
               print("Unable to run iwAntsCT.py. Failed input QA.")
               qa.qa_exist( input_files, True )
               print()


     # Quality Assurance output
     #

     if  inArgs.qo:

          if qa.qa_exist(output1_files, False):
               qa.freeview( output1_files, inArgs.display, inArgs.verbose ) 

          else:
               print("Unable to QO iwAntsCT.py. Failed output1 QA.")
               qa.qa_exist( output1_files, True )
               print()

          if qa.qa_exist(output2_files, False ):
               qa.freeview( output2_files, inArgs.display ) 
          else:
               print("Unable to QO iwAntsCT.py. Failed output2 QA.")
               qa.qa_exist( output2_files, True )
               print()
