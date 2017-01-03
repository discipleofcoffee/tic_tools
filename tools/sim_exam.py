#!/usr/bin/env python

"""
create volume brain mask from pial surface and aseg
"""
import sys
import argparse
from nilearn import plotting, image
import matplotlib.pyplot as plt


# ======================================================================================================================
# region Main Function
#

def plot_overlay(background, overlay, xyz_direction, ncuts, figure_name='figure1'):

    cuts = plotting.find_cut_slices(image.load_img(background), direction=xyz_direction, n_cuts=ncuts, spacing='auto')

    for ii,jj in enumerate(cuts):

        plotting.plot_stat_map(overlay, bg_img=background, cmap=plt.cm.jet, black_bg=True,
                                         display_mode=xyz_direction, cut_coords=7, threshold=3, alpha = 0.5,
                                         output_file='overlay_{0}_{1:03}'.format(xyz_direction, ii) + '.png')

    plotting.plot_glass_brain(overlay, cmap=plt.cm.jet, colorbar=True,
                              display_mode='ortho', threshold=3, alpha=0.5,
                              output_file='glass_brain.png')
#endregion

# ======================================================================================================================
# region Main Function
#

def main():
    ## Parsing Arguments
    #
    #

    usage = "usage: %prog [options] arg1 arg2"

    parser = argparse.ArgumentParser(prog='create_pial_mask')

    parser.add_argument('background', help="Background Image")
    parser.add_argument('overlay', help="Overlay Image")
    parser.add_argument('--dir', help="Direction", choices=['x','y','z','ortho'], default='z')
    parser.add_argument('--nslices', help="Number of slices",type=int, default=10)

    inArgs = parser.parse_args()

    plot_overlay(inArgs.background, inArgs.overlay, inArgs.dir, inArgs.nslices)


#endregion

if __name__ == "__main__":
    sys.exit(main())

