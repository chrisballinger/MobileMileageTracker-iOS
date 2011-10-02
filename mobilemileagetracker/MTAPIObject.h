//
//  MTAPIObject.h
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTAPIObjectProtocol.h"

#define kMetadataKey @"meta"
#define kMetaLimitKey @"limit"
#define kMetaOffsetKey @"offset"
#define kMetaTotalCountKey @"total_count"
#define kMetaNextKey @"next"
#define kMetaPreviousKey @"previous"

#define kObjectsKey @"objects"
#define kIDKey @"id"
#define kResourceURIKey @"resource_uri"
#define kUserKey @"user"


@interface MTAPIObject : NSObject <MTAPIObjectProtocol>
{
}

@property (nonatomic, retain) NSNumber *limit;
@property (nonatomic, retain) NSString *next;
@property (nonatomic, retain) NSString *previous;
@property (nonatomic, retain) NSNumber *offset;
@property (nonatomic, retain) NSNumber *totalCount;

@property (nonatomic, retain) NSString *resourceID;
@property (nonatomic, retain) NSString *resourceURI;
@property (nonatomic, retain) NSString *user;
@property (nonatomic, retain) NSArray *objects;


/*
 "meta": {"limit": 20, "next": null, "offset": 0, "previous": null, "total_count": 1},
 */


@end
