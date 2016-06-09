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
#import "Argument.h"
#import "Fallacy.h"

@interface Argument ()
- (instancetype)initWithJSONResponse:(NSDictionary *)response;
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

        if (_newsType == NewsTypeNewArgument)
            _object = [[Argument alloc] initWithJSONResponse:TRY_CAST(response[@"related_object"], NSDictionary)];
        else if(_newsType == NewsTypeNewPremise)
            _object = [[Premise alloc] initWithJSONResponse:TRY_CAST(response[@"related_object"], NSDictionary)];
        else if(_newsType == NewsTypeFallacy)
            _object = [[Fallacy alloc] initWithJSONResponse:TRY_CAST(response[@"related_object"], NSDictionary)];

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









