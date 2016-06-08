//
//  Newsfeed.m
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 06/07/15.
//  Copyright (c) 2015 cekisakurek. All rights reserved.
//

#import "Newsfeed.h"
#import "ServerEndpoints.h"
#import "User.h"
#import "Helpers.h"

@implementation NewsfeedRelatedObject

- (instancetype)initWithJSONResponse:(NSDictionary *)response type:(NewsType)type
{
    self = [super init];
    if (self)
    {
        _owner = TRY_CAST(response[@"owner"], NSString);
        _uri = TRY_CAST(response[@"uri"], NSString);
        
        if (type == NewsTypeNewArgument)
        {
            _text = TRY_CAST(response[@"title"], NSString);
            _ID = TRY_CAST(response[@"id"], NSNumber);
        }
        else if(type == NewsTypeNewPremise)
        {
            _text = TRY_CAST(response[@"text"], NSString);
        }
        else if(type == NewsTypeFallacy)
        {
            _text = TRY_CAST(response[@"reason"], NSString);
            _fallacyType = TRY_CAST(response[@"fallacy_type"], NSString);
        }

        _contention = [[Contention alloc] initWithJSONResponse:response[@"contention"]];
        _type = [TRY_CAST(response[@"premise_type"], NSNumber) integerValue];
        if (response[@"premise"]) {
            _premise = [[Premise alloc] initWithJSONResponse:response[@"premise"]];
        }
    }
    return self;
}

- (instancetype)initWithJSONResponse:(NSDictionary *)response
{
    return [self initWithJSONResponse:response type:NewsTypeNewPremise];
}

@end


@implementation NewsfeedItem

- (instancetype)initWithJSONResponse:(NSDictionary *)response
{
    self = [super init];
    if (self)
    {

        _dateCreated = formatDateFromString(TRY_CAST(response[@"date_created"], NSString));
        _sender = [User userWithJSONResponse:TRY_CAST(response[@"sender"], NSDictionary)];

        _newsType = [TRY_CAST(response[@"news_type"], NSNumber) integerValue];
        _recipients = TRY_CAST(response[@"recipients"], NSArray);
        _object = [[NewsfeedRelatedObject alloc] initWithJSONResponse:response[@"related_object"] type:_newsType];

    }
    return self;
}


@end

@implementation NewsfeedController



- (instancetype)initWithJSONResponse:(NSDictionary *)response
{
    self = [super init];
    if (self)
    {
        _next = formatURLFromString(TRY_CAST(response[@"next"], NSString));
        _previous = formatURLFromString(TRY_CAST(response[@"previous"], NSString));
        NSMutableArray *items = [NSMutableArray array];
        for (NSDictionary *i in TRY_CAST(response[@"results"], NSArray))
        {
            NewsfeedItem *item = [[NewsfeedItem alloc] initWithJSONResponse:i];
            [items addObject:item];
        }
        _results = items;
    }
    return self;
}

+ (void)getFeedWithCompletion:(void (^)(NewsfeedController *newsfeedController, NSError *error))completionBlock
{


    ARGRequest *request = [ARGRequest requestWithURL:[ServerEndPoints newsfeedEndpoint]];
    [request setHTTPMethod:@"GET"];
    if ([User currentUser])
    {
        [request addValue:[User currentUser].token forHTTPHeaderField:@"Authorization"];
    }

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
                        completionBlock([[NewsfeedController alloc] initWithJSONResponse:responseJSON],nil);
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

- (void)getNextWithCompletion:(void (^)(NewsfeedController *newsfeedController, NSError *error))completionBlock{}
- (void)getPreviousWithCompletion:(void (^)(NewsfeedController *newsfeedController, NSError *error))completionBlock{}

@end









