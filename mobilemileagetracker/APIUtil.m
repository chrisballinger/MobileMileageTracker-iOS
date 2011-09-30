//
//  APIUtil.m
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "APIUtil.h"

@implementation APIUtil

#define kAPIURLPrefix @"api/v1/"

+(NSString*)hostURLString
{
    return kHostURL;
}

+(NSString*)RESTurlString
{
    NSString* urlString = [[APIUtil hostURLString] stringByAppendingString:kAPIURLPrefix];
    return urlString;
}

@end
