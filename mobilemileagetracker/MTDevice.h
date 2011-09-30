//
//  MTDevice.h
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTAPIObject.h"

#define kDeviceTypeKey @"device_type"
#define kDeviceNameKey @"name"
#define kDeviceUUIDKey @"uuid"

#define kAPIURLDeviceSuffix @"device/"

/*
 name = models.CharField(max_length=60)
 device_type = models.CharField(max_length=60)
 user = models.ForeignKey(User)
 uuid = models.CharField(max_length=60)
 */

@interface MTDevice : MTAPIObject
{
    
}

-(id)initWithName:(NSString*)newName;
+(MTDevice*)deviceWithName:(NSString*)newName;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *deviceType;
@property (nonatomic, retain) NSString *uuid;

@end
