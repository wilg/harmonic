#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface PluginController : NSObject {

	NSArray *badServerStrings;
	
}

- (void)clearLyrics;
- (bool)containsValidLyrics:(NSString *)lyrics;
- (void) addServerErrorToClearList:(NSString *)errorString;

@end
