//
//  User.m
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 06/07/15.
//  Copyright (c) 2015 cekisakurek. All rights reserved.
//

#import "User.h"
#import "ServerEndPoints.h"
#import "Helpers.h"
#import "Argument.h"


@interface ArgumentsController ()
- (instancetype)initWithJSONResponse:(NSDictionary *)response;
@end


static User *currentUser;

@interface User () <NSURLSessionDelegate>
@property (assign) BOOL canAuthenticate;


@end


@implementation User

+ (User *)userWithJSONResponse:(NSDictionary *)response;
{
    User *user = [[User alloc] init];
    user.canAuthenticate = NO;
    user->_username = TRY_CAST(response[@"username"], NSString);
    user->_email = TRY_CAST(response[@"email"], NSString);
    user->_avatarURL = formatURLFromString(TRY_CAST(response[@"avatar"], NSString));
    user->_absoluteURL = TRY_CAST(response[@"absolute_url"],NSString);
    return user;
}

+ (User *)currentUser
{
    return currentUser;
}

- (void)setToken:(NSString *)token
{
    _token = token.copy;
}

- (void)logout
{
    self.token = nil;
}

- (BOOL)isAuthenticated
{
    return self.token?YES:NO;
}

+ (void)registerUserWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(User *user, NSError *error))completionBlock
{
    [self registerUserWithUsername:username password:password email:nil completion:completionBlock];

}

+ (void)registerUserWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email completion:(void (^)(User *user, NSError *error))completionBlock
{


    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[ServerEndPoints registerEndpoint]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];

    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];


    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:username forKey:@"username"];
    [params setObject:password forKey:@"password"];
    if (email) {
        [params setObject:email forKey:@"email"];
    }
    NSError *encodingError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&encodingError];
    [request setHTTPBody:postData];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if (httpResponse.statusCode == 200)
        {
            NSError *parsingError;
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
            if (!parsingError && responseJSON)
            {
                User *user = [[User alloc] init];
                user.canAuthenticate = YES;
                user->_username = responseJSON[@"username"];

                user->_email = responseJSON[@"email"];
                user->_password = password;
                if (completionBlock) {
                    completionBlock(user,nil);
                }
            }
        }
        else
        {
            // error
        }

    }];
    
    [task resume];
}


+ (void)userWithUsername:(NSString *)username completion:(void (^)(User *user, NSError *error))completionBlock
{
    ARGRequest *request = [ARGRequest requestWithURL:[ServerEndPoints userEndPointWithName:username]];
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
                        completionBlock([User userWithJSONResponse:responseJSON],nil);
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

- (void)authenticateWithCompletion:(void (^)(User *user, NSError *error))completionBlock;
{

    currentUser = self;

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[ServerEndPoints authenticationEndpoint]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];

    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];


    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.username forKey:@"username"];
    [params setObject:self.password forKey:@"password"];
    NSError *encodingError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&encodingError];
    [request setHTTPBody:postData];




    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if (httpResponse.statusCode == 200)
        {
            NSError *parsingError;
            id responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
            if (!parsingError && responseJSON)
            {


                currentUser.token = responseJSON[@"token"];
                if (completionBlock) {
                    completionBlock(currentUser,nil);
                }
            }
        }
        else
        {
            // error
        }

    }];
    
    [task resume];
}


- (void)ownedArgumentsWithCompletion:(void (^)(ArgumentsController *user, NSError *error))completionBlock
{

    NSMutableURLRequest *request = [ARGRequest requestWithURL:[ServerEndPoints ownedArgumentsEndPointWithName:self.username]];
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
- (void)contributedArgumentsWithCompletion:(void (^)(ArgumentsController *user, NSError *error))completionBlock
{
    NSMutableURLRequest *request = [ARGRequest requestWithURL:[ServerEndPoints contributedArgumentsEndPointWithName:self.username]];
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

@end
