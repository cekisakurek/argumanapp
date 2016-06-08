//
//  ServerEndPoints.h
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 06/06/16.
//  Copyright © 2016 cekisakurek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "ARGError.h"


@interface ServerEndPoints : NSObject


+ (NSURL *)registerEndpoint;
+ (NSURL *)authenticationEndpoint;
+ (NSURL *)newsfeedEndpoint;

+ (NSURL *)argumentEndpointWithId:(NSString *)ID;

+ (NSURL *)premiseEndPointWithID:(NSString *)ID argumentID:(NSString *)argID;
+ (NSURL *)supportPremiseEndPointWithID:(NSString *)ID argumentID:(NSString *)argID;

+ (NSURL *)premiseSupportersEndPointWithID:(NSString *)ID argumentID:(NSString *)argID;
+ (NSURL *)argumentPremisesEndPointWithID:(NSString *)argID;


+ (NSURL *)ownedArgumentsEndPointWithName:(NSString *)username;
+ (NSURL *)contributedArgumentsEndPointWithName:(NSString *)username;

+ (NSURL *)userEndPointWithName:(NSString *)username;
///api/v1/users/<username>/
@end


@interface ARGRequest : NSMutableURLRequest

+ (ARGRequest *)requestWithURL:(NSURL *)url;

@end