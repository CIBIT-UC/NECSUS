#!/bin/sh

ROOT_OUPUT='/home/brunomiguel/Documents/data/BIDS_necsus'
ROOT_CODE='/home/brunomiguel/Documents/GitHub/NECSUS/convert-bids-admin/LOCAL/'

heudiconv -d /media/brunomiguel/TOSHIBA\ EXT/NECSUS/{subject}/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s SUBNECSUSUC001 \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite


heudiconv -d /media/brunomiguel/TOSHIBA\ EXT/NECSUS/{subject}/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s SUBNECSUSUC002_1 \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite
