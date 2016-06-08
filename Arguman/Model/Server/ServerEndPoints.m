//
//  ServerEndPoints.m
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 06/06/16.
//  Copyright © 2016 cekisakurek. All rights reserved.
//

#import "ServerEndPoints.h"

@interface ServerEndPoints()
+ (instancetype)defaults;
@property (nonatomic,strong) NSURL *baseURL;
@end

@implementation ServerEndPoints



+ (instancetype)defaults
{
    static dispatch_once_t once;
    static ServerEndPoints *defaults;
    dispatch_once(&once, ^ { defaults = [[self alloc] init]; });
    return defaults;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.baseURL = [NSURL URLWithString:@"http://en.arguman.org/"];

    }
    return self;
}

//
+ (NSURL *)registerEndpoint
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:[ServerEndPoints defaults].baseURL resolvingAgainstBaseURL:NO];
    [components setPath:@"/api/v1/auth/register"];
    return components.URL;
}

+ (NSURL *)authenticationEndpoint
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:[ServerEndPoints defaults].baseURL resolvingAgainstBaseURL:NO];
    [components setPath:@"/api/v1/auth/login/"];
    return components.URL;
}

+ (NSURL *)newsfeedEndpoint
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:[ServerEndPoints defaults].baseURL resolvingAgainstBaseURL:NO];
    [components setPath:@"/api/v1/newsfeed/public/"];
    return components.URL;
}

+ (NSURL *)postArgumentEndPoint
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:[ServerEndPoints defaults].baseURL resolvingAgainstBaseURL:NO];
    [components setPath:@"/api/v1/arguments/"];
    return components.URL;
}
+ (NSURL *)argumentEndpointWithId:(NSString *)ID
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:[ServerEndPoints defaults].baseURL resolvingAgainstBaseURL:NO];
    if (ID) {
        [components setPath:[NSString stringWithFormat:@"/api/v1/arguments/%@/",ID]];
    }
    else
    {
        [components setPath:@"/api/v1/arguments/"];
    }

    return components.URL;
}

+ (NSURL *)premiseEndPointWithID:(NSString *)ID argumentID:(NSString *)argID
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:[ServerEndPoints defaults].baseURL resolvingAgainstBaseURL:NO];
    [components setPath:[NSString stringWithFormat:@"/api/v1/arguments/%@/premises/%@/",ID,argID]];
    return components.URL;
}

+ (NSURL *)premiseSupportersEndPointWithID:(NSString *)ID argumentID:(NSString *)argID
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:[ServerEndPoints defaults].baseURL resolvingAgainstBaseURL:NO];
    [components setPath:[NSString stringWithFormat:@"/api/v1/arguments/%@/premises/%@/supporters/",ID,argID]];
    return components.URL;
}
//
+ (NSURL *)supportPremiseEndPointWithID:(NSString *)ID argumentID:(NSString *)argID
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:[ServerEndPoints defaults].baseURL resolvingAgainstBaseURL:NO];
    [components setPath:[NSString stringWithFormat:@"/api/v1/arguments/%@/premises/%@/support/",ID,argID]];
    return components.URL;
}


+ (NSURL *)argumentPremisesEndPointWithID:(NSString *)argID
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:[ServerEndPoints defaults].baseURL resolvingAgainstBaseURL:NO];
    [components setPath:[NSString stringWithFormat:@"/api/v1/arguments/%@/premises/",argID]];
    return components.URL;
}


+ (NSURL *)ownedArgumentsEndPointWithName:(NSString *)username;
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:[ServerEndPoints defaults].baseURL resolvingAgainstBaseURL:NO];
    [components setPath:[NSString stringWithFormat:@"/api/v1/users/%@/arguments/owner/",username]];
    return components.URL;
}

+ (NSURL *)contributedArgumentsEndPointWithName:(NSString *)username
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:[ServerEndPoints defaults].baseURL resolvingAgainstBaseURL:NO];
    [components setPath:[NSString stringWithFormat:@"/api/v1/users/%@/arguments/contributed/",username]];
    return components.URL;
}

+ (NSURL *)userEndPointWithName:(NSString *)username
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:[ServerEndPoints defaults].baseURL resolvingAgainstBaseURL:NO];
    [components setPath:[NSString stringWithFormat:@"/api/v1/users/%@/",username]];
    return components.URL;
}


@end



@implementation ARGRequest

+ (ARGRequest *)requestWithURL:(NSURL *)url
{
    ARGRequest *request = [ARGRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];

    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    return request;
}

@end