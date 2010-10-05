#import "MQITunesAppleScripts.h"
#import "MQScriptController.h"


@implementation MQITunesAppleScripts

+ (NSString *)lyrics
{
    NSAppleEventDescriptor *arguments = [[NSAppleEventDescriptor alloc] initListDescriptor];
    [arguments insertDescriptor:[NSAppleEventDescriptor descriptorWithString:@""] atIndex: 1];
	
	return [MQScriptController stringFromScriptNamed:@"iTunesController" handler:@"current_lyrics" arguments:arguments]; //arguments are stupidly needed, otherwise the selector is not recognized
}

+ (void)setLyrics:(NSString *)theLyrics
{
    NSAppleEventDescriptor *arguments = [[NSAppleEventDescriptor alloc] initListDescriptor];
    [arguments insertDescriptor:[NSAppleEventDescriptor descriptorWithString:theLyrics] atIndex: 1];
	
	[MQScriptController stringFromScriptNamed:@"iTunesController" handler:@"set_current_lyrics" arguments:arguments];
}


+ (NSString *)artist
{
    NSAppleEventDescriptor *arguments = [[NSAppleEventDescriptor alloc] initListDescriptor];
    [arguments insertDescriptor:[NSAppleEventDescriptor descriptorWithString:@""] atIndex: 1];
	
	return [MQScriptController stringFromScriptNamed:@"iTunesController" handler:@"current_artist" arguments:arguments];
}

+ (NSString *)trackname
{
    NSAppleEventDescriptor *arguments = [[NSAppleEventDescriptor alloc] initListDescriptor];
    [arguments insertDescriptor:[NSAppleEventDescriptor descriptorWithString:@""] atIndex: 1];
	
	return [MQScriptController stringFromScriptNamed:@"iTunesController" handler:@"current_title" arguments:arguments];
}

+ (NSString *)curlURL:(NSURL *)url
{
    NSAppleEventDescriptor *arguments = [[NSAppleEventDescriptor alloc] initListDescriptor];
    [arguments insertDescriptor:[NSAppleEventDescriptor descriptorWithString:[url absoluteString]] atIndex: 1];
	NSString *x = [MQScriptController stringFromScriptNamed:@"iTunesController" handler:@"curl_this" arguments:arguments];
	return x;
}

+ (NSString *)lyricsError
{
    NSAppleEventDescriptor *arguments = [[NSAppleEventDescriptor alloc] initListDescriptor];
    [arguments insertDescriptor:[NSAppleEventDescriptor descriptorWithString:@""] atIndex: 1];
	
	return [MQScriptController stringFromScriptNamed:@"iTunesController" handler:@"can_store_lyrics" arguments:arguments];
}

+ (BOOL)should_check
{
    NSAppleEventDescriptor *arguments = [[NSAppleEventDescriptor alloc] initListDescriptor];
    [arguments insertDescriptor:[NSAppleEventDescriptor descriptorWithString:@""] atIndex: 1];
	
	return [MQScriptController boolFromScriptNamed:@"iTunesController" handler:@"should_check" arguments:arguments];
}





@end
