#import "MQITunesAppleScripts.h"
#import "MQScriptController.h"


@implementation MQITunesAppleScripts

+ (NSString *)lyrics
{
    NSAppleEventDescriptor *arguments = [[NSAppleEventDescriptor alloc] initListDescriptor];
    [arguments insertDescriptor:[NSAppleEventDescriptor descriptorWithString:@""] atIndex: 1];
	
	return [MQScriptController stringFromScriptNamed:@"iTunesController" handler:@"itunes_lyrics" arguments:arguments];
}

+ (void)setLyrics:(NSString *)theLyrics
{
    NSAppleEventDescriptor *arguments = [[NSAppleEventDescriptor alloc] initListDescriptor];
    [arguments insertDescriptor:[NSAppleEventDescriptor descriptorWithString:theLyrics] atIndex: 1];
	
	[MQScriptController stringFromScriptNamed:@"iTunesController" handler:@"itunes_set_lyrics" arguments:arguments];
}


+ (NSString *)artist
{
    NSAppleEventDescriptor *arguments = [[NSAppleEventDescriptor alloc] initListDescriptor];
    [arguments insertDescriptor:[NSAppleEventDescriptor descriptorWithString:@""] atIndex: 1];
	
	return [MQScriptController stringFromScriptNamed:@"iTunesController" handler:@"itunes_artist" arguments:arguments];
}

+ (NSString *)trackname
{
    NSAppleEventDescriptor *arguments = [[NSAppleEventDescriptor alloc] initListDescriptor];
    [arguments insertDescriptor:[NSAppleEventDescriptor descriptorWithString:@""] atIndex: 1];
	
	return [MQScriptController stringFromScriptNamed:@"iTunesController" handler:@"itunes_trackname" arguments:arguments];
}

+ (NSString *)curlURL:(NSURL *)url
{
    NSAppleEventDescriptor *arguments = [[NSAppleEventDescriptor alloc] initListDescriptor];
    [arguments insertDescriptor:[NSAppleEventDescriptor descriptorWithString:[url absoluteString]] atIndex: 1];
	NSString *x = [MQScriptController stringFromScriptNamed:@"iTunesController" handler:@"curl_this" arguments:arguments];
	return x;
}

+ (NSString *)version
{
    NSAppleEventDescriptor *arguments = [[NSAppleEventDescriptor alloc] initListDescriptor];
    [arguments insertDescriptor:[NSAppleEventDescriptor descriptorWithString:@""] atIndex: 1];
	
	return [MQScriptController stringFromScriptNamed:@"iTunesController" handler:@"itunes_version" arguments:arguments];
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
