//
//  MTTrip.h
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTAPIObject.h"
#import "MTDevice.h"

/*
 name = models.CharField(max_length=60)
 user = models.ForeignKey(User)
 device = models.ForeignKey(Device)
 */

#define kTripNameKey @"name"
#define kTripDeviceKey @"device"

#define kAPIURLTripSuffix @"trip/"

@interface MTTrip : MTAPIObject
{
    
}

-(id)initWithName:(NSString*)newName device:(MTDevice*)newDevice;
+(MTTrip*)tripWithName:(NSString*)newName device:(MTDevice*)newDevice;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) MTDevice *device;

@end
