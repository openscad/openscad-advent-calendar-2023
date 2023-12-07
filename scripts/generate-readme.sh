#!/bin/bash

export TZ=UTC

YEAR=${YEAR:-$(date +%Y)}
URL="https://github.com/openscad/openscad-advent-calendar-${YEAR}/blob/main"

awk '/^##/ { hide = 1} { if (!hide) print $0 }' README.md

nodejs -e '
	var url="https://github.com/openscad/openscad-advent-calendar-2023/blob/main/";
	var setDay = function(idx, o) {
		console.log("## " + idx + ". " + o.dir + " (" + o.author + " | " + o.license + ")");
		console.log("<img src=\"" + url + o.dir + "/" + o.img + "\" width=\"250\">");
		if (o.info) console.log(o.info);
		console.log();
	};

	var fs = require("fs");
	var vm = require("vm");
	var content = fs.readFileSync("./index.js");
	vm.runInThisContext(content);
'
