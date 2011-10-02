//
//  MTDevice.m
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTDevice.h"
#import "APIUtil.h"

@implementation MTDevice

/*

 */

@synthesize name;
@synthesize deviceType;
@synthesize uuid;

-(id) init
{
    self = [super init];
    if(self)
    {
        name = nil;
        deviceType = nil;
        uuid = nil;
    }
    return self;
}

-(id)initWithName:(NSString*)newName
{
    self = [self init];
    if(self)
    {
        name = newName;
        deviceType = @"iPhone";
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        uuid = [defaults objectForKey:@"uuid"];
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

-(void)parseDictionary:(NSDictionary *)fields
{
    /*{"meta": {"limit": 20, "next": null, "offset": 0, "previous": null, "total_count": 1}, "objects": [{"device_type": "iPhone", "id": "1", "name": "Chris Phone", "resource_uri": "/api/v1/device/1/", "user": "/api/v1/user/1/", "uuid": "1"}]}*/
    [super parseDictionary:fields];
    
    name = [[fields objectForKey:kDeviceNameKey] retain];
    deviceType = [[fields objectForKey:kDeviceTypeKey] retain];
    uuid = [[fields objectForKey:kDeviceUUIDKey] retain];
    super._id = [[fields objectForKey:kIDKey] retain];
}

-(NSDictionary*)toDictionary
{
    /*Create Device
     '{"device_type": "iPhone", "name": "Chris Phone", "uuid": "1"}'
     */
    NSMutableArray *objectArray = [NSMutableArray arrayWithObjects:deviceType, name, uuid, nil];
    NSMutableArray *keyArray = [NSMutableArray arrayWithObjects:kDeviceTypeKey, kDeviceNameKey, kDeviceUUIDKey, nil];
    
    if(super._id)
    {
        [objectArray addObject:super._id];
        [keyArray addObject:kIDKey];
    }
    
    return [NSDictionary dictionaryWithObjects:objectArray forKeys:keyArray];
}

+(NSURL*)RESTurl
{
    NSString *urlStart = [APIUtil RESTurlString];
    
    NSString *urlString = [urlStart stringByAppendingString:kAPIURLDeviceSuffix];
    
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
        NSMutableArray *devicesArray = [[NSMutableArray alloc] initWithCapacity:apiObject.totalCount];
        
        NSArray *rawDevicesArray = apiObject.objects;
        
        for(int i = 0; i < apiObject.totalCount; i++)
        {
            NSDictionary *rawDevice = [rawDevicesArray objectAtIndex:i];
            MTDevice *device = [[MTDevice alloc] initWithDictionary:rawDevice];
            [devicesArray addObject:device];
        }
        return devicesArray;
    }
    
    return nil;
}



@end
