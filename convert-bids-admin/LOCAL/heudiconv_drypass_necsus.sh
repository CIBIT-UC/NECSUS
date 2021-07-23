#!/bin/sh
ROOT_RAWDATA="/media/brunomiguel/TOSHIBA\ EXT/NECSUS"
ROOT_OUPUT='/home/brunomiguel/Documents/data/BIDS_necsus'


heudiconv -d /media/brunomiguel/TOSHIBA\ EXT/NECSUS/{subject}/*.dcm \
-s SUBNECSUSUC001 \
-c none \
-f convertall \
-o $ROOT_OUPUT \
--overwrite
