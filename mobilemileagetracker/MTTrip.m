//
//  MTTrip.m
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTTrip.h"

@implementation MTTrip

@synthesize name;
@synthesize device;
@synthesize deviceURI;



-(id) init
{
    self = [super init];
    if(self)
    {
        name = nil;
        device = nil;
        deviceURI = nil;
    }
    return self;
}

-(id)initWithName:(NSString*)newName deviceURI:(NSString*)URI
{
    self = [self init];
    if(self)
    {
        name = newName;
        deviceURI = URI;
    }
    return self;
}

+(MTTrip*)tripWithName:(NSString*)newName deviceURI:(NSString*)URI
{
    MTTrip *trip = [[[MTTrip alloc] initWithName:newName deviceURI:URI] autorelease];
    return trip;
}

#pragma mark -
#pragma MTAPIObjectProtocol method overrides

-(void)parseDictionary:(NSDictionary *)fields
{
    /*{"meta": {"limit": 20, "next": null, "offset": 0, "previous": null, "total_count": 1}, "objects": [{"device": "/api/v1/device/1/", "id": "1", "name": "Chris Trip", "resource_uri": "/api/v1/trip/1/", "user": "/api/v1/user/1/"}]}
     */
    [super parseDictionary:fields];
    
    NSDictionary *objects = [fields objectForKey:kObjectsKey];
    if(!objects)
        objects = fields;
    name = [[objects objectForKey:kTripNameKey] retain];
    deviceURI = [[objects objectForKey:kTripDeviceKey] retain];
}

-(NSDictionary*)toDictionary
{
    /*Create Trip
        {"name": "Chris Trip", "device": "/api/v1/device/1/"}
     */
    NSArray *objectArray = [NSArray arrayWithObjects:name, deviceURI, nil];
    NSArray *keyArray = [NSArray arrayWithObjects:kTripNameKey, kTripDeviceKey, nil];
    return [NSDictionary dictionaryWithObjects:objectArray forKeys:keyArray];
}

+(NSURL*)RESTurl
{
    NSURL *url = [NSURL URLWithString:kAPIURLTripSuffix relativeToURL:[[super class] RESTurl]];
    return url;
}

@end
