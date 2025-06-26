#!/usr/bin/env python
# coding: utf-8

import sys
import os
import numpy as np

from glob import glob
from tqdm import tqdm
from tifffile import imread
from csbdeep.utils import Path, normalize
from csbdeep.io import save_tiff_imagej_compatible
from splinedist import fill_label_holes

from skimage import io

from splinedist import random_label_cmap, _draw_polygons, export_imagej_rois
from splinedist.models import SplineDist2D
from splinedist.utils import iou_objectwise, iou

os.environ['CUDA_VISIBLE_DEVICES'] = ''


np.random.seed(6)
lbl_cmap = random_label_cmap()

import os
np.random.seed(6)
lbl_cmap = random_label_cmap()

# Define your custom input and output directories
input_dir = '/home/prodgerlab/Desktop/Images Run'  # folder containing input images (FOV1.tif, FOV2.tif, ...)
model_dir = '/home/prodgerlab/Desktop/Results/models/multichan_DAPICD207'  # path to model directory
output_labels_dir = '/home/prodgerlab/Desktop/Output'  # folder to save output label images
output_rois_dir = '/home/prodgerlab/Desktop/Output'  # folder to save output ROI zip files

# Get list of input image file paths
in_images = sorted(glob(os.path.join(input_dir, 'FOV*-ORIGINAL_ALL_CHANNELS.tif')))

# Generate output file paths
out_labels = [os.path.join(output_labels_dir, f'FOV{i+1}_label.tif') for i in range(len(in_images))]
out_rois = [os.path.join(output_rois_dir, f'FOV{i+1}_roi.zip') for i in range(len(in_images))]

# Load images using the input paths
X = list(map(imread, in_images))

# Convert from channels first to channels last
if X[0].ndim == 3:
    for i in range(len(X)):
        X[i] = np.moveaxis(X[i], 0, -1)

n_channel = 1 if X[0].ndim == 2 else X[0].shape[-1]

axis_norm = (0, 1)  # normalize channels independently
# axis_norm = (0,1,2) # normalize channels jointly

model = SplineDist2D(None, name="splinedist", basedir=model_dir)

for i, out_tif in enumerate(out_labels):
    img = normalize(X[i], 1, 99.8, axis=axis_norm)
    labels, details = model.predict_instances(img, prob_thresh=0.3, nms_thresh=0.4)

    save_tiff_imagej_compatible(out_tif, labels, axes='YX')

    out_zip = out_rois[i]
    export_imagej_rois(out_zip, details['coord'])
