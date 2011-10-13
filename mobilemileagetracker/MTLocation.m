//
//  MTLocation.m
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTLocation.h"
#import "MTObjectStore.h"
#import "JSONKit.h"

@implementation MTLocation

@dynamic latitude;
@dynamic longitude;
@dynamic timestamp;
@dynamic altitude;
@dynamic verticalAccuracy;
@dynamic horizontalAccuracy;
@dynamic trip;

-(id) init
{
    self = [MTLocation object];
    if(self)
    {
        self.resourceID = nil;
        self.resourceURI = nil;
        self.user = nil;
    }
    return self;
}


+(MTLocation*)locationWithLocation:(CLLocation*)location
{
    MTLocation *newLocation = [[MTLocation alloc] init];
    
    newLocation.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
    newLocation.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    newLocation.timestamp = location.timestamp;
    newLocation.altitude = [NSNumber numberWithDouble:location.altitude];
    newLocation.verticalAccuracy = [NSNumber numberWithDouble:location.verticalAccuracy];
    newLocation.horizontalAccuracy = [NSNumber numberWithDouble:location.horizontalAccuracy];
    
    return newLocation;
}


-(CLLocation*)location
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    
    return [[[CLLocation alloc] initWithCoordinate:coordinate altitude:[self.altitude doubleValue] horizontalAccuracy:[self.horizontalAccuracy doubleValue] verticalAccuracy:[self.verticalAccuracy doubleValue] timestamp:self.timestamp] autorelease];

}

-(NSDictionary*)toDictionary
{
    /*Create Device
     '{"device_type": "iPhone", "name": "Chris Phone", "uuid": "1"}'
     */
    CLLocation *location = [self location];
    NSNumber *altitude = [NSNumber numberWithDouble:location.altitude];
    NSNumber *horizontalAccuracy = [NSNumber numberWithDouble:location.horizontalAccuracy];
    NSNumber *verticalAccuracy = [NSNumber numberWithDouble:location.verticalAccuracy];
    NSNumber *latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    NSDateFormatter *outFormat = [[NSDateFormatter alloc] init];
    [outFormat setDateFormat:@"YYYY-MM-ddTHH:mm:ss"];
    NSString *timestamp = [outFormat stringFromDate:location.timestamp];
    
    NSArray *objectArray = [NSArray arrayWithObjects:altitude, horizontalAccuracy, verticalAccuracy, latitude, longitude, timestamp, self.trip.resourceURI, nil];
    NSArray *keyArray = [NSArray arrayWithObjects:kLocationAltitudeKey, kLocationHorizontalAccuracyKey, kLocationVerticalAccuracyKey, kLocationLatitudeKey, kLocationLongitudeKey, kLocationTimestampKey, kLocationTripKey, nil];
    return [NSDictionary dictionaryWithObjects:objectArray forKeys:keyArray];
}

-(NSData*)toJSON
{
    return [[self toDictionary] JSONData];
}

#pragma mark -
#pragma MTAPIObjectProtocol method overrides

+(id<RKObjectMappingDefinition>)mappingDefinition
{
    RKManagedObjectMapping* articleMapping = [RKManagedObjectMapping mappingForClass:[MTLocation class]];
    [articleMapping setPrimaryKeyAttribute:@"resourceID"];
    [articleMapping mapKeyPath:kIDKey toAttribute:@"resourceID"];
    [articleMapping mapKeyPath:kResourceURIKey toAttribute:@"resourceURI"];
    [articleMapping mapKeyPath:kUserKey toAttribute:@"user"];
     
    [articleMapping mapKeyPath:kLocationLatitudeKey toAttribute:@"latitude"];
    [articleMapping mapKeyPath:kLocationLongitudeKey toAttribute:@"longitude"];
    [articleMapping mapKeyPath:kLocationTimestampKey toAttribute:@"timestamp"];
    [articleMapping mapKeyPath:kLocationAltitudeKey toAttribute:@"altitude"];
    [articleMapping mapKeyPath:kLocationVerticalAccuracyKey toAttribute:@"verticalAccuracy"];
    [articleMapping mapKeyPath:kLocationHorizontalAccuracyKey toAttribute:@"horizontalAccuracy"];
    
    [articleMapping mapRelationship:kLocationTripKey withMapping:[MTTrip mappingDefinition]];
    
    
    return articleMapping; 
}

+(void)loadObjectsWithDelegate:(id<RKObjectLoaderDelegate>)delegate;
{
    MTObjectStore *objectStore = [MTObjectStore sharedInstance];
    
    RKObjectMapping* articleMapping = [MTDevice mappingDefinition];
    
    [objectStore.objectManager.mappingProvider setMapping:articleMapping forKeyPath:@"locations"];
    
    
    [objectStore.objectManager loadObjectsAtResourcePath:@"location/?limit=0" delegate:delegate];
}



@end
