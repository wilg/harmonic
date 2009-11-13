#import "MQFunctions.h"

@implementation MQFunctions

BOOL debugLogOn = NO;

+ (void)startDebugLog
{
	debugLogOn = YES;
}

+ (void)debugLog:(NSString *)logText
{
	if (debugLogOn) {
		NSLog(logText);
	}
}

+ (NSString *)cropString:(NSString *)fullString between:(NSString *)beginString and:(NSString *)endString
{
	NSRange range;
	int offset;
	
	range = [fullString rangeOfString:beginString];
	offset = range.location + range.length;
	range = [fullString rangeOfString:endString options:0 range:NSMakeRange(offset, [fullString length] - offset)];
	
	return [fullString substringWithRange:NSMakeRange(offset, range.location - offset)];
}


+ (NSString *) flattenHTML:(NSString *)theHTML
{
	NSString *result = theHTML;
	
	if (![theHTML isEqualToString:@""])	// if empty string, don't do this!  You get junk.
	{
		// HACK -- IF SHORT LENGTH, USE MACROMAN -- FOR SOME REASON UNICODE FAILS FOR "" AND "-" AND "CNN" ...

		int encoding = ([theHTML length] > 3) ? NSUnicodeStringEncoding : NSMacOSRomanStringEncoding;
		NSAttributedString *attrString;
		NSData *theData = [theHTML dataUsingEncoding:encoding];
		if (nil != theData)	// this returned nil once; not sure why; so handle this case.
		{
			NSDictionary *encodingDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:encoding] forKey:@"CharacterEncoding"];
			attrString = [[NSAttributedString alloc] initWithHTML:theData documentAttributes:&encodingDict];
			result = [[[attrString string] retain] autorelease];	// keep only this
			[attrString release];	// don't do autorelease since this is so deep down.
		}
	}
	return result;
}

+ (NSString *)humanReadableDate:(NSDate *)date
{
	NSString *theHumanReadableString;
	[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];

	NSCalendarDate *inDate = [date dateWithCalendarFormat:nil timeZone:nil];
	NSUserDefaults *theDefault = [NSUserDefaults standardUserDefaults];

	int today = [[NSCalendarDate calendarDate] dayOfCommonEra];
	int dateDay = [inDate dayOfCommonEra];
	
	NSString *theDayDesignation;
	if (dateDay == today) {

		theDayDesignation = [[[theDefault stringArrayForKey:@"NSThisDayDesignations"] objectAtIndex:0] capitalizedString];
		[dateFormatter setDateStyle:NSDateFormatterNoStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		theHumanReadableString = [NSString stringWithFormat:@"%@, %@", theDayDesignation, [dateFormatter stringFromDate:date]];

	}
	else if (dateDay == (today + 1)) {

		theDayDesignation = [[[theDefault stringArrayForKey:@"NSNextDayDesignations"] objectAtIndex:0] capitalizedString];
	   
	}
	else if (dateDay == (today - 1)) {

		theDayDesignation = [[[theDefault stringArrayForKey:@"NSPriorDayDesignations"] objectAtIndex:0] capitalizedString];
		[dateFormatter setDateStyle:NSDateFormatterNoStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		theHumanReadableString = [NSString stringWithFormat:@"%@, %@", theDayDesignation, [dateFormatter stringFromDate:date]];
	   
	}
	else {
		[dateFormatter setDateStyle:NSDateFormatterLongStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		theHumanReadableString = [dateFormatter stringFromDate:date];
	}
	

	return theHumanReadableString;

}

+ (NSString *)cURLWithURLString:(NSString *)theURL
{
	NSTask *cURLSession = [[NSTask alloc] init];
	NSPipe *shellOutput =[[NSPipe alloc] init];
	NSPipe *errorOutput =[[NSPipe alloc] init];
	NSFileHandle *fileHandle;

	[cURLSession setLaunchPath:@"/usr/bin/curl"];

	[cURLSession setArguments:[NSArray
	arrayWithObjects:theURL, nil]];

	[cURLSession setStandardOutput:shellOutput];
	[cURLSession setStandardError:errorOutput];
	fileHandle = [shellOutput fileHandleForReading];

	[cURLSession launch];
	
	[cURLSession waitUntilExit];
	
	// NSLog(@"Termination Status: %d",[cURLSession terminationStatus]);
	
	[shellOutput release];
	[errorOutput release];
	[cURLSession terminate];
	[cURLSession release];
	
	NSString *theString = [[NSString alloc] initWithData:[fileHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
		
	return [theString autorelease];
}


+ (NSColor *) colorFromHexRGB:(NSString *) inColorString
{
	NSColor *result = nil;
	unsigned int colorCode = 0;
	unsigned char redByte, greenByte, blueByte;
	
	if (nil != inColorString)
	{
		NSScanner *scanner = [NSScanner scannerWithString:inColorString];
		(void) [scanner scanHexInt:&colorCode];	// ignore error
	}
	redByte		= (unsigned char) (colorCode >> 16);
	greenByte	= (unsigned char) (colorCode >> 8);
	blueByte	= (unsigned char) (colorCode);	// masks off high bits
	result = [NSColor
		colorWithCalibratedRed:		(float)redByte	/ 0xff
							green:	(float)greenByte/ 0xff
							blue:	(float)blueByte	/ 0xff
							alpha:1.0];
	return result;
}

@end

















