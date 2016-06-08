//
//  Premise.m
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 06/07/15.
//  Copyright (c) 2015 cekisakurek. All rights reserved.
//

#import "Premise.h"
#import "Constants.h"
#import "ServerEndPoints.h"
#import "Argument.h"
#import "Helpers.h"

@interface Argument ()
- (void)_postPremiseWithType:(PremiseType)type text:(NSString *)text parentPremiseID:(NSString *)parentPremiseID sources:(NSString *)sources completion:(void (^)(Premise *premise, NSError *error))completionBlock;
@end


@interface Premise ()
@property (weak) Argument *parentArgument;
@end

@implementation Premise

- (instancetype)initWithJSONResponse:(NSDictionary *)response
{
    self = [super init];
    if (self)
    {
        [self updateFromJSONResponse:response];

    }
    return self;
}

- (void)updateFromJSONResponse:(NSDictionary *)response
{
    _ID = TRY_CAST(response[@"id"], NSNumber);
    _user = [User userWithJSONResponse:TRY_CAST(response[@"user"], NSDictionary)];
    _text = TRY_CAST(response[@"text"], NSString);
    _sources = TRY_CAST(response[@"sources"], NSString);
    _parentID = TRY_CAST(response[@"parent"], NSNumber);
    _absoluteURL = TRY_CAST(response[@"parent"], NSString);
    _type = [TRY_CAST(response[@"premise_type"], NSNumber) integerValue];
    _creationDate = formatDateFromString(TRY_CAST(response[@"date_creation"], NSString));



    _contention = [[Contention alloc] initWithJSONResponse:response[@"contention"]];
    _language = TRY_CAST(response[@"language"], NSString);
    _relatedArgument = TRY_CAST(response[@"related_argument"], NSString);
    _premiseClass = TRY_CAST(response[@"premise_class"], NSString);
}


- (void)postPremiseWithType:(PremiseType)type text:(NSString *)text sources:(NSString *)sources completion:(void (^)(Premise *premise, NSError *error))completionBlock
{
    [self.parentArgument _postPremiseWithType:type text:text parentPremiseID:[self.ID stringValue] sources:sources completion:completionBlock];
}


- (void)deletePremiseWithCompletion:(void (^)(NSError *error))completionBlock
{

    if ([User currentUser].isAuthenticated)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];

        ARGRequest *request = [ARGRequest requestWithURL:[ServerEndPoints premiseEndPointWithID:[self.ID stringValue] argumentID:[self.parentArgument.ID stringValue]]];
        [request setHTTPMethod:@"DELETE"];

        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            //204
            if (completionBlock)
                completionBlock(error);
        }];

        [task resume];
    }
    else
    {
        // return not auth error
        if (completionBlock) {
            completionBlock([ARGError notAuthenticatedError]);
        }
    }
}






- (void)putPremiseWithType:(PremiseType)type text:(NSString *)text parent:(NSString *)parent sources:(NSString *)sources completion:(void (^)(Premise *premise, NSError *error))completionBlock
{

    ARGRequest *request = [ARGRequest requestWithURL:[ServerEndPoints argumentPremisesEndPointWithID:[self.parentArgument.ID stringValue]]];
    [request setHTTPMethod:@"PUT"];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(type) forKey:@"premise_type"];
    [params setObject:text forKey:@"text"];
    if (parent)
    {
        [params setObject:parent forKey:@"parent"];
    }
    if (sources) {
        [params setObject:sources forKey:@"sources"];
    }

    __weak Premise *weakRef = self;
    NSError *encodingError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&encodingError];
    [request setHTTPBody:postData];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (completionBlock)
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (httpResponse.statusCode == 200)
            {
#ifdef PRINT_SERVER_SERSPONSE
                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"%@",str);
#endif
                NSError *parsingError;
                NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];

                if (!parsingError)
                {
                    if (responseJSON)
                    {
                        [weakRef updateFromJSONResponse:responseJSON];
                        completionBlock(weakRef,nil);
                    }
                    else
                        completionBlock(nil,nil);
                }
                else // there is something wrong with the json
                    completionBlock(nil,parsingError);
            }
            else // there is something wrong with request
                completionBlock(nil,error);
        }        
    }];
    
    [task resume];
}

- (void)reportWithFallacy:(Fallacy *)fallacy completion:(void (^)(NSError *error))completionBlock
{
    
}



- (void)putSupportWithCompletion:(void (^)(NSError * _Nullable error))completionBlock
{
    if ([User currentUser].isAuthenticated)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];

        ARGRequest *request = [ARGRequest requestWithURL:[ServerEndPoints supportPremiseEndPointWithID:[self.ID stringValue] argumentID:[self.parentArgument.ID stringValue]]];
        [request addValue:[User currentUser].token forHTTPHeaderField:@"Authorization"];
        [request setHTTPMethod:@"POST"];

        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            //201
            if (completionBlock)
                completionBlock(error);
        }];
        
        [task resume];
    }
    else
    {
        // return not auth error
        if (completionBlock) {
            completionBlock(nil);
        }
    }

}

- (void)deleteSupportWithCompletion:(void (^)(NSError * _Nullable error))completionBlock
{
    if ([User currentUser].isAuthenticated)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];

        ARGRequest *request = [ARGRequest requestWithURL:[ServerEndPoints supportPremiseEndPointWithID:[self.ID stringValue] argumentID:[self.parentArgument.ID stringValue]]];
        [request addValue:[User currentUser].token forHTTPHeaderField:@"Authorization"];
        [request setHTTPMethod:@"DELETE"];

        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            //204
            if (completionBlock)
                completionBlock(error);
        }];

        [task resume];
    }
    else
    {
        // return not auth error
        if (completionBlock) {
            completionBlock([ARGError notAuthenticatedError]);
        }
    }
}

@end


@implementation PremiseSupportersController
- (instancetype)initWithJSONResponse:(NSDictionary *)response
{
    self = [super init];
    if (self)
    {
        _next = formatURLFromString(TRY_CAST([NSURL URLWithString:response[@"next"]], NSString));
        _previous = formatURLFromString(TRY_CAST([NSURL URLWithString:response[@"previous"]], NSString));
        _count = [TRY_CAST([NSURL URLWithString:response[@"count"]], NSNumber) unsignedIntegerValue];
        NSMutableArray *items = [NSMutableArray array];
        for (NSDictionary *i in TRY_CAST(response[@"results"], NSArray))
        {
            User *user = [User userWithJSONResponse:i];
            [items addObject:user];
        }
        _results = items;
    }
    return self;
}
- (void)getSupportersWithArgumentID:(NSString *)argID premiseID:(NSString *)premiseID WithCompletion:(void (^)(PremiseSupportersController *controller, NSError * _Nullable error))completionBlock
{

    ARGRequest *request = [ARGRequest requestWithURL:[ServerEndPoints premiseSupportersEndPointWithID:argID argumentID:premiseID]];
    [request setHTTPMethod:@"GET"];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (completionBlock)
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (httpResponse.statusCode == 200)
            {
#ifdef PRINT_SERVER_SERSPONSE
                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"%@",str);
#endif
                NSError *parsingError;
                NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];

                if (!parsingError)
                {
                    if (responseJSON)
                        completionBlock([[PremiseSupportersController alloc] initWithJSONResponse:responseJSON],nil);
                    else
                        completionBlock(nil,nil);
                }
                else // there is something wrong with the json
                    completionBlock(nil,parsingError);
            }
            else // there is something wrong with request
                completionBlock(nil,error);
        }
        
    }];
    
    [task resume];
}

@end