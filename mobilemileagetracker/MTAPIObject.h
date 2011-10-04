//
//  MTAPIObject.h
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>  
#import <RestKit/CoreData/CoreData.h>// If you are using Core Data… 
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


@interface MTAPIObject : NSManagedObject <MTAPIObjectProtocol>
{
}

@property (nonatomic, retain) NSString *resourceID;
@property (nonatomic, retain) NSString *resourceURI;
@property (nonatomic, retain) NSString *user;

@end
