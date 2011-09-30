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

static MTObjectStore *sharedStore = nil;


@implementation MTObjectStore

-(id)init
{
    self = [super init];
    if(self)
    {
        deviceStore = [[NSMutableDictionary alloc] init];
        tripStore = [[NSMutableDictionary alloc] init];
        locationStore = [[NSMutableDictionary alloc] init];
        objectStore = [[NSMutableDictionary alloc] init];
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


@end
