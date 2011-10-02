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

@synthesize location;
@synthesize trip;

/*{"meta": {"limit": 20, "next": null, "offset": 0, "previous": null, "total_count": 2}, "objects": [, {"altitude": 1.0, "horizontal_accuracy": 1.0, "id": "2", "latitude": 1.0, "longitude": 1.0, "resource_uri": "/api/v1/location/2/", "timestamp": "2011-09-29T23:52:45", "trip": "/api/v1/trip/1/", "user": "/api/v1/user/1/", "vertical_accuracy": 1.0}]}
 */

#pragma mark -
#pragma MTAPIObjectProtocol method overrides

-(id)initWithLocation:(CLLocation*)theLocation trip:(MTTrip*)theTrip
{
    self = [self init];
    if(self)
    {
        location = theLocation;
        trip = theTrip;
    }
    return self;
}

+(MTLocation*)locationWithLocation:(CLLocation *)theLocation trip:(MTTrip *)theTrip
{
    MTLocation *location = [[[MTLocation alloc] initWithLocation:theLocation trip:theTrip] autorelease];
    return location;
}

-(void)parseDictionary:(NSDictionary *)fields
{
    /*{"altitude": 1.0, "horizontal_accuracy": 1.0, "id": "1", "latitude": 1.0, "longitude": 1.0, "resource_uri": "/api/v1/location/1/", "timestamp": "2011-09-29T23:51:45", "trip": "/api/v1/trip/1/", "user": "/api/v1/user/1/", "vertical_accuracy": 1.0}
     */
    [super parseDictionary:fields];
    
    NSDictionary *objects = [fields objectForKey:kObjectsKey];
    if(!objects)
        objects = fields;
    
    double altitude = [[objects objectForKey:kLocationAltitudeKey] doubleValue];
    double horizontalAccuracy = [[objects objectForKey:kLocationHorizontalAccuracyKey] doubleValue];
    double verticalAccuracy = [[objects objectForKey:kLocationVerticalAccuracyKey] doubleValue];
    double latitude = [[objects objectForKey:kLocationLatitudeKey] doubleValue];
    double longitude = [[objects objectForKey:kLocationLongitudeKey] doubleValue];
    
    NSString *timestamp = [objects objectForKey:kLocationTimestampKey];
    
    NSDateFormatter *inFormat = [[NSDateFormatter alloc] init];
    [inFormat setDateFormat:@"YYYY-MM-ddTHH:mm:ss"];
    NSDate *parsedDate = [inFormat dateFromString:timestamp];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = latitude;
    coordinate.longitude = longitude;
    
    location = [[CLLocation alloc] initWithCoordinate:coordinate altitude:altitude horizontalAccuracy:horizontalAccuracy verticalAccuracy:verticalAccuracy timestamp:parsedDate];
    
    MTObjectStore *objectStore = [MTObjectStore sharedInstance];
    
    trip = (MTTrip*)[objectStore getObjectForURI:[objects objectForKey:kLocationTripKey]];
}

-(NSDictionary*)toDictionary
{
    /*Create Location
     {"altitude": 1.0, "horizontal_accuracy": 1.0, "latitude": 1.0, "longitude": 1.0, "timestamp": "2011-09-29T23:51:45", "trip": "/api/v1/trip/1/", "vertical_accuracy": 1.0}
     */
    NSNumber *altitude = [NSNumber numberWithDouble:location.altitude];
    NSNumber *horizontalAccuracy = [NSNumber numberWithDouble:location.horizontalAccuracy];
    NSNumber *verticalAccuracy = [NSNumber numberWithDouble:location.verticalAccuracy];
    NSNumber *latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    NSDateFormatter *outFormat = [[NSDateFormatter alloc] init];
    [outFormat setDateFormat:@"YYYY-MM-ddTHH:mm:ss"];
    NSString *timestamp = [outFormat stringFromDate:location.timestamp];

    
    NSArray *objectArray = [NSArray arrayWithObjects:altitude, horizontalAccuracy, verticalAccuracy, latitude, longitude, timestamp, trip.resourceURI, nil];
    NSArray *keyArray = [NSArray arrayWithObjects:kLocationAltitudeKey, kLocationHorizontalAccuracyKey, kLocationVerticalAccuracyKey, kLocationLatitudeKey, kLocationLongitudeKey, kLocationTimestampKey, kLocationTripKey, nil];
    return [NSDictionary dictionaryWithObjects:objectArray forKeys:keyArray];
}

+(NSURL*)RESTurl
{
    NSURL *url = [NSURL URLWithString:kAPIURLLocationSuffix relativeToURL:[[super class] RESTurl]];
    return url;
}


@end
