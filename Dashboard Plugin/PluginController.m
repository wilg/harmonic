#import "Lyrics.h"
#import "PluginController.h"
#import "MQScriptController.h"

WebScriptObject *webScriptObject = nil;

@implementation PluginController

-(id)initWithWebView:(WebView*)w {
	self = [super init];
	srand(time(NULL));
	
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name: @"com.apple.iTunes.playerInfo" object: nil];
	
	badServerStrings = [[NSMutableArray alloc] init];
	[self addServerErrorToClearList:@"lyricsdir"];
	[self addServerErrorToClearList:@"Lyrics Directory"];
	[self addServerErrorToClearList:@"Don't forget to donate to keep this great service running"];
	[self addServerErrorToClearList:@"mysql_connect()"];
	[self addServerErrorToClearList:@"<TITLE>509 Bandwidth Limit Exceeded</TITLE>"];
	[self addServerErrorToClearList:@"pedlfaster.pedlr.com"];
	[self addServerErrorToClearList:@"mysqladmin flush-hosts"];
	
	return self;
}

-(void)dealloc {
	[badServerStrings release];
	[super dealloc];
}

-(void)windowScriptObjectAvailable:(WebScriptObject*)wso {
	[wso setValue:self forKey:@"HarmonicPlugin"];
	webScriptObject = wso;
}


- (void)notificationRecieved:(NSNotification *)notification
{
	[webScriptObject evaluateWebScript:@"itunes_notification_recieved()"];
//	NSDictionary *trackInfo = [notification userInfo];
//	[trackName setStringValue:[trackInfo objectForKey: @"Name"]];
}


+ (NSString *)webScriptNameForSelector:(SEL)aSel {
	NSString *retval = nil;
	
	//NSLog(@"webScriptNameForSelector");
	if (aSel == @selector(lyricsForCurrentSong)) {
		retval = @"lyricsForCurrentSong";
		
	} else if (aSel == @selector(currentSongName)) {
		retval = @"currentSongName";
		
	} else if (aSel == @selector(currentArtistName)) {
		retval = @"currentArtistName";
		
	} else if (aSel == @selector(currentSongNameEsc)) {
		retval = @"currentSongNameEsc";
		
	} else if (aSel == @selector(currentArtistNameEsc)) {
		retval = @"currentArtistNameEsc";

	} else if (aSel == @selector(logMessage:)) {
		retval = @"logMessage";
		
	} else if (aSel == @selector(setLyrics:)) {
		retval = @"setLyrics";
		
	} else if (aSel == @selector(pasteLyrics)) {
		retval = @"pasteLyrics";
		
	} else if (aSel == @selector(clearLyrics)) {
		retval = @"clearLyrics";
		
	} else if (aSel == @selector(addServerErrorToClearList:)) {
		retval = @"addServerErrorToClearList";


	} else {
		NSLog(@"\tunknown selector");
	}
	
	return retval;
}


+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSel {	
	if (aSel == @selector(thing1) || aSel == @selector(thing2)) {
		return NO;
	}
	return NO;
}

+ (BOOL)isKeyExcludedFromWebScript:(const char*)k {
	return YES;
}


/*********************************************/
// The actual methods used in this plugin, to be called by JavaScript and 
// identified in isSelectorExcludedFromWebScript:.
/*********************************************/

- (NSString *) lyricsForCurrentSong {
	NSString *returnValue = @"<!--error-->";	
	
	if ([[MQITunesAppleScripts lyricsError] isEqual:@"none"]){
		
		//setup MQLyrics
		[MQLyrics setShouldCache:YES];
		[MQLyrics setCheckItunes:YES];
        [MQLyrics setCheckOnline:NO];
		
		MQLyricsContainer *lyrics;
		lyrics = [MQLyrics lyricsFromCurrentiTunesTrack];

		if ([lyrics lyrics] != nil) {
			//got lyrics
				lyrics = [MQLyrics lyricsFromCurrentiTunesTrack];
            if (![self containsValidLyrics:[lyrics lyrics]]){
					returnValue = @"<!--error-->The lyrics is invalid";
            }else{
                returnValue = [lyrics lyrics];
            }    
		} else {
				returnValue = @"<!--error-->Can't find lyrics";
		}
	}
	else {
		returnValue = [NSString stringWithFormat:@"<!--error-->%@", [MQITunesAppleScripts lyricsError]];
	}
	
	return returnValue;
}

-(bool)containsValidLyrics:(NSString *)lyrics {
	bool retval = YES;
	NSEnumerator *enumerator = [badServerStrings objectEnumerator];
	NSString *badString;
	while (badString = [enumerator nextObject]) {
		if ([lyrics rangeOfString:badString].location != NSNotFound) {
			retval = NO;
		}
	}
	return retval;
}

- (NSString *) currentSongName {
	NSString *x = [MQITunesAppleScripts trackname];
	if (x == nil)
		return @"";
	return x;
}

- (NSString *) currentArtistName {
	NSString *x = [MQITunesAppleScripts artist];
	if (x == nil)
		return @"";
	return x;
}

- (NSString *) currentSongNameEsc {
	NSString *x = [MQITunesAppleScripts trackname];
	if (x == nil)
		return @"";
	return [x stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *) currentArtistNameEsc {
	NSString *x = [MQITunesAppleScripts artist];
	if (x == nil)
		return @"";
	return [x stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void) addServerErrorToClearList:(NSString *)errorString {
	[badServerStrings addObject:errorString];
}

- (void) logMessage:(NSString *)str {
	NSLog(@"JavaScript says: %@", str);
}

- (void)pasteLyrics
{
	NSPasteboard *pb = [NSPasteboard generalPasteboard];
	NSArray *pasteTypes = [NSArray arrayWithObjects: NSStringPboardType, nil];
	NSString *bestType = [pb availableTypeFromArray:pasteTypes];
	if (bestType != nil) {
		[MQITunesAppleScripts setLyrics:[pb stringForType:bestType]];
	}

}

- (void)setLyrics:(NSString *)lyrics
{
	[MQITunesAppleScripts setLyrics:lyrics];
}

- (void)clearLyrics
{
	[MQITunesAppleScripts setLyrics:@""];
}



@end
