//
//  GITTag.h
//  CocoaGit
//
//  Created by Geoffrey Garside on 01/07/2008.
//  Copyright 2008 ManicPanda.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GITObject.h"

extern const NSString *kGITObjectTagType;

@class GITActor;

@interface GITTag : GITObject {
    NSString        * ref;
    NSString        * type;
    NSString        * name;
    GITActor        * tagger;
    NSCalendarDate  * taggedAt;
}

#pragma mark -
#pragma mark Properties
@property(retain) NSString * ref;
@property(retain) NSString * type;
@property(retain) NSString * name;
@property(retain) GITActor  * tagger;
@property(retain) NSCalendarDate * taggedAt;

#pragma mark -
#pragma mark Instance Methods
- (NSString*)objectType;

@end