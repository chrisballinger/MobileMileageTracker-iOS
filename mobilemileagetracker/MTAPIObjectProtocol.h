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

-(id) initWithData: (NSData*) jsonData;
-(id) initWithDictionary: (NSDictionary*) dictionary;
-(void)parseDictionary:(NSDictionary*)fields;
-(void) parseJSON: (NSData*) jsonData;
-(NSData*) toJSON;
-(NSDictionary*) toDictionary;

+(NSURL*)RESTurl;
+(ASIFormDataRequest*)requestWithURL:(NSURL*)url filters:(NSDictionary*)filters;
+(NSArray*)objectsWithData:(NSData*)jsonData;

+(void)loadObjectsWithDelegate:(id<RKObjectLoaderDelegate>)delegate;
+(id<RKObjectMappingDefinition>)mappingDefinition;

@end
