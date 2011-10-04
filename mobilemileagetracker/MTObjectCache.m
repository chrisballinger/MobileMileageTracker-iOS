//
//  MTObjectCache.m
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 10/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTObjectCache.h"
#import "MTDevice.h"
#import "MTTrip.h"
#import "MTLocation.h"

@implementation MTObjectCache

- (NSArray*)fetchRequestsForResourcePath:(NSString*)resourcePath {
    
    NSCParameterAssert(resourcePath != NULL);
    
    NSFetchRequest *fetchRequest = nil;
    
    // Venues
    if ([resourcePath hasPrefix:@"device/"]) {
        fetchRequest = [self fetchRequestDevicesForResourcePath:resourcePath];
    }
    else if([resourcePath hasPrefix:@"trip/"]) {
        fetchRequest = [self fetchRequestTripsForResourcePath:resourcePath];
    }
    else if([resourcePath hasPrefix:@"location/"]) {
        fetchRequest = [self fetchRequestLocationsForResourcePath:resourcePath];
    }
    
    if (fetchRequest != nil) {
        return [NSArray arrayWithObject:fetchRequest];
    }
    
    return nil;
}

#pragma mark - Methods to get fetch requests for paths
- (NSFetchRequest *)fetchRequestDevicesForResourcePath:(NSString *)resourcePath {
    
    // Get resources
    // NSDictionary *arguments    = nil;
    NSFetchRequest *request    = [MTDevice fetchRequest];
    // RKPathMatcher *pathMatcher = [RKPathMatcher matcherWithPath:resourcePath];
    // NSPredicate *predicate     = [NSPredicate predicateWithValue:YES];
    
    request.predicate = nil;
    
    //    if ([pathMatcher matchesPattern:@"/venues/:venueId"
    //               tokenizeQueryStrings:YES
    //                    parsedArguments:&arguments]) {
    //        
    //        predicate = [NSPredicate predicateWithFormat:@"venueId LIKE[cd] %@", [arguments objectForKey:@"venue_id"]];
    //        [request setPredicate:predicate];
    //    }
    
    NSSortDescriptor *byName = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                             ascending:YES];
    
    [request setSortDescriptors:[NSArray arrayWithObject:byName]];
    
    return request;
}
- (NSFetchRequest *)fetchRequestTripsForResourcePath:(NSString *)resourcePath {
    
    // Get resources
    // NSDictionary *arguments    = nil;
    NSFetchRequest *request    = [MTTrip fetchRequest];
    // RKPathMatcher *pathMatcher = [RKPathMatcher matcherWithPath:resourcePath];
    // NSPredicate *predicate     = [NSPredicate predicateWithValue:YES];
    
    request.predicate = nil;
    
    //    if ([pathMatcher matchesPattern:@"/venues/:venueId"
    //               tokenizeQueryStrings:YES
    //                    parsedArguments:&arguments]) {
    //        
    //        predicate = [NSPredicate predicateWithFormat:@"venueId LIKE[cd] %@", [arguments objectForKey:@"venue_id"]];
    //        [request setPredicate:predicate];
    //    }
    
    NSSortDescriptor *byName = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                             ascending:YES];
    
    [request setSortDescriptors:[NSArray arrayWithObject:byName]];
    
    return request;
}
- (NSFetchRequest *)fetchRequestLocationsForResourcePath:(NSString *)resourcePath {
    
    // Get resources
    // NSDictionary *arguments    = nil;
    NSFetchRequest *request    = [MTLocation fetchRequest];
    // RKPathMatcher *pathMatcher = [RKPathMatcher matcherWithPath:resourcePath];
    // NSPredicate *predicate     = [NSPredicate predicateWithValue:YES];
    
    request.predicate = nil;
    
    //    if ([pathMatcher matchesPattern:@"/venues/:venueId"
    //               tokenizeQueryStrings:YES
    //                    parsedArguments:&arguments]) {
    //        
    //        predicate = [NSPredicate predicateWithFormat:@"venueId LIKE[cd] %@", [arguments objectForKey:@"venue_id"]];
    //        [request setPredicate:predicate];
    //    }
    
    //NSSortDescriptor *byName = [NSSortDescriptor sortDescriptorWithKey:@"name"
    //                                                         ascending:YES];
    
    //[request setSortDescriptors:[NSArray arrayWithObject:byName]];
    
    return request;
}




@end


