"use strict";
const alfy = require("alfy");
const search = require("./search");

const q = new RegExp(`^${alfy.input}*`, "i");

(async () => {
  const data = await alfy.fetch("https://docs.flutter.io/flutter/index.json", {
    json: true,
    maxAge: 3600000 // Cache for one hour
  });

  const items = search(alfy.input, data).map(result => {
    return {
      title: `${result.name} ${result.type.toLowerCase()}`,
      subtitle: result.enclosedBy ? `from ${result.enclosedBy.name}` : "",
      arg: `https://docs.flutter.io/flutter/${result.href}`,
      mods: {
        cmd: {
          subtitle: result.qualifiedName
        }
      },
      quicklookurl: `https://docs.flutter.io/flutter/${result.href}`,
    };
  });

  alfy.output(items);
})();
