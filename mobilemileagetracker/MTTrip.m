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

@synthesize name;
@synthesize device;

-(id) init
{
    self = [super init];
    if(self)
    {
        name = nil;
        device = nil;
    }
    return self;
}

-(id)initWithName:(NSString*)newName device:(MTDevice*)newDevice
{
    self = [self init];
    if(self)
    {
        name = newName;
        device = newDevice;
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

-(void)parseDictionary:(NSDictionary *)fields
{
    /*{"meta": {"limit": 20, "next": null, "offset": 0, "previous": null, "total_count": 1}, "objects": [{"device": "/api/v1/device/1/", "id": "1", "name": "Chris Trip", "resource_uri": "/api/v1/trip/1/", "user": "/api/v1/user/1/"}]}
     */
    [super parseDictionary:fields];
    
    NSDictionary *objects = [fields objectForKey:kObjectsKey];
    if(!objects)
        objects = fields;
    name = [[objects objectForKey:kTripNameKey] retain];
    NSString *deviceURI = [objects objectForKey:kTripDeviceKey];
    MTObjectStore *objectStore = [MTObjectStore sharedInstance];
    device = (MTDevice*)[objectStore getObjectForURI:deviceURI];
    
    super.resourceID = [[fields objectForKey:kIDKey] retain];

}

-(NSDictionary*)toDictionary
{
    /*Create Trip
        {"name": "Chris Trip", "device": "/api/v1/device/1/"}
     */
    NSMutableArray *objectArray = [NSMutableArray arrayWithObjects:name, device.resourceURI, nil];
    NSMutableArray *keyArray = [NSMutableArray arrayWithObjects:kTripNameKey, kTripDeviceKey, nil];
    
    if(super.resourceID)
    {
        [objectArray addObject:super.resourceID];
        [keyArray addObject:kIDKey];
    }
    
    return [NSDictionary dictionaryWithObjects:objectArray forKeys:keyArray];
}

+(NSURL*)RESTurl
{
    NSString *urlStart = [APIUtil RESTurlString];
    
    NSString *urlString = [urlStart stringByAppendingString:kAPIURLTripSuffix];
    
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

+(NSArray*)objectsWithData:(NSData*)jsonData
{
    /*{"meta": {"limit": 20, "next": null, "offset": 0, "previous": null, "total_count": 1}, "objects": [{"device_type": "iPhone", "id": "1", "name": "Chris Phone", "resource_uri": "/api/v1/device/1/", "user": "/api/v1/user/1/", "uuid": "1"}]}
     */
    MTAPIObject *apiObject = [[MTAPIObject alloc] initWithData:jsonData];
    
    if(apiObject.totalCount > 0)
    {
        NSMutableArray *devicesArray = [[NSMutableArray alloc] initWithCapacity:[apiObject.totalCount intValue]];
        
        NSArray *rawDevicesArray = apiObject.objects;
        
        for(int i = 0; i < [apiObject.totalCount intValue]; i++)
        {
            NSDictionary *rawDevice = [rawDevicesArray objectAtIndex:i];
            MTTrip *trip = [[MTTrip alloc] initWithDictionary:rawDevice];
            [devicesArray addObject:trip];
        }
        return devicesArray;
    }
    
    return nil;
}

+(id<RKObjectMappingDefinition>)mappingDefinition
{
    RKObjectMapping* articleMapping = [RKObjectMapping mappingForClass:[MTTrip class]];
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
    
    RKObjectMapping* articleMapping = [MTTrip mappingDefinition];
    
    [objectStore.objectManager.mappingProvider setMapping:articleMapping forKeyPath:@"trips"];
    
    
    [objectStore.objectManager loadObjectsAtResourcePath:@"trip/?limit=0" delegate:delegate];
}

@end
