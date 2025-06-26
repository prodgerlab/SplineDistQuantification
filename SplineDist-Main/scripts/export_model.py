#!/usr/bin/env python

from splinedist.models import SplineDist2D

model_dir = snakemake.input.model_dir
out_model_zip = snakemake.output.model_zip

model = SplineDist2D(None, name='splinedist', basedir=model_dir)
model.export_TF(fname=out_model_zip)



