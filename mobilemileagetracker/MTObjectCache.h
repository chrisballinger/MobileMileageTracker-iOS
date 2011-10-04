//
//  MTObjectCache.h
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 10/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface MTObjectCache : NSObject <RKManagedObjectCache>

- (NSFetchRequest *)fetchRequestDevicesForResourcePath:(NSString *)resourcePath;
- (NSFetchRequest *)fetchRequestTripsForResourcePath:(NSString *)resourcePath;
- (NSFetchRequest *)fetchRequestLocationsForResourcePath:(NSString *)resourcePath;


@end
