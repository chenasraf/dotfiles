#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
from maps import *

# sys.stdout.write("args: " + str(sys.argv) + "\n")

args = sys.argv[1:]
lang = args[0]
query = " ".join(args[1:])

res = query.lower()
lang_map = to_heb_map if lang == "heb" else to_eng_map
for k, v in lang_map.items():
    res = res.replace(k, v)

# sys.stdout.write("args: " + str(args) + "\n")
# sys.stdout.write("lang: " + str(lang) + "\n")
# sys.stdout.write("query: " + str(query) + "\n")

sys.stdout.write(res)
