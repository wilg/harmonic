var splitter = "%@%";

var shouldRefresh = 1;
var refreshTime = 10; //seconds

var prefsHeight = 400;
var prefsWidth = 226;

var originalHeight = 370;
var originalWidth = 196;


var gMyScrollArea;
var gMyScrollbar;


function open_widget() {
    setupScroller();
    // make buttons with apple classes
    var whiteInfoButton = new AppleInfoButton($("infoButton"), $("front"), "white", "white", showPrefs);
    var doneButton = new AppleGlassButton ($("doneButton"), "Done", hidePrefs, 68)
    
    var theTheme = widget.preferenceForKey("theme");
    if (theTheme==undefined){
        theTheme="blue";
        widget.setPreferenceForKey("blue", "theme");
    }
    changeSkin(theTheme);
    
    var theAlign = widget.preferenceForKey("align");
    if (theAlign==undefined){
        theAlign="center";
        widget.setPreferenceForKey("center", "align");
    }
    changeAlign(theAlign);

    var theSize = widget.preferenceForKey("fontsize");
    if (theSize==undefined){
        theSize="14";
        widget.setPreferenceForKey("14", "fontsize");
    }
    changeSize(theSize);
	if (window.widget){
		widget.onshow = onshow;
		widget.onhide = onhide;
	}
	
	var widgetHeight = widget.preferenceForKey(prefkey("widgetHeight"));
    var widgetWidth = widget.preferenceForKey(prefkey("widgetWidth"));

    if (widgetWidth != undefined) {
        window.resizeTo(widgetWidth, widgetHeight);
    }
    
	LyricsMain();
}

function showPrefs(){
    originalHeight = window.outerHeight;
    originalWidth = window.outerWidth;
    if(originalHeight < prefsHeight){
        window.resizeTo(window.outerWidth, prefsHeight);
    }
    if(originalWidth < prefsWidth){
        window.resizeTo(prefsWidth, window.outerHeight);
    }
    read_prefs();
    var front = $("front");
	var back = $("back");
    if (window.widget) widget.prepareForTransition("ToBack");
    front.style.display="none";
    back.style.display="block";
    if (window.widget) setTimeout ('widget.performTransition();', 0);
}

function hidePrefs(){
	LyricsMain();
	var front = $("front");
	var back = $("back");
	if (window.widget) widget.prepareForTransition("ToFront");
	back.style.display="none";
    front.style.display="block";	
	if (window.widget) setTimeout ('widget.performTransition();', 0);
    window.resizeTo(originalWidth, originalHeight);
    gMyScrollArea.refresh(); 
}

 
function setupScroller(){
    gMyScrollbar = new AppleVerticalScrollbar($("myScrollbar"));
    gMyScrollArea = new AppleScrollArea($("parentDiv"));
    gMyScrollArea.addScrollbar(gMyScrollbar);
	gMyScrollArea.scrollsHorizontally = false;
	gMyScrollArea.singlepressScrollPixels = 25;
	gMyScrollArea.focus(); 
	window.onfocus = function () { gMyScrollArea.focus(); }
	window.onblur = function () { gMyScrollArea.blur(); }
}
 

function onshow () {
	LyricsMain();
}

function onhide () {}

function header_clicked() {
}

function itunes_notification_recieved() {
	LyricsMain();
}

function LyricsMain() {

    startFetchingAnimation();
    
	var cursong = $("song_title").innerHTML;
	var curartist = $("song_artist").innerHTML;
    
    var shouldCheckNet = true;

    if ( widget.preferenceForKey("last_played_song") == HarmonicPlugin.currentSongName() ) {
        shouldCheckNet = false;
		alert("NO new song!")
    }
	else {
		alert("new song!")
	}
    
    var theLyrics = HarmonicPlugin.lyricsForCurrentSong(shouldCheckNet);
	if (theLyrics == null) {
		log("Plugin returned null value.")
		warning_image("Plugin Not Responding");
		endFetchingAnimation();
		return;
	}
    
    var spacer = "<div style='height:5px;width:10px;'>&nbsp;</div>";
    alert(theLyrics);
    if (theLyrics.indexOf("<!--error-->") >= 0 || theLyrics == ""){
	    if (theLyrics.indexOf("<!--cantfind-->") >= 0) {
		    warning_image("Can't Find Lyrics");
			appendToolbar("no_lyrics_found");
		}
		else {
			warning_image(theLyrics);
		}
    }
    else if (theLyrics.indexOf("<!--instrumental-->") >= 0){
        instrumental_image("");
    }
    else {
        theLyrics = spacer + theLyrics + spacer;
        $("lyrics").innerHTML = theLyrics;
    }
    if (theLyrics.indexOf("<!--success-->") >= 0){
		appendToolbar("lyrics_found");
    }

	$("song_title").innerHTML = (HarmonicPlugin.currentSongName());
	$("song_artist").innerHTML = (HarmonicPlugin.currentArtistName());
	
    gMyScrollArea.refresh(); 

    widget.setPreferenceForKey(HarmonicPlugin.currentSongName(), "last_played_song");

    endFetchingAnimation();

}

function log(x) {
	alert(x);
}

var defaultTooltipText = "<span class='default'>options</span>";
function appendToolbar(toolbarType) {
	var toolbarHTML = "";
	if (toolbarType == "lyrics_found") {
		// toolbarHTML = "<div class=\"paste_controls\" align=\"center\"><a href=\"#\" onClick=\"clear_lyrics();\" onmouseover=\"ttover('clear lyrics');\" onmouseout=\"ttout();\"><img src=\"images/clear.png\" class=\"toolbar_button\"></a>&nbsp;<div id=\"tooltip\"><strong>tools</strong></div></div>";
		toolbarHTML = '<a href="#" title="Clear Lyrics" onClick="clear_lyrics();"><img src="images/clear.png"></a>';
	}
	else if  (toolbarType == "no_lyrics_found") {
		toolbarHTML = '<a href="#" title="Paste" onClick="paste_lyrics_to_track();"><img src="images/paste.png"></a><a href="#" title="Google" onClick="googleLyrics();"><img src="images/search.png"></a>';
		// toolbarHTML = "<div class='paste_controls'><a href='#' onClick='paste_lyrics_to_track();' onmouseover=\"ttover('paste lyrics');\" onmouseout=\"ttout();\"><img src=\"images/paste.png\" class=\"toolbar_button\"></a>&nbsp;<a href=\"#\" onClick=\"googleLyrics();\" onmouseover=\"ttover('search google');\" onmouseout=\"ttout();\"><img src=\"images/search.png\" class=\"toolbar_button\"></a><div id=\"tooltip\"><strong>tools</strong></div></div>";
	}
	toolbarHTML = "<div id=\"toolbar_container\"><div id=\"toolbar\">" + toolbarHTML + "<span id=\"tooltip\">" + defaultTooltipText + "</span></div></div>";
	var container = $("lyrics");
	if ($("warning") != null) {
		container = $("warning_text");
	}
	container.innerHTML = container.innerHTML + toolbarHTML;
	
	$$("#toolbar a").each(function(link){
		link.onmouseover = function() {
			$("tooltip").innerHTML = this.title;
		};
		link.onmouseout = function() {
			$("tooltip").innerHTML = defaultTooltipText;
		};
	});
}

function changeSkin(theSkin) {
	
	current_classes = $("front").classNames()
	current_classes.each(function(x){$("front").removeClassName(x)});
	$("front").addClassName("theme_" + theSkin);
	widget.setPreferenceForKey(theSkin, "theme");
    
    //set buttons
	try {
		$$(".theme_selector").each(function(name, index) {
		  name.removeClassName("selected");
		});
		$(theSkin + "Button").addClassName("selected");
	}
	catch(err){
		if (theSkin != "blue") {
			changeSkin("blue");
		}
	}

}

function changeAlign(align) {
    setStyleByClass("DIV","mainContent","textAlign", align);
    widget.setPreferenceForKey(align, "align");
    
    //set underlines
    setStyleById("leftAlign", "border", "1px solid white");
    setStyleById("leftAlign", "margin", "3px");
    setStyleById("centerAlign", "border", "1px solid white");
    setStyleById("centerAlign", "margin", "3px");
    setStyleById("rightAlign", "border", "1px solid white");
    setStyleById("rightAlign", "margin", "3px");
    setStyleById(align+"Align", "border", "3px solid white");
    setStyleById(align+"Align", "margin", "1px");
}

function changeSize(theSize) {
    setStyleByClass("DIV","mainContent","fontSize", theSize + "px");
    widget.setPreferenceForKey(theSize, "fontsize");
    
    //set underlines
    setStyleById("11Font", "border", "1px solid white");
    setStyleById("11Font", "margin", "3px");
    setStyleById("12Font", "border", "1px solid white");
    setStyleById("12Font", "margin", "3px");
    setStyleById("14Font", "border", "1px solid white");
    setStyleById("14Font", "margin", "3px");
    setStyleById(theSize+"Font", "border", "3px solid white");
    setStyleById(theSize+"Font", "margin", "1px");
}


function read_prefs(){
    var theTheme = widget.preferenceForKey("theme");
    setStyleById(theTheme+"Button", "textDecoration", "underline");

}

function changeBG(id, theSkin) {
    setStyleById(id, "background", "url('design/harmonic_"+theSkin+"/"+id+".png')")
}

function setStyleById(i, p, v) {
	var n = $(i);
	n.style[p] = v;
}

function setStyleByClass(t,c,p,v){
	var elements;
    elements = document.getElementsByTagName(t);
	for(var i = 0; i < elements.length; i++){
		var node = elements.item(i);
		for(var j = 0; j < node.attributes.length; j++) {
			if(node.attributes.item(j).nodeName == 'class') {
				if(node.attributes.item(j).nodeValue == c) {
					eval('node.style.' + p + " = '" +v + "'");
				}
			}
		}
	}
}

function warning_image(x){
    var theSkin = widget.preferenceForKey("theme");
    var theHTML = "<div id='warning'><img src=\"design/themes/" + theSkin + "/warning.png\" alt=\"error\" /><div id=\"warning_text\">"+x+"</div></div>";

 	$('lyrics').innerHTML=(theHTML);
}

function instrumental_image(x){
    var theSkin = widget.preferenceForKey("theme");
    var theHTML = "<div id='warning'><img src=\"design/themes/" + theSkin + "/instrumental.png\" alt=\"error\" /><div id=\"warning_text\">Instrumental</div></div>";
 	$('lyrics').innerHTML=(theHTML);
}

var fetchingAnimation = {timer: null, alphaNow:1.0, up:false, duration:1000, start:null};

function fetchAnimationTimer ()
{
	var time = (new Date).getTime();
	var fraction;
	
	if (fetchingAnimation.up)
		fraction = (time - fetchingAnimation.start) / fetchingAnimation.duration;
	else
		fraction = 1.0 - (time - fetchingAnimation.start) / fetchingAnimation.duration;
	
	fetchingAnimation.alphaNow = fraction;
	
	if (fetchingAnimation.alphaNow > 1.0)
	{
		fetchingAnimation.start = time;
		fetchingAnimation.alphaNow = 1.0;
		fetchingAnimation.up = false;
	}
	else if (fetchingAnimation.alphaNow < 0.0)
	{
		fetchingAnimation.start = time;
		fetchingAnimation.alphaNow = 0.0;
		fetchingAnimation.up = true;
	}
	
    var sine = Math.sin((Math.PI/2.0) * fetchingAnimation.alphaNow);

    fetchingAnimation.alphaNow = sine * sine;
    
    $('progress').style.opacity = fetchingAnimation.alphaNow;
}

function startFetchingAnimation ()
{
	if (fetchingAnimation.timer != null)
	{
		clearInterval (fetchingAnimation.timer);
		fetchingAnimation.timer = null;
	}
	
	fetchingAnimation.up = false;
	fetchingAnimation.alphaNow = 1.0;
	fetchingAnimation.start = (new Date).getTime() - 60;
	fetchingAnimation.timer = setInterval ('fetchAnimationTimer();', 60);
	var dot = $('progress');
	dot.style.opacity = '1.0';
	dot.style.display = 'inline';
}

function endFetchingAnimation ()
{
	if (fetchingAnimation.timer != null)
	{
		clearInterval (fetchingAnimation.timer);
		fetchingAnimation.timer = null;
	}
	
	$('progress').style.display = 'none';
}

function paste_lyrics_to_track()
{
    HarmonicPlugin.pasteLyrics();
    LyricsMain();
}

function clear_lyrics()
{
    HarmonicPlugin.clearLyrics();
    LyricsMain();
}

function googleLyrics()
{
    var theURL = "http://www.google.com/search?q=" + HarmonicPlugin.currentSongName() + " " + HarmonicPlugin.currentArtistName() + " lyrics";

    widget.openURL(theURL);
}

function prefkey(key){
	return widget.identifier + "-" + key;
}

