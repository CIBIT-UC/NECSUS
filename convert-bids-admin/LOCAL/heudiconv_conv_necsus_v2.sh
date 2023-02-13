#!/bin/sh

ROOT_OUPUT='/media/bruno/DATA/BIDS_necsus'
ROOT_CODE='/home/bruno/Documents/GitHub/NECSUS/convert-bids-admin/LOCAL'


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*.IMA \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s ALZIRAQUATORZE \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus_old.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*.IMA \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s DOMINGOSPIRESFERNANDES \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus_old.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*.IMA \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s CIDALINAFREITAS \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus_old.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*.IMA \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s MARIASILVA \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus_old.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*.IMA \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s ARISTIDESMARTINS \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus_old.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*.IMA \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s JOSELUISSANTOSQUATOPRZE \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus_old.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*.IMA \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s ANTONIOROCHA \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus_old.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*.IMA \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s MARIASOUSA \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus_old.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*.IMA \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s MARIAMARTINS \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus_old.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*.IMA \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s MARIACARMOGOMESCRUZSIMOES_3julho2015 \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus_old.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
