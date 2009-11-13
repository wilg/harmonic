
function displayCurrentVersion() {
	var currentVersion = getPlistProperty("Info", "CFBundleVersion");
	$("versioninfo").innerHTML = "v" + currentVersion;
}

function checkForNewVersion() {
	
	var currentVersion = trim(getPlistProperty("Info", "CFBundleVersion"));
	var url = "http://mindquirk.com/sparkle/harmonic.txt"
	var request = new XMLHttpRequest();
	
	request.overrideMimeType("text/plain");
	request.open("GET", url);
	request.setRequestHeader("Cache-Control", "no-cache");
	request.onload = function() {
		 if(request.readyState == 4) {
		 	if(request.responseText) {
		 		try {
					var version = trim(trimVersion(request.responseText));

		 			if(version > currentVersion) {
		 				var badge = $("update");
		 				badge.show();
		 			}
			 	} catch(e) {
			 	}
		 	}
		 }
	}
	
	request.send(null);
}

function getPlistProperty(filename, property){
	if( (filename == null) || (filename == "") ){ return null; }
	if( (property == null) || (property == "") ){ return null; }
	return trim(widget.system('/bin/sh -c "defaults read `pwd`/'+ filename + ' ' + property + '"',null).outputString);
}

function trim( lString ){
	var re = new RegExp ('[\r\n]', 'gi') ; 
	return lString.replace(re, "");
}

function trimVersion( lString ){
	var re = new RegExp ('f', 'gi');
	return lString.replace(re, "");	
}
