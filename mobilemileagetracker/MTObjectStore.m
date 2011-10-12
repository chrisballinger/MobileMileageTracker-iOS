//
//  MTObjectStore.m
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTObjectStore.h"
#import "MTTrip.h"
#import "MTDevice.h"
#import "MTLocation.h"
#import "APIUtil.h"
#import "MTObjectCache.h"

static MTObjectStore *sharedStore = nil;


@implementation MTObjectStore

@synthesize objectManager;

-(id)init
{
    self = [super init];
    if(self)
    {
        deviceStore = [[NSMutableDictionary alloc] init];
        tripStore = [[NSMutableDictionary alloc] init];
        locationStore = [[NSMutableDictionary alloc] init];
        objectStore = [[NSMutableDictionary alloc] init];
        objectManager = [RKObjectManager objectManagerWithBaseURL:[APIUtil RESTurlString]];  
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        RKLogConfigureByName("RestKit/Network", RKLogLevelCritical);
        RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelWarning);
        RKLogConfigureByName("RestKit/CoreData", RKLogLevelDebug);
        
        objectManager.client.username = [defaults objectForKey:@"username"];
        objectManager.client.password = [defaults objectForKey:@"password"];
        //objectManager.client.forceBasicAuthentication = YES;

        
        objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"MTObjectStore.sqlite"];
        [RKObjectManager setSharedManager:objectManager];

        MTObjectCache *objectCache = [[MTObjectCache alloc] init];
        objectManager.objectStore.managedObjectCache = objectCache;
        
        RKManagedObjectMapping* deviceMapping = [MTDevice mappingDefinition];
        RKManagedObjectMapping* tripMapping = [MTTrip mappingDefinition];

        [objectManager.mappingProvider setMapping:deviceMapping forKeyPath:@"devices"];
        [objectManager.mappingProvider setSerializationMapping:[deviceMapping inverseMapping] forClass:deviceMapping.objectClass];
        [objectManager.mappingProvider setMapping:tripMapping forKeyPath:@"trips"];
        
        
        RKObjectRouter* router = [[[RKObjectRouter alloc] init] autorelease];
        
        [router routeClass:[MTDevice class] toResourcePath:kAPIURLDeviceSuffix forMethod:RKRequestMethodPOST];
        objectManager.router = router;
        //[objectManager.router routeClass:[MTDevice class] toResourcePath:[kAPIURLDeviceSuffix stringByAppendingString:@"(resourceID)/"] forMethod:RKRequestMethodPUT];

    }
    return self;
}

#pragma mark -
#pragma mark Singleton Object Methods

+ (MTObjectStore*)sharedInstance {
    @synchronized(self) {
        if (sharedStore == nil) {
            sharedStore = [[self alloc] init];
        }
    }
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedStore == nil) {
            sharedStore = [super allocWithZone:zone];
            return sharedStore;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

/*- (void)release {
 //do nothing
 }*/

- (id)autorelease {
    return self;
}

-(void)addObject:(MTAPIObject*)object
{
    if([object isKindOfClass:[MTDevice class]])
        [deviceStore setObject:object forKey:object.resourceURI];
    else if([object isKindOfClass:[MTTrip class]])
        [tripStore setObject:object forKey:object.resourceURI];
    else if([object isKindOfClass:[MTLocation class]])
        [locationStore setObject:object forKey:object.resourceURI];
    
    [objectStore setObject:object forKey:object.resourceURI];    
}
-(void)addObjects:(NSArray*)objects
{
    for(MTAPIObject* object in objects)
    {
        [self addObject:object];
    }
}
-(void)removeObject:(MTAPIObject*)object
{
    if([object isKindOfClass:[MTDevice class]])
        [deviceStore removeObjectForKey:object.resourceURI];
    else if([object isKindOfClass:[MTTrip class]])
        [tripStore removeObjectForKey:object.resourceURI];
    else if([object isKindOfClass:[MTLocation class]])
        [locationStore removeObjectForKey:object.resourceURI];

    [objectStore removeObjectForKey:object.resourceURI];
}
-(MTAPIObject*)getObjectForURI:(NSString*)URI
{
    return [objectStore objectForKey:URI];
}
-(NSDictionary*)getDevices
{
    return deviceStore;
}
-(NSDictionary*)getTrips
{
    return tripStore;
}
-(NSDictionary*)getLocations
{
    return locationStore;
}
-(NSDictionary*)getObjects
{
    return objectStore;
}

+(NSArray*)cachedObjectsForResourcePath:(NSString*)resourcePath
{
    MTObjectStore *objectStore = [MTObjectStore sharedInstance];
    
    NSArray* cachedObjects = nil; 
    if (objectStore.objectManager.objectStore.managedObjectCache) { 
        NSArray* cacheFetchRequests = [objectStore.objectManager.objectStore.managedObjectCache fetchRequestsForResourcePath:resourcePath]; 
        cachedObjects = [NSManagedObject 
                         objectsWithFetchRequests:cacheFetchRequests]; 
    } 
    return cachedObjects; 
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {  
    [self addObjects:objects];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    NSDictionary *objectsDictionary = [NSDictionary dictionaryWithObject:objects forKey:@"objects"];
    [center postNotificationName:kObjectsLoadedNotificationName object:self userInfo:objectsDictionary];
}  

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {  
    NSLog(@"Encountered an error: %@", error);  
}  


@end
