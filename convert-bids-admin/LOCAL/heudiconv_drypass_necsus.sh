#!/bin/sh
ROOT_OUPUT='/media/bruno/DATA/temp'


# heudiconv -d /media/bruno/AndreiaMR/Data_NECSUS/NECSUS-Raw/{subject}/*.IMA \
heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
-s NQUZBUS_DSVAKU_F_1967-11-29_UC136 \
-c none \
-f convertall \
-o $ROOT_OUPUT \
--overwrite
