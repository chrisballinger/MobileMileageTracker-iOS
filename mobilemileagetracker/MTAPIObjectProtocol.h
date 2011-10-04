//
//  MTAPIObjectProtocol.h
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@protocol MTAPIObjectProtocol <NSObject>

+(void)loadObjectsWithDelegate:(id<RKObjectLoaderDelegate>)delegate;
+(id<RKObjectMappingDefinition>)mappingDefinition;
+(NSArray*)cachedObjects;

@end
