//
//  MTDevice.m
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTDevice.h"
#import "APIUtil.h"
#import "MTObjectStore.h"

@implementation MTDevice

@dynamic name;
@dynamic deviceType;
@dynamic uuid;

-(id) init
{
    self = [super init];
    if(self)
    {
        self.name = nil;
        self.deviceType = nil;
        self.uuid = nil;
    }
    return self;
}

-(id)initWithName:(NSString*)newName
{
    self = [self init];
    if(self)
    {
        self.name = newName;
        self.deviceType = @"iPhone";
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.uuid = [defaults objectForKey:@"uuid"];
    }
    return self;
}

+(MTDevice*)deviceWithName:(NSString*)newName
{
    MTDevice *device = [[[MTDevice alloc] initWithName:newName] autorelease];
    return device;
}

#pragma mark -
#pragma MTAPIObjectProtocol method overrides

+(id<RKObjectMappingDefinition>)mappingDefinition
{
    RKManagedObjectMapping* articleMapping = [RKManagedObjectMapping mappingForClass:[MTDevice class]];
    [articleMapping setPrimaryKeyAttribute:@"resourceID"];
    [articleMapping mapKeyPath:kIDKey toAttribute:@"resourceID"];
    [articleMapping mapKeyPath:kResourceURIKey toAttribute:@"resourceURI"];
    [articleMapping mapKeyPath:kUserKey toAttribute:@"user"];
    [articleMapping mapKeyPath:kDeviceNameKey toAttribute:@"name"];
    [articleMapping mapKeyPath:kDeviceTypeKey toAttribute:@"deviceType"];
    [articleMapping mapKeyPath:kDeviceUUIDKey toAttribute:@"uuid"];
    
    return articleMapping;
}

+(NSArray*)cachedObjects
{
    MTObjectStore *objectStore = [MTObjectStore sharedInstance];

    NSArray* cachedObjects = nil; 
    if (objectStore.objectManager.objectStore.managedObjectCache) { 
        NSArray* cacheFetchRequests = [objectStore.objectManager.objectStore.managedObjectCache fetchRequestsForResourcePath:kAPIDeviceResourcePath]; 
        cachedObjects = [NSManagedObject 
                         objectsWithFetchRequests:cacheFetchRequests]; 
    } 
    return cachedObjects; 
}

+(void)loadObjectsWithDelegate:(id<RKObjectLoaderDelegate>)delegate;
{
    MTObjectStore *objectStore = [MTObjectStore sharedInstance];
    
    [objectStore.objectManager loadObjectsAtResourcePath:kAPIDeviceResourcePath delegate:delegate];

}

@end
