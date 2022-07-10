#!/usr/bin/env python
import json
# -*- coding: utf-8 -*-

import sys
from maps import *

# sys.stdout.write("args: " + str(sys.argv) + "\n")

args = sys.argv[1:]
lang = args[0]
query = " ".join(args[1:])


def run(lang, query):
    res = query.lower()
    lang_map = to_heb_map if lang == "heb" else to_eng_map
    for k, v in lang_map.items():
        res = res.replace(k, v)
    return res


res = run(lang, query)

out = {
    "items": [
        {
            "title": f"Copy {res}",
            "subtitle": f"Copy {res} to clipboard",
            "arg": res,
            "icon": "85B31B09-7486-435A-A0A7-2A83BEE74B85.png" if lang == "heb" else "5EAA025A-A267-432E-9089-0608B2CBE4D3.png",
        }
    ]
}

# sys.stdout.write("args: " + str(args) + "\n")
# sys.stdout.write("lang: " + str(lang) + "\n")
# sys.stdout.write("query: " + str(query) + "\n")

sys.stdout.write(json.dumps(out))
