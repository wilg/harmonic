#import "Lyrics.h"
#import "MQLyrics.h"

BOOL checkOnline = YES;
BOOL shouldCache = YES;
BOOL checkItunes = YES;

@implementation MQLyrics

+ (void)setShouldCache:(BOOL)x {
	shouldCache = x;
}

+ (void)setCheckOnline:(BOOL)x {
	checkOnline = x;
}

+ (void)setCheckItunes:(BOOL)x {
	checkItunes = x;
}

+ (MQLyricsContainer *)lyricsWithArtist:(NSString *)artist title:(NSString *)title
{

	BOOL needsCache = YES;

	MQLyricsContainer *lyrics = nil;
	
	if (checkItunes) {
		lyrics = [MQLyricsContainer containerWithLyrics:[MQITunesAppleScripts lyrics] source:@"iTunes Metadata"];
		needsCache = NO;
	}
	
	if (checkOnline && [self isEmpty:lyrics]) {
		[MQFunctions debugLog:@"checkOnline"];

		lyrics = [self checkOnlineWithArtist:artist title:title];
		
		if (![self isEmpty:lyrics])
			needsCache = YES;

	}
	
	if ([self isEmpty:lyrics]) {
		lyrics = nil;
	}
	else {
		if (needsCache && shouldCache) {
			[MQITunesAppleScripts setLyrics:[lyrics lyrics]];
		}
	}
	
	return lyrics;
}

+ (MQLyricsContainer *)checkOnlineWithArtist:(NSString *)artist title:(NSString *)title
{ 
	[MQFunctions debugLog:@"checkOnlineWithArtist"];
	NSMutableArray *queries = [NSMutableArray array];
	MQLyricsContainer *lyrics = nil;
	
	// add the original query
	[queries addObject:[NSArray arrayWithObjects:artist, title, nil]];
	
	// in some instances we might want to try other options if artist is something like "50 Cent feat. Someone Else"
	
	// by X feat. Y
	if ([artist rangeOfString:@" feat."].location != NSNotFound) {
		[queries addObject:[NSArray arrayWithObjects:[artist substringToIndex:[artist rangeOfString:@" feat."].location], title, nil]];
	}
	
	// by X & Y
	if ([artist rangeOfString:@" & "].location != NSNotFound) {
		[queries addObject:[NSArray arrayWithObjects:[artist substringToIndex:[artist rangeOfString:@" & "].location], title, nil]];
		[queries addObject:[NSArray arrayWithObjects:[artist substringFromIndex:[artist rangeOfString:@" & "].location + 3], title, nil]];
	}


	NSEnumerator *loop = [queries objectEnumerator];
	id thisQuery;
	while ( lyrics == nil && (thisQuery = [loop nextObject]) ) {
		// loops through every lyrics provider
		// providers must either return an MQLyricsContainer or nil
		
		if (lyrics == nil)
			lyrics = [LyricWiki lyricsWithArtist:[thisQuery objectAtIndex:0] title:[thisQuery objectAtIndex:1]];
		
	}

	[MQFunctions debugLog:@"checkOnlineWithArtist.... done"];

	return lyrics;

}

+ (MQLyricsContainer *)lyricsFromCurrentiTunesTrack
{
	return [self lyricsWithArtist:[MQITunesAppleScripts artist] title:[MQITunesAppleScripts trackname]];
}

+ (MQLyricsContainer *)lyricsFromCurrentiTunesTrackOffline
{
	return [self lyricsWithArtist:[MQITunesAppleScripts artist] title:[MQITunesAppleScripts trackname]];
}


+ (NSString *)cleanUpLyricsString:(NSString *)theLyrics
{
	NSString *returnValue = theLyrics;
//	NSMutableString *returnValueMut = [returnValue mutableCopy];
//	
//	[returnValueMut replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:0 range:NSMakeRange(0, [returnValueMut length])];
//	[returnValueMut replaceOccurrencesOfString:@"&amp;" withString:@"&" options:0 range:NSMakeRange(0, [returnValueMut length])];
//	[returnValueMut replaceOccurrencesOfString:@"\r" withString:@"<br />" options:0 range:NSMakeRange(0, [returnValueMut length])];
//	
//	returnValue = [returnValueMut copy];
//	[returnValueMut release];
	return returnValue;
}

+ (BOOL)isEmpty:(MQLyricsContainer *)y
{
	NSString *x;
	if (y == nil)
		return YES;
	else {
		x = [y lyrics];	
	}
	if (x == nil)
		return YES;
	if ([x isEqual:@""])
		return YES;
	if ([x rangeOfString:@"<"].location != NSNotFound)
		return YES;
	if ([x rangeOfString:@">"].location != NSNotFound)
		return YES;
	if ([x isEqual:@" "])
		return YES;
	if ([x isEqual:@"\n"])
		return YES;
	return NO;
}


@end
