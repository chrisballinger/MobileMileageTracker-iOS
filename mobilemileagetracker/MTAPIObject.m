//
//  MTAPIObject.m
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTAPIObject.h"
#import "APIUtil.h"
#import "JSONKit.h"

@implementation MTAPIObject

@synthesize _id;
@synthesize limit;
@synthesize next;
@synthesize previous;
@synthesize offset;
@synthesize totalCount;
@synthesize resourceURI;
@synthesize user;

-(id)init
{
    self = [super init];
    if(self)
    {
        _id = nil;
        limit = -1;
        next = nil;
        previous = nil;
        offset = -1;
        totalCount = -1;
        resourceURI = nil;
        user = nil;
    }
    return self;
}

#pragma mark -
#pragma MTAPIObjectProtocol methods

-(id)initWithData:(NSData*) jsonData
{
    self = [self init];
    
    [self parseJSON:jsonData];
    
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    
    [self parseDictionary:dictionary];
    
    return self;
}

-(void)parseDictionary:(NSDictionary *)fields
{
    NSDictionary *meta = [fields objectForKey:kMetadataKey];
    if(meta)
    {
        limit = [[meta objectForKey:kMetaLimitKey] intValue];
        offset = [[meta objectForKey:kMetaOffsetKey] intValue];
        totalCount = [[meta objectForKey:kMetaTotalCountKey] intValue];
        
        next = [[meta objectForKey:kMetaNextKey] retain];
        previous = [[meta objectForKey:kMetaPreviousKey] retain];
    }
    NSDictionary *objects = [fields objectForKey:kObjectsKey];
    if(!objects)
        objects = fields;
    _id = [[objects objectForKey:kIDKey] retain];
    resourceURI = [[objects objectForKey:kResourceURIKey] retain];
    user = [[objects objectForKey:kUserKey] retain];
}

-(void) parseJSON: (NSData*) jsonData
{
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    NSDictionary *fields = [jsonKitDecoder objectWithData:jsonData];
    
    [self parseDictionary:fields];
}
-(NSData*) toJSON;
{
    NSDictionary *data = [self toDictionary];
    return [data JSONData];
}

-(NSDictionary*)toDictionary
{
    return [[NSDictionary alloc] init];
}

+(NSURL*)RESTurl
{
    NSURL* url = [NSURL URLWithString:kAPIURLPrefix relativeToURL:[APIUtil hostURL]];
    return url;
}

@end
