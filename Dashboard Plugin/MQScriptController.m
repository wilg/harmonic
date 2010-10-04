#import "MQScriptController.h"
#import "NSAppleScript+HandlerCalls.h"

#define noScriptErr 0

@implementation MQScriptController


+ (NSString *) stringFromScriptNamed:(NSString *)scriptName handler:(NSString *)theHandler arguments:(NSAppleEventDescriptor *)arguments
{
    /* Locate the script within the bundle */
    NSString *scriptPath = [[NSBundle bundleForClass:[self class]] pathForResource:scriptName ofType:@"scpt" inDirectory:@"Scripts"];
    NSURL *scriptURL = [NSURL fileURLWithPath:scriptPath];

    NSDictionary *errorInfo = nil;
    
    /* Here I am using "initWithContentsOfURL:" to load a pre-compiled script, rather than using "initWithSource:" to load a text file with AppleScript source.  The main reason for this is that the latter technique seems to give rise to inexplicable -1708 (errAEEventNotHandled) errors on Jaguar. */
    NSAppleScript *script = [[NSAppleScript alloc] initWithContentsOfURL: scriptURL error: &errorInfo];
    
    /* See if there were any errors loading the script */
    if (! script || errorInfo)
        [self handleScriptError: errorInfo];

    errorInfo = nil;

    /* Call the handler using the method in our special category */
    NSAppleEventDescriptor *result = [script callHandler:theHandler withArguments:arguments errorInfo:&errorInfo];

    NSString *scriptResult = [result stringValue];

    /* Check for errors in running the handler */
    if (errorInfo) {
        [self handleScriptError: errorInfo];
    }
    /* Check the handler's return value */
    else if (scriptResult != noScriptErr) {

	}

    [script release];
    [arguments release];

	return scriptResult;
}

+ (BOOL) boolFromScriptNamed:(NSString *)scriptName handler:(NSString *)theHandler arguments:(NSAppleEventDescriptor *)arguments
{
    /* Locate the script within the bundle */
    NSString *scriptPath = [[NSBundle bundleForClass:[self class]] pathForResource:scriptName ofType:@"scpt" inDirectory:@"Scripts"];
    NSURL *scriptURL = [NSURL fileURLWithPath:scriptPath];

    NSDictionary *errorInfo = nil;
    
    /* Here I am using "initWithContentsOfURL:" to load a pre-compiled script, rather than using "initWithSource:" to load a text file with AppleScript source.  The main reason for this is that the latter technique seems to give rise to inexplicable -1708 (errAEEventNotHandled) errors on Jaguar. */
    NSAppleScript *script = [[NSAppleScript alloc] initWithContentsOfURL: scriptURL error: &errorInfo];
    
    /* See if there were any errors loading the script */
    if (!script || errorInfo) {
        [self handleScriptError: errorInfo];
    }

    errorInfo = nil;

    /* Call the handler using the method in our special category */
    NSAppleEventDescriptor *result = [script callHandler:theHandler withArguments:arguments errorInfo:&errorInfo];

    BOOL scriptResult = [result booleanValue];

    /* Check for errors in running the handler */
    if (errorInfo) {
        [self handleScriptError: errorInfo];
    }
    /* Check the handler's return value */
    else if (scriptResult != noScriptErr) {

	}

    [script release];
    [arguments release];

	return scriptResult;
}


+ (void) handleScriptError: (NSDictionary *) errorInfo {
    NSString *errorMessage = [errorInfo objectForKey: NSAppleScriptErrorBriefMessage];
    NSString *errorMessage2 = [errorInfo objectForKey: NSAppleScriptErrorMessage];
    NSNumber *errorNumber = [errorInfo objectForKey: NSAppleScriptErrorNumber];
	NSLog([NSString stringWithFormat:@"MQScriptController %@ error:%@ number:%@", errorMessage2, errorMessage, errorNumber]);
}


@end
