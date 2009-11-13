#import "Lyrics.h"
#import "LyricWiki.h"


@implementation LyricWiki

+ (NSString *)sourceName{
	return @"LyricWiki";
}

+ (NSURL *)sourceURL{
	return @"http://www.lyricwiki.org/";
}

+ (MQLyricsContainer *)lyricsWithArtist:(NSString *)artist title:(NSString *)title{

	NSError *error;
	NSString *lyrics = nil;

	NSString *urlString = [NSString stringWithFormat:@"http://lyricwiki.org/api.php?fmt=text&artist=%@&song=%@", [self stripPunctuationForURL:artist], [self stripPunctuationForURL:title]];
	
	[MQFunctions debugLog:urlString];

	NSStringEncoding encoding;
	NSString *theSource = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] usedEncoding:&encoding error:&error];

	if (theSource == nil) {
		[MQFunctions debugLog:@"This must  be Tiger. Resorting to cURL."];
		theSource = [MQFunctions cURLWithURLString:urlString];

		if (theSource == nil) {
			return nil;
		}
	}
	
	if ([theSource rangeOfString:@"#redirect"].location != NSNotFound || [theSource rangeOfString:@"#Redirect"].location != NSNotFound) {
		//redirected
		NSString *artistAndSong = [theSource substringFromIndex:[theSource rangeOfString:@"[["].location +2 ];
		artistAndSong = [artistAndSong substringToIndex:[artistAndSong rangeOfString:@"]]"].location];
		NSString *newArtist = [artistAndSong substringToIndex:[artistAndSong rangeOfString:@":"].location];
		NSString *newTitle = [artistAndSong substringFromIndex:[artistAndSong rangeOfString:@":"].location + 1];
		urlString = [NSString stringWithFormat:@"http://lyricwiki.org/api.php?fmt=text&artist=%@&song=%@", [self stripPunctuationForURL:newArtist], [self stripPunctuationForURL:newTitle]];
		[MQFunctions debugLog:[NSString stringWithFormat:@"redirecting to %@", urlString]];
		theSource = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] usedEncoding:&encoding error:nil];
	}
	
	if ([theSource isEqual:@""] || [theSource isEqual:@" "] || [theSource isEqual:@"Not found"])
		return nil;
		
	//terrible errors
	if ([theSource rangeOfString:@"pedlfaster.pedlr.com"].location != NSNotFound || [theSource rangeOfString:@"mysqladmin flush-hosts"].location != NSNotFound)
		return nil;
		
	if (theSource != nil)
		lyrics = theSource;
	else
		return nil;
	
	return [MQLyricsContainer containerWithLyrics:lyrics source:[self sourceName]];

}

+(NSString *)theAtEnd:(NSString *)theString
{	
	if ([theString length] > 3) {
		NSString *firstFour = [theString substringToIndex:4];

		if ([firstFour isEqualToString:@"The "] || [firstFour isEqualToString:@"the "]) {
			theString = [theString substringFromIndex:4];
			theString = [theString stringByAppendingString:@", The"];
		}
	}

	return theString;
}

+ (NSString *)stripPunctuationForURL:(NSString *)toStrip
{

	NSMutableString *stripMut = [toStrip mutableCopy];
	[stripMut replaceOccurrencesOfString:@"&" withString:@"and" options:0 range:NSMakeRange(0, [stripMut length])];
	[stripMut replaceOccurrencesOfString:@" " withString:@"_" options:0 range:NSMakeRange(0, [stripMut length])];
	
	NSString *result = [stripMut stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

//	toStrip = [stripMut copy];
//
//	NSString *result = @"";
//	NSString *allowed = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890()_'-!,:.%";
//	
//	int i;
//	NSString *theChar;
//	for (i = 0; i < [toStrip length]; i++){
//		theChar = [NSString stringWithFormat:@"%C", [toStrip characterAtIndex:i]];
//		if ([allowed rangeOfString:theChar].location != NSNotFound ){
//			result = [result stringByAppendingString:theChar];
//		}
//	}
	[stripMut release];
//	[toStrip release];
	return [result lowercaseString];
}

@end
