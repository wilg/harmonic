#import "MQLyricsContainer.h"


@implementation MQLyricsContainer

- (id)init
{
	if (![super init])
	return nil;

	return self;
}

- (id)initWithLyrics:(NSString *)theseLyrics source:(NSString *)thisSource
{
	if (![super init])
	return nil;

	lyrics = theseLyrics;
	source = thisSource;

	[lyrics retain];
	[source retain];

	return self;
}

- (void) dealloc {
    [lyrics release];
    [source release];
	
    [super dealloc];
}

- (NSString *)lyrics
{
	return lyrics;
}

- (NSString *)source
{
	return source;
}

- (BOOL)isInstrumental {
	NSString *theLyrics = [self lyrics];
	
	if ([theLyrics length] >= 12 && [theLyrics length] <= 20) {
		
		if ([theLyrics rangeOfString:@"Instrumental"].location != NSNotFound || [theLyrics rangeOfString:@"instrumental"].location != NSNotFound  || [theLyrics rangeOfString:@"INSTRUMENTAL"].location != NSNotFound)
			return YES;
		
	}
		
	return NO;
}

- (NSString *)lyricsHTML
{
	NSString *returnValue = [self lyrics];
	NSMutableString *returnValueMut = [returnValue mutableCopy];
	[returnValueMut replaceOccurrencesOfString:@"\r\n" withString:@"<br />" options:0 range:NSMakeRange(0, [returnValueMut length])];
	[returnValueMut replaceOccurrencesOfString:@"\n" withString:@"<br />" options:0 range:NSMakeRange(0, [returnValueMut length])];
	[returnValueMut replaceOccurrencesOfString:@"\r" withString:@"<br />" options:0 range:NSMakeRange(0, [returnValueMut length])];
	returnValue = [returnValueMut copy];
	[returnValueMut release];
	return returnValue;
}

- (void)setLyrics:(NSString *)l
{
	lyrics = l;
}

- (void)setSource:(NSString *)s
{
	source = s;
}

+ (id)containerWithLyrics:(NSString *)theseLyrics source:(NSString *)thisSource
{
	return [[[self alloc] initWithLyrics:theseLyrics source:thisSource] autorelease];
}


@end
