//
//  MTAPIObject.m
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTAPIObject.h"
#import "APIUtil.h"
#import <RestKit/Support/JSON/JSONKit/JSONKit.h>

@implementation MTAPIObject

@synthesize _id;
@synthesize limit;
@synthesize next;
@synthesize previous;
@synthesize offset;
@synthesize totalCount;
@synthesize resourceURI;
@synthesize user;
@synthesize objects;

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
        objects = nil;
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
    objects = [fields objectForKey:kObjectsKey];
    if(!objects)
    {
        _id = [[fields objectForKey:kIDKey] retain];
        resourceURI = [[fields objectForKey:kResourceURIKey] retain];
        user = [[fields objectForKey:kUserKey] retain];
    }
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
    NSURL* url = [NSURL URLWithString:[APIUtil RESTurlString]];
    return url;
}

+(ASIFormDataRequest*)requestWithURL:(NSURL*)url filters:(NSDictionary*)filters
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(filters)
    {
        NSArray *allKeys = [filters allKeys];
        for(int i = 0; i < [allKeys count]; i++)
        {
            NSString *key = [allKeys objectAtIndex:i];
            NSString *value = [filters objectForKey:key];
            [request setPostValue:value forKey:key];
        }
    }
    //[request setPostValue:@"json" forKey:@"format"];
    NSString *username = [defaults objectForKey:@"username"];
    NSString *password = [defaults objectForKey:@"password"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUsername:username];
    [request setPassword:password];
    
    return request;
}


+(NSArray*)objectsWithData:(NSData*)jsonData
{
    return nil;
}

@end
