#!/bin/sh
ROOT_OUPUT='/media/bruno/DATA/temp'


# heudiconv -d /media/bruno/AndreiaMR/Data_NECSUS/NECSUS-Raw/{subject}/*.IMA \
heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
-s UQUGEOK_WORWRLIN_M_1946-12-13_UC028V2 \
-c none \
-f convertall \
-o $ROOT_OUPUT \
--overwrite
