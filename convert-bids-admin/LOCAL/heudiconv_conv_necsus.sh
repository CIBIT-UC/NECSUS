#!/bin/sh

ROOT_OUPUT='/media/bruno/DATA/BIDS_necsus'
ROOT_CODE='/home/bruno/Documents/GitHub/NECSUS/convert-bids-admin/LOCAL'


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s ODRLPT_SFPUPMT_F_1955-01-17_UC070V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

: '
heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s CGTHDG_YRLTP_F_1965-03-04_UC073 \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s JXSPRAUBG_BJZUJBH_F_1965-01-28_UC073V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s WKODEJJ_BBTYGN_M_1954-11-12_UC072V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s QJFPVC_GFRUVSN_F_1958-03-14_UC061 \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s CMHNGZU_QIUUUZ_F_1958-02-23_UC061V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s STOVCCXMP_JCGXM_F_1951-01-25_UC062 \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s XTCRSUZ_YGFGOTKY_F_1951-01-29_UC062V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s KRZLGJ_YLJAC_M_1948-01-01_UC063V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s TTDAUUOSL_JULVQI_M_1971-03-01_UC069 \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s VRLOQX_PDRGLQBB_F_1952-05-12_UC044V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s QBGIANOB_SWDYSZOYJ_F_1946-11-18_UC046V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s RXWXHP_UMWJQWTVD_M_1954-09-16_UC049V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s ODRLPT_SFPUPMT_F_1955-01-17_UC070V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite



heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s AKVYPVTZ_GLIBENCK_F_1970-03-12_UC067V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s FXFXJA_IIDMJGSV_F_1968-03-14_UC066V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s CUSNE_AAOQMVD_M_1946-11-02_UC028V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*.IMA \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s SUBNECSUSUC004V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s EFVURTM_MIJXT_F_1955-07-13_UC017V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s FCIXZ_MAPDFUT_F_1958-11-06_UC022 \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s AFXKUEISW_LAUKIGYCT_F_1959-06-28_UC023 \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s CIRUDYGY_PBWYZHLQ_F_1959-07-21_UC023V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \

--overwrite

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s LSGIOVX_DSFODZY_F_1960-02-04_UC027V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite

heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s UQUGEOK_WORWRLIN_M_1946-12-13_UC028V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite




heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s VRLOQX_PDRGLQBB_F_1952-05-12_UC044V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s OMSYZ_AGMOOD_F_1961-04-11_UC042V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s SOKIX_DWPVGV_F_1955-10-28_UC043V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s QBGIANOB_SWDYSZOYJ_F_1946-11-18_UC046V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s FUJGNWEP_AIXBC_M_1953-12-14_UC047V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s CPJLE_DNZYQ_F_1961-08-01_UC048V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s RXWXHP_UMWJQWTVD_M_1954-09-16_UC049V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s DOKAK_QRVPDSSE_M_1944-07-23_UC050V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s JCFCRXH_LPSKMWXCA_F_1960-04-03_UC031 \
--ses 01 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s FJKHKNMH_SHBTQM_F_1960-04-29_UC031V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s ECIKVLY_ZVWWBUAJS_F_1957-02-07_UC038V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s GQYTYI_NAZBPJD_F_1944-05-09_UC039V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite


heudiconv -d /media/bruno/DATA/NECSUS_RAWDATA/{subject}/*/*/*.dcm \
--anon-cmd $ROOT_CODE//rename_script_necsus.py \
-s DPKMHFOF_ROJNTQFTC_M_1953-08-18_UC040V2 \
--ses 02 \
-f $ROOT_CODE/heuristic_necsus.py \
-c dcm2niix -b \
-o $ROOT_OUPUT \
--overwrite


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