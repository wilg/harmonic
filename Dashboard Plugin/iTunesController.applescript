(*
***WARNING***
*Do NOT try to change from underscored method names to camelcased ones for subroutines that shall be called from the Obj-C bridge, calls will fail! (and you'll spend two hours debugging a -1708  >.<  There must be a case-sensitivity issue somewhere in the call stack)
*Unless explicitly stated in a comment next to the subroutine name, these subroutines are called through the bridge and should not be camelcased.
*)
--- Helpers ---
on curl_this(theURL)
	set the_command to "curl " & quoted form of theURL & " --connect-timeout 3 "
	return do shell script (the_command as Unicode text)
end curl_this

--- iTunes: current track info ---
on current_lyrics()
	if isiTunesPlaying() then
		tell application "iTunes"
			return lyrics of current track as Unicode text
		end tell
	end if
	return ""
end current_lyrics

on current_artist()
	if not isiTunesPlaying() then return ""
	
	tell application "iTunes"
		return artist of current track as Unicode text
	end tell
end current_artist

on current_title()
	if not isiTunesPlaying() then return ""
	
	tell application "iTunes"
		return name of current track as Unicode text
	end tell
end current_title

on can_store_lyrics()
	if isiTunesRunning() then
		if not isiTunesCompatible() then return "Harmonic requires <a href='#' onclick=\"widget.openURL('http://www.apple.com/itunes');\">iTunes 7</a>"
		
		if not isiTunesPlaying() then return "iTunes is Idle"
		tell application "iTunes"
			if kind of container of container of current track is shared library then
				return "Shared Libraries Don't Support Lyrics"
				
			else if kind of container of container of current track is radio tuner then
				return "Internet Radio Doesn't Support Lyrics"
				
			else if lyrics of current track is missing value then
				return "Track Type Doesn't Support Lyrics"
				
			end if
			
		end tell
	else
		return "iTunes is Closed"
	end if
	
	return "none"
end can_store_lyrics


--- Setters ---
on set_current_lyrics(newLyrics)
	if not isiTunesPlaying() then return ""
	
	try
		tell application "iTunes"
			set lyrics of current track to (newLyrics as Unicode text)
		end tell
	on error e
		log e
		return "error"
	end try
	return "done"
end set_current_lyrics


--- iTunes status info ---
on should_check()
	if isiTunesRunning() then
		tell application "iTunes"
			if kind of container of container of current track is shared library then return false
			if kind of container of container of current track is radio tuner then return false
			if podcast of current track is true then return false
			if kind of current track contains "video" then return false
			if kind of current track contains "quicktime" then return false
			if kind of current track contains "movie" then return false
			if genre of current track contains "Audiobook" then return false
		end tell
	end if
	return true
end should_check

on isiTunesRunning() --camelCased because internally-used only
	tell application "System Events"
		if (creator type of processes) contains "hook" then
			return true
		else
			return false
		end if
	end tell
end isiTunesRunning

on isiTunesCompatible() --camelCased because internally-used only
	tell application "iTunes"
		set iTunesVersion to get version as string
	end tell
	considering numeric strings
		return iTunesVersion ≥ "7.0"
	end considering
end isiTunesCompatible

on isiTunesPlaying() --camelCased because internally-used only
	if isiTunesRunning() is false then return false
	tell application "iTunes"
		try
			current track
			return true
		on error
			return false
		end try
	end tell
end isiTunesPlaying