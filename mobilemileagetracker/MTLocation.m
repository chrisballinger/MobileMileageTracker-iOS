//
//  MTLocation.m
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTLocation.h"
#import "MTObjectStore.h"

@implementation MTLocation

@dynamic latitude;
@dynamic longitude;
@dynamic timestamp;
@dynamic altitude;
@dynamic verticalAccuracy;
@dynamic horizontalAccuracy;
@dynamic trip;

-(CLLocation*)location
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    
    return [[[CLLocation alloc] initWithCoordinate:coordinate altitude:[self.altitude doubleValue] horizontalAccuracy:[self.horizontalAccuracy doubleValue] verticalAccuracy:[self.verticalAccuracy doubleValue] timestamp:self.timestamp] autorelease];

}

#pragma mark -
#pragma MTAPIObjectProtocol method overrides

+(id<RKObjectMappingDefinition>)mappingDefinition
{
    /*RKObjectMapping* articleMapping = [RKObjectMapping mappingForClass:[MTLocation class]];
    [articleMapping setPrimaryKeyAttribute:@"resourceID"];
    [articleMapping mapKeyPath:kIDKey toAttribute:@"resourceID"];
    [articleMapping mapKeyPath:kResourceURIKey toAttribute:@"resourceURI"];
    [articleMapping mapKeyPath:kUserKey toAttribute:@"user"];
    [articleMapping mapKeyPath:kTripNameKey toAttribute:@"name"];
    //[articleMapping mapKeyPath:kTripDeviceKey toAttribute:@"device"];
    [articleMapping mapRelationship:kTripDeviceKey withMapping:[MTDevice mappingDefinition]];
    
    
    return articleMapping; 
    */
    return nil;
}

+(void)loadObjectsWithDelegate:(id<RKObjectLoaderDelegate>)delegate;
{
    /*MTObjectStore *objectStore = [MTObjectStore sharedInstance];
    
    RKObjectMapping* articleMapping = [MTTrip mappingDefinition];
    
    [objectStore.objectManager.mappingProvider setMapping:articleMapping forKeyPath:@"locations"];
    
    
    [objectStore.objectManager loadObjectsAtResourcePath:@"location/?limit=0" delegate:delegate];
     
     */
}



@end
