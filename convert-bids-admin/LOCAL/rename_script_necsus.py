#!/usr/bin/env python
import sys

subj_map = {
   'SUBNECSUSUC001': '0001',
   'SUBNECSUSUC002_1': '0002',
   'SUBNECSUSUC003': '0003',
   'SUBNECSUSUC004': '0004',
   'SUBNECSUSUC005': '0005',
}


sid = sys.argv[-1]
if sid in subj_map:
    print(subj_map[sid])
