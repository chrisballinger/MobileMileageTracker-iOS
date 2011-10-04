//
//  MTAPIObject.m
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTAPIObject.h"
#import "APIUtil.h"

@implementation MTAPIObject

@dynamic resourceID;
@dynamic resourceURI;
@dynamic user;

#pragma mark -
#pragma MTAPIObjectProtocol method overrides

+(void)loadObjectsWithDelegate:(id<RKObjectLoaderDelegate>)delegate
{
    
}
+(id<RKObjectMappingDefinition>)mappingDefinition
{
    return nil;
}
+(NSArray*)cachedObjects
{
    return nil;
}

@end
