//
//  MQFunctions.h
//  Xbox Live Friends
//
//  Created by Wil Gieseler on 8/16/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MQFunctions : NSObject {

}

+ (void)startDebugLog;
+ (void)debugLog:(NSString *)logText;


+ (NSString *)cropString:(NSString *)fullString between:(NSString *)beginString and:(NSString *)endString;
+ (NSString *) flattenHTML:(NSString *)theHTML;
+ (NSString *) humanReadableDate:(NSDate *)date;
+ (NSString *)cURLWithURLString:(NSString *)theURL;

@end
