//
//  GITTag.m
//  CocoaGit
//
//  Created by Geoffrey Garside on 05/08/2008.
//  Copyright 2008 ManicPanda.com. All rights reserved.
//

#import "GITTag.h"
#import "GITRepo.h"
#import "GITActor.h"
#import "GITCommit.h"
#import "GITDateTime.h"

NSString * const kGITObjectTagName = @"tag";

/*! \cond
 Make properties readwrite so we can use
 them within the class.
*/
@interface GITTag ()
@property(readwrite,copy) NSString * name;
@property(readwrite,copy) GITCommit * commit;
@property(readwrite,copy) GITActor * tagger;
@property(readwrite,copy) GITDateTime * tagged;
@property(readwrite,copy) NSString * message;

- (void)extractFieldsFromData:(NSData*)data;

@end
/*! \endcond */

@implementation GITTag
@synthesize name;
@synthesize commit;
@synthesize tagger;
@synthesize tagged;
@synthesize message;

+ (NSString*)typeName
{
    return kGITObjectTagName;
}
- (id)initWithSha1:(NSString*)newSha1 data:(NSData*)raw repo:(GITRepo*)theRepo
{
    if (self = [super initType:kGITObjectTagName sha1:newSha1
                          size:[raw length] repo:theRepo])
    {
        [self extractFieldsFromData:raw];
    }
    return self;
}
- (void)dealloc
{
    self.name = nil;
    self.commit = nil;
    self.tagger = nil;
    self.tagged = nil;
    self.message = nil;
    
    [super dealloc];
}
- (id)copyWithZone:(NSZone*)zone
{
    GITTag * tag    = (GITTag*)[super copyWithZone:zone];
    tag.name        = self.name;
    tag.commit      = self.commit;
    tag.tagger      = self.tagger;
    tag.tagged      = self.tagged;
    tag.message     = self.message;
    
    return tag;
}
- (void)extractFieldsFromData:(NSData*)data
{
    NSString  * dataStr = [[NSString alloc] initWithData:data 
                                                encoding:NSASCIIStringEncoding];
    NSScanner * scanner = [NSScanner scannerWithString:dataStr];
    
    static NSString * NewLine = @"\n";
    NSString * taggedCommit,
             * taggedType,      //!< Should be @"commit"
             * tagName,
             * taggerName,
             * taggerEmail,
             * taggerTimezone;
     NSTimeInterval taggerTimestamp;
    
    if ([scanner scanString:@"object" intoString:NULL] &&
        [scanner scanUpToString:NewLine intoString:&taggedCommit] &&
        [scanner scanString:@"type" intoString:NULL] &&
        [scanner scanUpToString:NewLine intoString:&taggedType] &&
        [taggedType isEqualToString:@"commit"])
    {
        self.commit = [self.repo commitWithSha1:taggedCommit];
    }
    
    if ([scanner scanString:@"tag" intoString:NULL] &&
        [scanner scanUpToString:NewLine intoString:&tagName])
    {
        self.name = tagName;
    }
    
    if ([scanner scanString:@"tagger" intoString:NULL] &&
        [scanner scanUpToString:@"<" intoString:&taggerName] &&
        [scanner scanString:@"<" intoString:NULL] &&
        [scanner scanUpToString:@">" intoString:&taggerEmail] &&
        [scanner scanString:@">" intoString:NULL] &&
        [scanner scanDouble:&taggerTimestamp] &&
        [scanner scanUpToString:NewLine intoString:&taggerTimezone])
    {
        self.tagger = [[GITActor alloc] initWithName:taggerName andEmail:taggerEmail];
        self.tagged = [[GITDateTime alloc] initWithTimestamp:taggerTimestamp
                                              timeZoneOffset:taggerTimezone];
    }
        
    self.message = [dataStr substringFromIndex:[scanner scanLocation]];
}
- (NSString*)description
{
    return [NSString stringWithFormat:@"Tag: %@ <%@>",
                                        self.name, self.sha1];
}
- (NSData*)rawContent
{
    return [[NSString stringWithFormat:@"object %@\ntype %@\ntag %@\ntagger %@ %@\n%@",
             self.commit.sha1, self.commit.type, self.name, self.tagger, self.tagged,
             self.message] dataUsingEncoding:NSASCIIStringEncoding];
}

@end
