#import <Cocoa/Cocoa.h>


@interface LyricWiki : NSObject {

}
+ (MQLyricsContainer *)lyricsWithArtist:(NSString *)artist title:(NSString *)title;
+ (NSString *)sourceName;
+ (NSURL *)sourceURL;
+ (NSString *)stripPunctuationForURL:(NSString *)toStrip;
+(NSString *)theAtEnd:(NSString *)theString;

@end
