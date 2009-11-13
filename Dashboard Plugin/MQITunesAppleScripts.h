#import <Cocoa/Cocoa.h>


@interface MQITunesAppleScripts : NSObject {

}

+ (NSString *)lyrics;
+ (void)setLyrics:(NSString *)theLyrics;
+ (NSString *)artist;
+ (NSString *)trackname;
+ (NSString *)curlURL:(NSURL *)url;
+ (NSString *)version;
+ (NSString *)lyricsError;
+ (BOOL)should_check;


@end
