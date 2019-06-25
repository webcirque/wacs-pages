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
				self.languageObject = {};
			};
			let languageOverride = "";
			let currentLanguage = navigator.language;
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
							let linkTo = args.slice(args.indexOf(" --> ") + 5);
							primaryControlled.innerHTML += "<li><a href=\"" + linkTo + "\">" + linkName + "</li>\n";
							break;
						};
						case "show": {
							if (languageObject[currentLanguage]) {
								if (languageObject[currentLanguage][args]) {
									d.innerHTML = languageObject[currentLanguage][args];
								} else {
									d.innerHTML = "Text [$1] is not defined.".replace("$1", args);
								};
							} else {
								if (languageObject["default"][args]) {
									d.innerHTML = languageObject["default"][args];
								} else {
									d.innerHTML = "Text [$1] is not defined.".replace("$1", args);
								};
							}
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
						};
					} else {
						console.error("Interpreter error: No mode announced on bParse requested element which has an index of %i\n%o", f, d);
					};
				};
			});
		});
	};
});