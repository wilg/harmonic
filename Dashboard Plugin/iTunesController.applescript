on curl_this(theURL)
	set the_command to "curl " & quoted form of theURL & " --connect-timeout 3 " --"-A " & (quoted form of create_random(5, 50) as string)
	return do shell script (the_command as Unicode text)
end curl_this

on itunes_lyrics(x)
	if itunes_playing() is false then return ""
	
	tell application "iTunes"
		set y to lyrics of current track as Unicode text
	end tell
	return y
end itunes_lyrics

on itunes_set_lyrics(thelyrics)
	if itunes_playing() is false then return ""
	
	try
		tell application "iTunes"
			set lyrics of current track to (thelyrics as Unicode text)
		end tell
	on error e
		log e
		return "error"
	end try
	return "done"
end itunes_set_lyrics

on itunes_artist(x)
	if itunes_playing() is false then return ""
	
	tell application "iTunes"
		set y to artist of current track as Unicode text
	end tell
	return y
end itunes_artist

on itunes_trackname(x)
	if itunes_playing() is false then return ""
	
	tell application "iTunes"
		set y to name of current track as Unicode text
	end tell
	return y
end itunes_trackname

on can_store_lyrics(x)
	if itunes_run() then
		tell application "iTunes"
			if (version as integer) is less than 7 then return "Harmonic requires <a href='#' onclick=\"widget.openURL('http://www.apple.com/itunes');\">iTunes 7</a>"
			
			
			if my itunes_playing() is false then return "iTunes is Idle"
			
			
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

on should_check(u)
	
	if itunes_run() then
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

on itunes_run()
	tell application "System Events"
		if (creator type of processes) contains "hook" then
			return true
		else
			return false
		end if
	end tell
end itunes_run

on itunes_playing()
	if itunes_run() is false then return false
	tell application "iTunes"
		try
			current track
			return true
		on error
			return false
		end try
	end tell
end itunes_playing


on create_agent(l)
	set the_agent to some item of l
	set x to random number from 1 to 2
	set tl to length of the_agent
	if x is 2 then set the_agent to reverse of (characters of the_agent) as Unicode text
	set b to random number from 1 to (tl - 3)
	set e to random number from b to tl
	set obf to characters b through e of the_agent as Unicode text
	return obf
end create_agent

on create_random(min, max)
	set digits to random number from min to max
	set digits to random number from min to digits
	set letterbank to "ABCtobeVWXYZabcdefvwxonklmnooGelbitapmoYOURMOTHERc05DEFGHJKL1vrMNOPQRlgSb2SUne59niWUswod pqiW05alghijrstul zoMTUyz"
	set x to ""
	repeat digits times
		set x to x & some item of letterbank
	end repeat
	return x as string
end create_random
