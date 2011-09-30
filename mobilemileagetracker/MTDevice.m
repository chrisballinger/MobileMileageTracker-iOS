//
//  MTDevice.m
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTDevice.h"

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
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        uuid = (NSString *)string;
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
    
    NSDictionary *objects = [fields objectForKey:kObjectsKey];
    if(!objects)
        objects = fields;
    name = [[objects objectForKey:kDeviceNameKey] retain];
    deviceType = [[objects objectForKey:kDeviceTypeKey] retain];
    uuid = [[objects objectForKey:kDeviceUUIDKey] retain];
}

-(NSDictionary*)toDictionary
{
    /*Create Device
     '{"device_type": "iPhone", "name": "Chris Phone", "uuid": "1"}'
     */
    NSArray *objectArray = [NSArray arrayWithObjects:deviceType, name, uuid, nil];
    NSArray *keyArray = [NSArray arrayWithObjects:kDeviceTypeKey, kDeviceNameKey, kDeviceUUIDKey, nil];
    return [NSDictionary dictionaryWithObjects:objectArray forKeys:keyArray];
}

+(NSURL*)RESTurl
{
    NSURL *url = [NSURL URLWithString:kAPIURLDeviceSuffix relativeToURL:[[super class] RESTurl]];
    return url;
}

@end
