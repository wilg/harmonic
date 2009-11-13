#import <Cocoa/Cocoa.h>


@interface MQScriptController : NSObject {

}


+ (NSString *) stringFromScriptNamed:(NSString *)scriptName handler:(NSString *)theHandler arguments:(NSAppleEventDescriptor *)arguments;
+ (BOOL) boolFromScriptNamed:(NSString *)scriptName handler:(NSString *)theHandler arguments:(NSAppleEventDescriptor *)arguments;

+ (void) handleScriptError:(NSDictionary *)errorInfo;


@end
