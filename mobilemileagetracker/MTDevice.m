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
    NSArray *objectArray = [NSArray arrayWithObjects:deviceType, name, uuid, nil];
    NSArray *keyArray = [NSArray arrayWithObjects:kDeviceTypeKey, kDeviceNameKey, kDeviceUUIDKey, nil];
    return [NSDictionary dictionaryWithObjects:objectArray forKeys:keyArray];
}

+(NSURL*)RESTurl
{
    NSString *urlStart = [APIUtil RESTurlString];
    
    NSString *urlString = [urlStart stringByAppendingString:kAPIURLDeviceSuffix];
    
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

+(ASIFormDataRequest*)requestWithFilters:(NSDictionary*)filters
{
    NSURL *url = [[self class] RESTurl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(filters)
    {
        NSArray *allKeys = [filters allKeys];
        for(int i = 0; i < [allKeys count]; i++)
        {
            NSString *key = [allKeys objectAtIndex:i];
            NSString *value = [filters objectForKey:key];
            [request setPostValue:value forKey:key];
        }
    }
    //[request setPostValue:@"json" forKey:@"format"];
    NSString *username = [defaults objectForKey:@"username"];
    NSString *password = [defaults objectForKey:@"password"];
    [request setUsername:username];
    [request setPassword:password];
    
    
    
    return request;
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
