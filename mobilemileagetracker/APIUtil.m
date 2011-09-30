//
//  APIUtil.m
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "APIUtil.h"

@implementation APIUtil

+(NSURL*)hostURL
{
    NSURL *url = [NSURL URLWithString:kHostURL];
    return url;
}

@end
