#!/usr/bin/env python
import sys

subj_map = {
   'SUBNECSUSUC001': '01',
   'SUBNECSUSUC002_1': '02',
   'SUBNECSUSUC003': '03',
   'SUBNECSUSUC004': '04',
   'SUBNECSUSUC005': '05',
}


sid = sys.argv[-1]
if sid in subj_map:
    print(subj_map[sid])
