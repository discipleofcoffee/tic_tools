#!/aging1/software/anaconda/bin/python
"""
"""

import sys      
import os                                               # system functions
import errno
import glob
import re
import subprocess
import nibabel as nb
import numpy   as np
import shutil



def  freeview( fileList, displayFlag=False, verboseFlag=False ):

    freeviewCommand = "freeview "

    for ii in fileList:

        if (ii[0] != None) and os.path.isfile(ii[0]): 
            
            if ( ( ii[0].endswith(".nii.gz") or ii[0].endswith(".nii")) and
                 ( ii[1] != None) ) :
                
                freeviewCommand = freeviewCommand + " " + str(ii[0]) + str(ii[1])
                
     
    if displayFlag:
        DEVNULL = open(os.devnull, 'wb')
        pipe = subprocess.Popen([freeviewCommand], shell=True,
                                stdin=DEVNULL, stdout=DEVNULL, stderr=DEVNULL, close_fds=True)



def extract_participant_id( in_dir, pattern ):

     match = re.findall( pattern, in_dir )
     
     if not len(match) == 1:
          sys.exit( 'Participant ID not found')

     return match[0]


def path_relative_to(in_directory, in_path):

     if os.path.isabs(in_path):
          out_path = in_path
     else:
          out_path = os.path.abspath(os.path.join(in_directory, in_path )) 

     return out_path



def print_stage( in_stage, verboseFlag=False ):

     if verboseFlag:
          print()
          print('--------------------------------------------------------------------------------------------------------------')
          print('--- ' + in_stage)
          print()



def fslval( input_file, parameter, verboseFlag = False ):

    callCommand = ["fslval", input_file, str(parameter)]

    if verboseFlag:
        print(" ".join(callCommand))

    if os.path.isfile( input_file ):
        pipe = subprocess.Popen(callCommand, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        value = int( pipe.stdout.read() )

        if verboseFlag:
            print(input_file, parameter, value)

    else:
        value = 0
        print("File does not exist.")
        quit()

    return value


def gunzip( gz_filename, verboseFlag=False ):

     [filename, extension ] = os.path.splitext(gz_filename)

     if verboseFlag:
          print(filename, extension)

     if extension == ".gz":
          iw_subprocess( ["gunzip", "-f", gz_filename] )
     else:
          print("iwUtilities.gunzip failed. Not a gzip file")
          quit()

     return filename


def gzip( filename, verboseFlag=False ):

    if verboseFlag:
        print(filename, extension)

    iw_subprocess( ["gzip", "-f", filename] )

    return filename +  ".gz"



def clean( regexp ):

     delete_files = glob.glob( regexp )

     for ii in delete_files:
          os.remove( ii )

def add_prefix_to_filename( filename, prefix):

     tmp           = os.path.split(filename)
     dir_name      = tmp[0]
     base_filename = tmp[1]
     
     return os.path.join(dir_name, prefix + base_filename)


def  insert_suffix_into_filename( filename, suffix, full_extension = ".nii.gz" ):

     import re

     [dir_name, full_filename ]     = os.path.split(filename)
     [ _, extension  ]  = os.path.splitext(full_filename)
 
     index = full_filename.find(extension)

     new_full_filename = os.path.join(dir_name, full_filename[0:index-len(extension)-1] + suffix + full_extension )
 
     return new_full_filename


def insert_into_filename( filename, infix, anchor="" ):

     tmp           = os.path.split(filename)
     dir_name      = tmp[0]
     base_filename = tmp[1]

     pre_base_filename  = anchor
     post_base_filename = base_filename[len(anchor):]

     return os.path.join(dir_name, pre_base_filename + infix + post_base_filename)


def verify_that_files_exist(in_filenames):
    for ii in in_filenames:
        verify_that_file_exists(ii)



def verify_that_file_exists(in_filename):
     
     try:
          with open(in_filename) as file:
               pass
          
     except IOError as e:
          print
          print(in_filename + " does not exist.")
          print
          raise e


#
#
#  http://stackoverflow.com/questions/273192/how-to-check-if-a-directory-exists-and-create-it-if-necessary



def verify_that_path_exists(path):
     
     if not os.path.exists(path):
          try:
               os.makedirs(path)
          except OSError as exception:
               if exception.errno != errno.EEXIST:
                    raise

def make_sure_path_exists(path):
     verify_that_path_exists(path)



def iw_subprocess( callCommand, verboseFlag=False, debugFlag=False,  nohupFlag=False ):

     import datetime

     iiDateTime = datetime.datetime.now()
     timeStamp = iiDateTime.strftime('%Y%m%d%H%M%S')
          
     callCommand = map(str, callCommand)

     if nohupFlag:

          if debugFlag:
               print('Timestamp: %s ' % timeStamp )

          callCommand = ["nohup" ] + callCommand

          stdout_log_file   = 'nohup.stdout.' + timeStamp +'.log'
          stderr_log_file   = 'nohup.stderr.' + timeStamp +'.log' 
          
          if verboseFlag or debugFlag:
               print()
               print(" ".join(callCommand))
               print(stdout_log_file)
               print()

          # http://stackoverflow.com/questions/6011235/run-a-program-from-python-and-have-it-continue-to-run-after-the-script-is-kille                   

          subprocess.Popen( callCommand,
                            stdout=open(stdout_log_file, 'w'),
                            stderr=open(stderr_log_file, 'w'),
                            preexec_fn=os.setpgrp, 
                            )

          if verboseFlag or debugFlag:
               print()

     else:

          if debugFlag:
               print
               print " ".join(callCommand)
               print

          pipe   = subprocess.Popen(callCommand, stdout=subprocess.PIPE)
          output = pipe.communicate()[0]

          if debugFlag:
               print
               print output
               print




def  check_files(fileList, verboseFlag=False):
    
    qaInputStatus = True
    
    if verboseFlag:
        print
        
    for ii in fileList:

        if os.path.isfile(ii): 
            
            if verboseFlag:
                print str( ii ) + " exists"
                
        else:                
            qaInputStatus = False
                    
            if verboseFlag:
                strError = str( ii ) + " does not exist"
                print strError
            
     
    if verboseFlag:
        print
        print "All files exist = " + str(qaInputStatus)
        print
        
    return qaInputStatus
    

def save_image_affine_matrix(in_image, out_affine, verbose_flag=False):

     img = nb.load(in_image)
     header = img.get_header()

     img_affine_matrix = np.asarray(img.get_affine())

     write_itk_affine_matrix( img_affine_matrix, out_affine, verbose_flag )



def write_itk_affine_matrix(affine_matrix, origin,  out_affine_filename, verbose_flag=False):

     if verbose_flag:
          print "\n" + out_affine_filename + " affine matrix ...\n" 
          print affine_matrix

     try:
          with open(out_affine_filename, 'w') as file:

               file.write('#Insight Transform File V1.0 \n');
               file.write('#Transform 0 \n');
               file.write('Transform: MatrixOffsetTransformBase_double_3_3 \n');
               file.write( 'Parameters: {0} {1} {2} \t {3} {4} {5} \t {6} {7} {8} \t {9} {10} {11}\n\n'.format(
                         str(affine_matrix[0,0]),str(affine_matrix[0,1]),str(affine_matrix[0,2]), 
                         str(affine_matrix[1,0]),str(affine_matrix[1,1]),str(affine_matrix[1,2]), 
                         str(affine_matrix[2,0]),str(affine_matrix[2,1]),str(affine_matrix[2,2]), 
                         str(affine_matrix[0,3]),str(affine_matrix[1,3]),str(affine_matrix[2,3]))) 
               
               file.write('FixedParameters: {0} {1} {2}\n\n'.format( origin[0], origin[1], origin[2]  ))  # origin set to 0,0,0
               
               file.close()

          
     except IOError as e:
          print
          raise e




def mkcd_dir( in_directories, cdFlag=True ):

     # Force directories to be list even if passed in as string
     if isinstance(in_directories, str):
          directories = [in_directories]
     elif isinstance(in_directories, list):
          directories = in_directories
     else:
          raise ValueError
 
     # Create directories if they exist one at a time
     for ii in directories:
          if not os.path.exists( ii  ):
               os.makedirs( ii )

     # Change directory to last directory in list
     if cdFlag:
          os.chdir( directories[-1] )

def is_writable( filepath ):

     try:
          filehandle = open( filepath, 'w' )
     except IOError:
          sys.exit( 'Unable to write to file ' + filepath )



def verify_outputs( output_files, debugFlag=False ):

     if debugFlag:
          print
          print 'Verifying outputs ...'
          print

     verify_files( output_files, debugFlag)


def verify_inputs( input_files, debugFlag=False ):

     if debugFlag:
          print
          print 'Verifying inputs ...'
          print

     # Flatten list of list with sum(input_files,[])
     # http://stackoverflow.com/questions/952914/making-a-flat-list-out-of-list-of-lists-in-python

     verify_files( input_files, debugFlag)



def verify_files( input_files, debugFlag ):

     status = True  # Assume all files are present

     missing_files = []
     
     for ii in input_files:

          try:
               with open(ii) as file:

                    if debugFlag:
                         print ii
          
          except IOError as e:
               missing_files = missing_files + [ ii ] 
               status = False

     if status == False:
          
          for ii in missing_files:
               print ii + " does not exist"
          
          print
          sys.exit('Aborting processing. Missing input files.')

     if debugFlag:
          print



def force_hard_link( in_source, in_target, debug=False):

     if os.path.exists(in_source):

         if debug:
             print
             print in_source
             print in_target
             print 'os.path.exists( in_target )', os.path.exists( in_target )
             print 'os.path.islink( in_target )', os.path.islink( in_target )
             print 'os.path.isfile( in_target )', os.path.isfile( in_target )
             print

         if os.path.islink(in_target):
             os.unlink(in_target)
             
         if os.path.isfile(in_target):
             os.remove(in_target)
         
         if debug:
             print 'os.link(' + in_source + ',' + in_target +')'

         os.link(in_source, in_target)

     else:
          sys.exit( in_source + ' does not exist. Unable to create hard link. ')


def force_symbolic_link( in_source, in_target,debug=False):

     if os.path.exists(in_source):

         if debug:
             print
             print in_source
             print in_target
             print 'os.path.exists( in_target )', os.path.exists( in_target )
             print 'os.path.islink( in_target )', os.path.islink( in_target )
             print 'os.path.isfile( in_target )', os.path.isfile( in_target )
             print

         if os.path.islink(in_target):
             os.unlink(in_target)
                 
         if os.path.isfile(in_target):
             os.remove(in_target)

         os.symlink(in_source, in_target)

     else:
          sys.exit( in_source + ' does not exist. Unable to create symbolic link. ')


def link_inputs( input_files, link_directory ):

     for ii in input_files:
          ii_basename = os.path.basename(ii)

          ii_link_target_name = os.path.abspath( os.path.join( link_directory, ii_basename ))
          force_hard_link( ii, ii_link_target_name )



def copy_inputs( input_files, link_directory ):

     for ii in input_files:
         ii_link_target_name = os.path.abspath( os.path.join( link_directory, os.path.basename(ii)))
          
         if not os.path.exists( ii_link_target_name ):
             shutil.copy(ii, ii_link_target_name )


def  freeview( fileList, displayFlag=True, verboseFlag=False ):

    freeviewCommand = "freeview "

    for ii in fileList:

        if (ii[0] != None) and os.path.isfile(ii[0]): 
            
            if ( ( ii[0].endswith(".nii.gz") or ii[0].endswith(".nii")) and
                 ( ii[1] != None) ) :
                
                freeviewCommand = freeviewCommand + " " + str(ii[0]) + str(ii[1])
                
     
    if displayFlag:
        DEVNULL = open(os.devnull, 'wb')
        pipe = subprocess.Popen([freeviewCommand], shell=True,
                                stdin=DEVNULL, stdout=DEVNULL, stderr=DEVNULL, close_fds=True)


def  fslview( fileList, verboseFlag=False ):

    for ii in fileList:

        if os.path.isfile(ii): 
            
            if  ( ii.endswith(".nii.gz") or ii.endswith(".nii") ):

                fslviewCommand = [ 'fslview', str(ii) ]
                
                if verboseFlag:
                     print fslviewCommand

                DEVNULL = open(os.devnull, 'wb')
                pipe = subprocess.Popen(fslviewCommand, shell=True,
                                        stdin=DEVNULL, stdout=DEVNULL, stderr=DEVNULL, close_fds=True)


def wras_to_wlps_matrix():
     return np.asarray([[ -1, 0, 0, 0], [0, -1, 0, 0], [0,0,1,0], [0,0,0,1]])     


def wlps_to_wras_matrix():
     return np.asarray([[ -1, 0, 0, 0], [0, -1, 0, 0], [0,0,1,0], [0,0,0,1]])     




def extract_affine(in_image, out_affine_filename, lps_flag=False, lps_save_flag=False, verbose_flag=False):

     img           = nb.load(in_image)
     header        = img.get_header()

     # Save transform

     affine_wras_to_wlps = wras_to_wlps_matrix();
     affine_iras_to_wras = np.asarray(img.get_affine())

     if lps_flag:
          out_affine = np.dot(affine_wras_to_wlps, affine_iras_to_wras)
#          out_affine = np.dot(affine_iras_to_wras, affine_wras_to_wlps)
     else:
          out_affine = affine_iras_to_wras
          
     # Save RAS to LPS transform          
     
     if lps_save_flag:
          write_itk_affine_matrix( affine_wras_to_wlps, [0,0,0], 'lps.'+ out_affine_filename, verbose_flag )

     write_itk_affine_matrix(out_affine, [0,0,0], out_affine_filename, verbose_flag )
