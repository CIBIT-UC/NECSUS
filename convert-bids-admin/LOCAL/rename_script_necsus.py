#!/usr/bin/env python
import sys

subj_map = {
   'SUBNECSUSUC024': '24',
   'SUBNECSUSUC025': '25',
   'SUBNECSUSUC026': '26',
   'SUBNECSUSUC027': '27',
   'SUBNECSUSUC028': '28',
   'SUBNECSUSUC029': '29',
   'SUBNECSUSUC030': '30',
   'SUBNECSUSUC031': '31',
   'SUBNECSUSUC032': '32',
   'SUBNECSUSUC033': '33',
   'SUBNECSUSUC034': '34',
}


sid = sys.argv[-1]
if sid in subj_map:
    print(subj_map[sid])
