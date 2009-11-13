#import "MQSeekalyricFetcher.h"
#import "Lyrics.h"


@implementation MQSeekalyricFetcher

+ (NSString *)sourceName{
	return @"Seek a Lyric";
}

+ (NSURL *)sourceURL{
	return @"http://www.seekalyric.com/";
}

+ (NSString *)lyricsWithArtist:(NSString *)artist title:(NSString *)title{
	NSString *lyrics = nil;
	artist = [self theAtEnd:artist];
	NSString *urlString = [NSString stringWithFormat:@"http://www.seekalyric.com/song/%@/%@", [self stripPunctuationForURL:artist], [self stripPunctuationForURL:title]];

	//NSString *theSource = [NSString stringWithContentsOfURL: encoding:NSISOLatin1StringEncoding error:nil];
	//[MQITunesAppleScripts curlURL:[NSURL URLWithString:urlString]];
	
	NSError *error = nil; 
	NSURLResponse *response = nil; 
	NSURLRequest *request = nil; 
	request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.5]; 
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

	if (data == nil)
		return nil;

	NSString *theSource = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding]; 

	
	if ([theSource isEqual:@""])
		return nil;
	if ([theSource isEqual:@" "])
		return nil;

	if (theSource != nil) {
		if ([theSource rangeOfString:@"td ID=\"lyric\""].location != NSNotFound) {

			lyrics = [MQFunctions cropString:theSource between:@"e</a> <<<</p>" and:@"<p class"];
			NSMutableString *lyricsMut = [lyrics mutableCopy];
			[lyricsMut replaceOccurrencesOfString:@"<br />" withString:@"" options:0 range:NSMakeRange(0, [lyricsMut length])];
			[lyricsMut replaceOccurrencesOfString:@"<br>" withString:@"" options:0 range:NSMakeRange(0, [lyricsMut length])];
			lyrics = [lyricsMut copy];
			[lyricsMut release];
		}
		else {
			return nil;
		}
	}
	
	if ([lyrics rangeOfString:@">"].location != NSNotFound)
		return nil;
	if ([lyrics rangeOfString:@"<"].location != NSNotFound)
		return nil;


	return lyrics;

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
	[stripMut replaceOccurrencesOfString:@" " withString:@"_" options:0 range:NSMakeRange(0, [stripMut length])];
	toStrip = [stripMut copy];

	NSString *result = @"";
	NSString *allowed = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_";
	
	int i;
	NSString *theChar;
	for (i = 0; i < [toStrip length]; i++){
		theChar = [NSString stringWithFormat:@"%C", [toStrip characterAtIndex:i]];
		if ([allowed rangeOfString:theChar].location != NSNotFound ){
			result = [result stringByAppendingString:theChar];
		}
		else {
			result = [result stringByAppendingString:@"_"];
		}
	}
	[stripMut release];
	[toStrip release];
	return [result lowercaseString];
}

@end
