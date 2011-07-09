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
	MQLyricsContainer *lyrics = nil;
	
	lyrics = [MQLyricsContainer containerWithLyrics:[MQITunesAppleScripts lyrics] source:@"iTunes Metadata"];
    
	if ([self isEmpty:lyrics]) {
		lyrics = nil;
	}
	
	return lyrics;
}


+ (MQLyricsContainer *)lyricsFromCurrentiTunesTrack
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
