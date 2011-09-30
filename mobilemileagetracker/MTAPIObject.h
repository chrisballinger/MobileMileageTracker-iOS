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

@property (readonly) int limit;
@property (readonly, retain) NSString *next;
@property (readonly, retain) NSString *previous;
@property (readonly) int offset;
@property (readonly) int totalCount;

@property (nonatomic, retain) NSString *_id;
@property (readonly, retain) NSString *resourceURI;
@property (readonly, retain) NSString *user;
@property (readonly, retain) NSArray *objects;


/*
 "meta": {"limit": 20, "next": null, "offset": 0, "previous": null, "total_count": 1},
 */


@end
