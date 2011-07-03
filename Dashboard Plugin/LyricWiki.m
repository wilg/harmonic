#import "Lyrics.h"
#import "LyricWiki.h"


@implementation LyricWiki

+ (NSString *)sourceName{
	return @"LyricWiki";
}

+ (NSURL *)sourceURL{
	return @"http://www.lyricwiki.org/";
}

+ (MQLyricsContainer *)lyricsWithArtist:(NSString *)artist title:(NSString *)title{

	NSError *error = nil;
	NSString *lyrics = nil;
    
    NSURL *apiURL=nil;
    NSURL *contentURL=nil;
    
    NSXMLDocument * xmlResult;
    NSXMLElement *realURLNode;
    NSXMLElement *realContentNode;
    NSArray *nodes;

    
	NSString *urlString = [NSString stringWithFormat:@"http://lyricwiki.org/api.php?fmt=xml&artist=%@&song=%@", [self stripPunctuationForURL:artist], [self stripPunctuationForURL:title]];
	[MQFunctions debugLog:urlString];
	apiURL=[NSURL URLWithString:urlString];
    
    
    //geting xml useing API to get the 'real' content url
    xmlResult=[[NSXMLDocument alloc] initWithContentsOfURL:apiURL options:NSXMLDocumentTidyXML error:&error];
    nodes = [xmlResult nodesForXPath:@"//LyricsResult/url" error:&error];
    [xmlResult release];
    if ([nodes count] > 0 && !error) {
        realURLNode = [nodes objectAtIndex:0];
        contentURL=[NSURL URLWithString:[realURLNode stringValue]];
    }else{
        lyrics=[error description];
        return nil;
    }   
    
    
    //now we got the content url...we can proceeeeed
    xmlResult=[[NSXMLDocument alloc] initWithContentsOfURL:contentURL options:NSXMLDocumentTidyHTML error:&error];
    nodes = [xmlResult nodesForXPath:@"//div[@class=\"lyricbox\"]" error:&error];
    realContentNode = [nodes objectAtIndex:0];
    nodes=[realContentNode children];
    [xmlResult release];
    if ([nodes count] > 0 && !error) {
        int i;
        for(i=0;i<[nodes count];i++){
            NSXMLNode *node = [nodes objectAtIndex:i];

            if([node kind] != NSXMLTextKind && ![[node name] isEqualToString:@"br"]){
                [node detach];
            }
        }
        lyrics =[NSString stringWithString:[realContentNode stringValue]];
    }else{
        return nil;
    }    
    
    
	return [MQLyricsContainer containerWithLyrics:lyrics source:[self sourceName]];

}
+(NSString *)theAtEnd:(NSString *)theString
{	
	if ([theString length] > 3) {
		NSString *firstFour = [theString substringToIndex:4];

		if ([firstFour isEqualToString:@"The "] || [firstFour isEqualToString:@"the "]) {
			theString = [theString substringFromIndex:4];
			theString = [theString stringByAppendingString:@", The"];
		}
	}

	return theString;
}

+ (NSString *)stripPunctuationForURL:(NSString *)toStrip
{

	NSMutableString *stripMut = [toStrip mutableCopy];
	[stripMut replaceOccurrencesOfString:@"&" withString:@"and" options:0 range:NSMakeRange(0, [stripMut length])];
	[stripMut replaceOccurrencesOfString:@" " withString:@"_" options:0 range:NSMakeRange(0, [stripMut length])];
	
	NSString *result = [stripMut stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

//	toStrip = [stripMut copy];
//
//	NSString *result = @"";
//	NSString *allowed = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890()_'-!,:.%";
//	
//	int i;
//	NSString *theChar;
//	for (i = 0; i < [toStrip length]; i++){
//		theChar = [NSString stringWithFormat:@"%C", [toStrip characterAtIndex:i]];
//		if ([allowed rangeOfString:theChar].location != NSNotFound ){
//			result = [result stringByAppendingString:theChar];
//		}
//	}
	[stripMut release];
//	[toStrip release];
	return [result lowercaseString];
}

@end
