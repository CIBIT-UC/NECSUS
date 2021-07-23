#!/bin/sh

ROOT_OUPUT='/home/brunomiguel/Documents/data/BIDS_necsus'
ROOT_CODE='/home/brunomiguel/Documents/GitHub/NECSUS/convert-bids-admin/LOCAL/'

heudiconv -d /media/brunomiguel/TOSHIBA\ EXT/DATA_Carlos_PhD_Final/{subject}/*/DATA/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_vswp.py \
-s BrunoDireito \
--ses 001 \
-f $ROOT_CODE/heuristic_vswp.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite
