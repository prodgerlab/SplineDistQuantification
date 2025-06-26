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

np.random.seed(6)
lbl_cmap = random_label_cmap()

import os
np.random.seed(6)
lbl_cmap = random_label_cmap()


in_images = snakemake.input.images
model_dir = snakemake.input.model_dir
out_labels = snakemake.output.labels
out_rois = snakemake.output.fiji_rois


X = list(map(imread,in_images))

#convert from channels first to channels last
if X[0].ndim == 3:
    for i in range(len(X)):
        X[i] = np.moveaxis(X[i], 0, -1)

n_channel = 1 if X[0].ndim == 2 else X[0].shape[-1]

axis_norm = (0,1)   # normalize channels independently
# axis_norm = (0,1,2) # normalize channels jointly

model = SplineDist2D(None, name="splinedist", basedir=model_dir)
#model = SplineDist2D(None, name="splinedist", basedir="/home/prodgerlab/Desktop/Results/models/multichan_DAPICD68")

for i,out_tif in enumerate(out_labels):
    img = normalize(X[i], 1,99.8, axis=axis_norm)
    labels, details = model.predict_instances(img, prob_thresh=0.1, nms_thresh=0.4)

    save_tiff_imagej_compatible(out_tif, labels, axes='YX')

    out_zip = out_rois[i]
    export_imagej_rois(out_zip, details['coord'])