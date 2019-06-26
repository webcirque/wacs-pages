"use strict";

document.addEventListener("readystatechange", function () {
	if (this.readyState.toLowerCase() == "interactive") {
		let bParseElements = Array.from(document.getElementsByClassName("bparse"));
		bParseElements.forEach((d, f) => {
			let originalText = CryptoJS.enc.Utf8.stringify(CryptoJS.enc.Base64.parse(d.innerHTML));
			console.info("Text decoded on index %i:\n%s", f, originalText);
			originalText = originalText.split("\n");
			let translatedText = "";
			let mode = "";
			if (!(self.languageObject)) {
				self.languageObject = {
					default: {}
				};
			};
			let languageOverride = "";
			self.currentLanguage = navigator.language;
			let primaryControlled = null;
			originalText.forEach((e, i) => {
				let args = e.trim();
				if (i > 0) {
					switch (mode) {
						case "language": {
							if (e[0] == "[") {
								languageOverride = args.slice(1, args.indexOf("]"));
								console.info("Overriding language: %s", languageOverride);
							} else {
								if (languageOverride == "") {
									console.warn("No languages specified. Overriding default language.");
									languageOverride = "default";
								};
								if (!(languageObject[languageOverride])) {
									languageObject[languageOverride] = {};
								};
								if (languageObject[languageOverride][args.slice(0, args.indexOf("="))]) {
									console.warn("Language string as %s will be overwritten.", args.slice(0, args.indexOf("=")));
								};
								languageObject[languageOverride][args.slice(0, args.indexOf("="))] = args.slice(args.indexOf("=") + 1);
							};
							break;
						};
						case "navigation": {
							let linkName = args.slice(0, args.indexOf(" --> "));
							if (linkName[0] == "$") {
								linkName = getLang(linkName.slice(1));
							};
							let linkTo = args.slice(args.indexOf(" --> ") + 5);
							primaryControlled.innerHTML += "<li><a href=\"" + linkTo + "\">" + linkName + "</a></li>\n";
							break;
						};
						case "show": {
							if (args[0] != "~") {
								d.innerHTML += getLang(args);
							} else {
								d.innerHTML += args.slice(1);
							};
							break;
						};
						default: {
							throw(new Error("No such mode named %s.", mode));
						};
					};
				} else {
					if (e[0] == "[") {
						mode = args.slice(1, args.indexOf("]")).toLowerCase();
						languageOverride = "";
						console.info("Annouced mode: %s", mode);
						if (mode == "navigation") {
							d.innerHTML = "";
							primaryControlled = d.appendChild(document.createElement("ul"));
						} else if (mode == "show") {
							d.innerHTML = "";
						};
					} else {
						console.error("Interpreter error: No mode announced on bParse requested element which has an index of %i\n%o", f, d);
					};
				};
			});
		});
	};
});

function getLang(id) {
	let str = "Text [$1] is not defined.".replace("$1", id);;
	if (languageObject[currentLanguage]) {
		if (languageObject[currentLanguage][id] || languageObject[currentLanguage][id] == "") {
			str = languageObject[currentLanguage][id];
		} else {
			console.warn("Text [$1] is not defined in language $2. Using fallback...".replace("$1", id).replace("$2", currentLanguage));
			if (languageObject["default"][id]) {
				str = languageObject["default"][id];
			} else {
				console.error("Text [$1] is not defined.".replace("$1", id));
			};
		};
	} else {
		if (languageObject["default"][id]) {
			str = languageObject["default"][id];
		} else {
			console.error("Text [$1] is not defined.".replace("$1", id));
		};
	};
	return str;
}