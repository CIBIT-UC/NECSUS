#!/bin/sh

ROOT_OUPUT='/media/bruno/DATA/BIDS_necsus'
ROOT_CODE='/home/bruno/Documents/GitHub/NECSUS/convert-bids-admin/LOCAL'


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*.IMA \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s SUBNECSUSUC034 \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite
