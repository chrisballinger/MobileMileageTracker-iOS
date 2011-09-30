//
//  MTLocation.h
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTAPIObject.h"
#import <CoreLocation/CoreLocation.h>

/*
 latitude = models.FloatField()
 longitude = models.FloatField()
 timestamp = models.DateTimeField()
 altitude = models.FloatField()             # Positive values indicate altitudes above sea level. Negative values indicate altitudes below sea level.
 vertical_accuracy = models.FloatField()    # Vertical accuracy, values sent to server should be positive
 horizontal_accuracy = models.FloatField()  # The location's latitude and longitude identify the center of the circle, and this value indicates the radius of that circle
 user = models.ForeignKey(User)
 trip = models.ForeignKey(Trip)
 */

#define kLocationLatitudeKey @"latitude"
#define kLocationLongitudeKey @"longitude"
#define kLocationTimestampKey @"timestamp"
#define kLocationAltitudeKey @"altitude"
#define kLocationVerticalAccuracyKey @"vertical_accuracy"
#define kLocationHorizontalAccuracyKey @"horizontal_accuracy"
#define kLocationTripKey @"trip"

#define kAPIURLLocationSuffix @"location/"

@interface MTLocation : MTAPIObject
{
    
}

@property (readonly, retain) CLLocation *location;
@property (readonly, retain) NSString* tripURI;


@end
