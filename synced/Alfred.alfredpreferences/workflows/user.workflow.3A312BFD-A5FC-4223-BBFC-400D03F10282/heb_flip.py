#!/usr/bin/env python3

import json
import re

# -*- coding: utf-8 -*-

import sys
from maps import *


args = sys.argv[1:]
direct_output = True if "-o" in args else False
if "-o" in args[:-1]:
    args.remove("-o")
lang = args[0]
query = " ".join(args[1:])

heb_icon = "85B31B09-7486-435A-A0A7-2A83BEE74B85.png"
eng_icon = "5EAA025A-A267-432E-9089-0608B2CBE4D3.png"

lang_names = {
    "heb": "Hebrew",
    "eng": "English",
}
lang_icons = {
    "heb": heb_icon,
    "eng": eng_icon,
}


def run(lang, query):
    res = query.lower()
    lang_map = lang_maps[lang]
    for k, v in lang_map.items():
        res = res.replace(k, v)
    return res


def make_res_item(lang, res):
    return {
        "title": f"Flipped '{res}' to {lang_names[lang]}",
        "subtitle": f"Copy '{res}' to clipboard",
        "arg": [res],
        "icon": {"path": lang_icons[lang]},
        "copy": res,
    }


all_langs = lang_maps.keys()

out = {"items": []}

if lang != "":
    out["items"] = [make_res_item(lang, run(lang, query))]
else:
    out["items"] = [make_res_item(l, run(l, query)) for l in all_langs]

if re.match(r"[a-z]", query):
    out["items"] = out["items"][::-1]

res = json.dumps(out)
if direct_output:
    res = " ".join(out["items"][0]["arg"])

sys.stdout.write(res)
