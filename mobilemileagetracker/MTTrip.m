//
//  MTTrip.m
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTTrip.h"
#import "MTObjectStore.h"
#import "APIUtil.h"

@implementation MTTrip

@dynamic name;
@dynamic device;

-(id) init
{
    self = [super init];
    if(self)
    {
        self.name = nil;
        self.device = nil;
    }
    return self;
}

-(id)initWithName:(NSString*)newName device:(MTDevice*)newDevice
{
    self = [self init];
    if(self)
    {
        self.name = newName;
        self.device = newDevice;
    }
    return self;
}

+(MTTrip*)tripWithName:(NSString*)newName device:(MTDevice*)newDevice
{
    MTTrip *trip = [[[MTTrip alloc] initWithName:newName device:newDevice] autorelease];
    return trip;
}

#pragma mark -
#pragma MTAPIObjectProtocol method overrides

+(id<RKObjectMappingDefinition>)mappingDefinition
{
    RKManagedObjectMapping* articleMapping = [RKManagedObjectMapping mappingForClass:[MTTrip class]];
    [articleMapping setPrimaryKeyAttribute:@"resourceID"];
    [articleMapping mapKeyPath:kIDKey toAttribute:@"resourceID"];
    [articleMapping mapKeyPath:kResourceURIKey toAttribute:@"resourceURI"];
    [articleMapping mapKeyPath:kUserKey toAttribute:@"user"];
    [articleMapping mapKeyPath:kTripNameKey toAttribute:@"name"];
    //[articleMapping mapKeyPath:kTripDeviceKey toAttribute:@"device"];
    [articleMapping mapRelationship:kTripDeviceKey withMapping:[MTDevice mappingDefinition]];
    
    
    return articleMapping; 
    
}

+(void)loadObjectsWithDelegate:(id<RKObjectLoaderDelegate>)delegate;
{
    MTObjectStore *objectStore = [MTObjectStore sharedInstance];
    
    RKManagedObjectMapping* articleMapping = [MTTrip mappingDefinition];
    
    [objectStore.objectManager.mappingProvider setMapping:articleMapping forKeyPath:@"trips"];
    
    
    [objectStore.objectManager loadObjectsAtResourcePath:@"trip/?limit=0" delegate:delegate];
}

@end
