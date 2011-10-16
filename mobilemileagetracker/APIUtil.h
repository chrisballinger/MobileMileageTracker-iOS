//
//  APIUtil.h
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kHostURL @"http://chrisballinger.pagekite.me/"
#define kAPIURLPrefix @"api/v1/"

@interface APIUtil : NSObject

+(NSString*)hostURLString;
+(NSString*)RESTurlString;

@end
