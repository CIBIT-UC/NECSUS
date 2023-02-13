#!/bin/sh

ROOT_OUPUT='/media/bruno/DATA/BIDS_necsus'
ROOT_CODE='/home/bruno/Documents/GitHub/NECSUS/convert-bids-admin/LOCAL'


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s OVVIO_PSBYYKBWI_M_1957-04-27_UC057V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s LOYUFCF_EKAJC_F_1955-01-31_UC070 \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s FGCZMR_MKTKURSA_F_1947-12-11_UC071 \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s GHVQOC_XDXMCKMT_M_1954-11-20_UC072 \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite






: '
heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s HNNGC_SFXRL_F_1965-09-04_UC064 \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s WKHXXAURJ_NGMWOZXM_F_1968-02-22_UC066 \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s ACTBEXO_IBAQU_F_1970-04-16_UC067 \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite








heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s BOAVF_QRNZL_M_1958-08-26_UC054V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s HYSEQGG_QLEMAGDDB_F_1963-08-28_UC056V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite




heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s ILKHEOQDY_CKCIX_F_1953-01-11_UC051V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s PSCXHPG_LMWTE_F_1953-03-04_UC053V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

'