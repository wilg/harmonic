#import <Cocoa/Cocoa.h>


@interface MQLyricsContainer : NSObject {

	NSString *lyrics;
	NSString *source;

}

- (id)init;
- (id)initWithLyrics:(NSString *)theseLyrics source:(NSString *)thisSource;

- (NSString *)lyrics;
- (NSString *)lyricsHTML;
- (NSString *)source;

- (BOOL)isInstrumental;

- (void)setLyrics:(NSString *)l;
- (void)setSource:(NSString *)s;

+ (id)containerWithLyrics:(NSString *)theseLyrics source:(NSString *)thisSource;

@end
