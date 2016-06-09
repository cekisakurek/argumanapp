//
//  Argument.m
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 06/07/15.
//  Copyright (c) 2015 cekisakurek. All rights reserved.
//

#import "Argument.h"
#import "ServerEndPoints.h"
#import "User.h"
#import "Constants.h"
#import "Helpers.h"


@implementation Argument


- (instancetype)initWithJSONResponse:(NSDictionary *)response
{
    self = [super init];
    if (self)
    {
        [self updateFromJSONResponse:response];
    }
    return self;
}


- (NSArray *)topLayerPremises
{
    NSMutableArray *array = [NSMutableArray array];
    for (Premise *p in self.premises) {
        if (!p.parentID) {
            [array addObject:p];
        }
    }

    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:@"creationDate"
                                        ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    NSArray *sortedArray = [array
                                 sortedArrayUsingDescriptors:sortDescriptors];

    return sortedArray;
}

- (NSNumber *)becauseCount
{
    NSUInteger count = 0;
    for (Premise *p in self.premises)
        if (p.type == PremiseTypeBecause)
            count ++;
    return @(count);
}
- (NSNumber *)butCount
{
    NSUInteger count = 0;
    for (Premise *p in self.premises)
        if (p.type == PremiseTypeBut)
            count ++;
    return @(count);
}
- (NSNumber *)howeverCount
{
    NSUInteger count = 0;
    for (Premise *p in self.premises)
        if (p.type == PremiseTypeHowever)
            count ++;
    return @(count);
}

- (NSNumber *)supportRate
{
    NSUInteger butSupporters = 0;
    NSUInteger becauseSupporters = 0;
    NSUInteger howeverSupporters = 0;
    for (Premise *p in self.premises) {
        if (p.type == PremiseTypeHowever)
            howeverSupporters ++;
        if (p.type == PremiseTypeBut)
            butSupporters ++;
        if (p.type == PremiseTypeBecause)
            becauseSupporters ++;
    }
    return @(0);
}

- (void)updateFromJSONResponse:(NSDictionary *)response
{
    _ID = response[@"id"];
    _user = [User userWithJSONResponse:TRY_CAST(response[@"user"], NSDictionary)];
    _title = response[@"title"];
    _slug = response[@"slug"];
    _argumentDescription = response[@"description"];
    _owner = response[@"owner"];
    _sources = response[@"sources"];

    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *d in TRY_CAST(response[@"premises"], NSArray))
    {
        Premise *p = [[Premise alloc] initWithJSONResponse:d];
        [arr addObject:p];
    }

    _premises = arr;
    _dateCreated = formatDate1FromString(TRY_CAST(response[@"date_creation"], NSString));
    _absoluteURL = formatURLFromString(TRY_CAST(response[@"absolute_url"], NSString));
    _reportCount = TRY_CAST(response[@"report_count"], NSNumber);
    _featured = [TRY_CAST(response[@"is_featured"], NSNumber) boolValue];
    if ([[response allKeys] containsObject:@"is_published"])
    {
        _published = [TRY_CAST(response[@"is_published"], NSNumber) boolValue];
    }
}

- (void)updatePremises:(NSArray *)premises
{
    _premises = premises;
}

+ (void)getArgumentWithID:(NSString *)ID completion:(void (^)(Argument *argument, NSError *error))completionBlock
{
    ARGRequest *request = [ARGRequest requestWithURL:[ServerEndPoints argumentEndpointWithId:ID]];
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
                        completionBlock([[Argument alloc] initWithJSONResponse:responseJSON],nil);
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


- (void)getPremisesWithCompletion:(void (^)(NSArray *premises, NSError *error))completionBlock
{
    ARGRequest *request = [ARGRequest requestWithURL:[ServerEndPoints argumentPremisesEndPointWithID:[self.ID stringValue]]];
    [request setHTTPMethod:@"GET"];

    __weak Argument *weakRef = self;
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
                        NSMutableArray *premises = [NSMutableArray array];
                        for (NSDictionary *d in TRY_CAST(responseJSON, NSArray)) {
                            Premise *p = [[Premise alloc] initWithJSONResponse:d];
                            [premises addObject:p];
                        }
                        [weakRef updatePremises:premises];
                        completionBlock(weakRef.premises,nil);
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


+ (void)postArgumentWithTitle:(NSString *)title sources:(NSString *)sources owner:(NSString *)owner publish:(BOOL)publish completion:(void (^)(Argument *argument, NSError *error))completionBlock
{
    ARGRequest *request = [ARGRequest requestWithURL:[ServerEndPoints argumentEndpointWithId:nil]];
    [request setHTTPMethod:@"POST"];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:title forKey:@"title"];
    if (sources)
    {
        [params setObject:sources forKey:@"sources"];
    }
    if (owner) {
        [params setObject:owner forKey:@"owner"];
    }
    [params setObject:@(publish) forKey:@"publish"];

    NSError *encodingError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&encodingError];
    [request setHTTPBody:postData];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (completionBlock)
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (httpResponse.statusCode == 201)
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
                        completionBlock([[Argument alloc] initWithJSONResponse:responseJSON],nil);
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


- (void)putArgumentWithTitle:(NSString *)title sources:(NSString *)sources owner:(NSString *)owner publish:(BOOL)publish completion:(void (^)(Argument *argument, NSError *error))completionBlock
{

    ARGRequest *request = [ARGRequest requestWithURL:[ServerEndPoints argumentEndpointWithId:nil]];
    [request setHTTPMethod:@"PUT"];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:title forKey:@"title"];
    if (sources)
    {
        [params setObject:sources forKey:@"sources"];
    }
    if (owner) {
        [params setObject:owner forKey:@"owner"];
    }
    [params setObject:@(publish) forKey:@"publish"];

    NSError *encodingError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&encodingError];
    [request setHTTPBody:postData];

    __weak Argument *weakRef = self;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (completionBlock)
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (httpResponse.statusCode == 201)
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


- (void)deleteArgumentWithCompletion:(void (^)(NSError *error))completionBlock
{
    if ([User currentUser].isAuthenticated)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];

        ARGRequest *request = [ARGRequest requestWithURL:[ServerEndPoints argumentEndpointWithId:nil]];
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


- (void)_postPremiseWithType:(PremiseType)type text:(NSString *)text parentPremiseID:(NSString *)parentPremiseID sources:(NSString *)sources completion:(void (^)(Premise *premise, NSError *error))completionBlock
{
    ARGRequest *request = [ARGRequest requestWithURL:[ServerEndPoints argumentPremisesEndPointWithID:[self.ID stringValue]]];
    [request setHTTPMethod:@"POST"];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(type) forKey:@"premise_type"];
    [params setObject:text forKey:@"text"];
    if (sources) {
        [params setObject:sources forKey:@"sources"];
    }
    if (parentPremiseID) {
        [params setObject:parentPremiseID forKey:@"parent"];
    }

    NSError *encodingError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&encodingError];
    [request setHTTPBody:postData];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (completionBlock)
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (httpResponse.statusCode == 201)
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
                        completionBlock([[Premise alloc] initWithJSONResponse:responseJSON],nil);
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

- (void)postPremiseWithType:(PremiseType)type text:(NSString *)text sources:(NSString *)sources completion:(void (^)(Premise *premise, NSError *error))completionBlock
{
    [self _postPremiseWithType:type text:text parentPremiseID:nil sources:sources completion:completionBlock];
}



@end


@implementation ArgumentsController


- (instancetype)initWithJSONResponse:(NSDictionary *)response
{
    self = [super init];
    if (self)
    {
        _next = formatURLFromString(TRY_CAST(response[@"next"], NSString));
        _previous = formatURLFromString(TRY_CAST(response[@"previous"], NSString));
        _count = [TRY_CAST(response[@"count"], NSNumber) unsignedIntegerValue];
        NSMutableArray *items = [NSMutableArray array];
        for (NSDictionary *i in TRY_CAST(response[@"results"], NSArray))
        {
            Argument *arg = [[Argument alloc] initWithJSONResponse:i];
            [items addObject:arg];
        }
        _results = items;
    }
    return self;
}

+ (void)_getArgumentsWithFeatured:(BOOL)featured ordering:(NSString *)ordering keyword:(NSString *)keyword completion:(void (^)(ArgumentsController *argumentsController, NSError *error))completionBlock
{

    NSMutableString *queryString = [[NSMutableString alloc] init];
    if (keyword)
    {
        [queryString appendString:@"search="];
        [queryString appendString:keyword];
        [queryString appendString:@"&"];
    }
    if (ordering)
    {
        [queryString appendString:@"ordering="];
        [queryString appendString:ordering];
        [queryString appendString:@"&"];
    }
    if (featured)
    {
        [queryString appendString:@"is_featured=True"];
    }

    NSMutableString *urlString = [[NSMutableString alloc] initWithString:[[ServerEndPoints argumentEndpointWithId:nil] absoluteString]];
    if (queryString.length) {
        [urlString appendString:@"?"];
        [urlString appendString:queryString];
    }


    NSMutableURLRequest *request = [ARGRequest requestWithURL:[NSURL URLWithString:urlString]];
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
                        completionBlock([[ArgumentsController alloc] initWithJSONResponse:responseJSON],nil);
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

+ (void)getArgumentsWithCompletion:(void (^)(ArgumentsController *argumentsController, NSError *error))completionBlock
{
    [self _getArgumentsWithFeatured:NO ordering:nil keyword:nil completion:completionBlock];
}

+ (void)getFeaturedArgumentsWithCompletion:(void (^)(ArgumentsController *argumentsController, NSError *error))completionBlock
{
    [self _getArgumentsWithFeatured:YES ordering:nil keyword:nil completion:completionBlock];
}

+ (void)searchArguments:(NSString *)keyword completion:(void (^)(ArgumentsController *argumentsController, NSError *error))completionBlock
{
    [self _getArgumentsWithFeatured:NO ordering:nil keyword:keyword completion:completionBlock];
}

@end