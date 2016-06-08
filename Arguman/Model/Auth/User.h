//
//  User.h
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 06/07/15.
//  Copyright (c) 2015 cekisakurek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Argument,ArgumentsController;

@interface User : NSObject

@property (readonly, copy) NSString *email;
@property (readonly, copy) NSString *username;
@property (readonly) NSString *token;
@property (readonly, copy) NSString *password;

@property (readonly, copy) NSString *absoluteURL;
@property (readonly, copy) NSURL *avatarURL;

+ (User *)currentUser;
- (void)logout;

- (BOOL)isAuthenticated;

+ (User *)userWithJSONResponse:(NSDictionary *)response;

+ (void)userWithUsername:(NSString *)username completion:(void (^)(User *user, NSError *error))completionBlock;

+ (void)registerUserWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(User *user, NSError *error))completionBlock;
+ (void)registerUserWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email completion:(void (^)(User *user, NSError *error))completionBlock;


- (void)authenticateWithCompletion:(void (^)(User *user, NSError *error))completionBlock;


- (void)ownedArgumentsWithCompletion:(void (^)(ArgumentsController *user, NSError *error))completionBlock;
- (void)contributedArgumentsWithCompletion:(void (^)(ArgumentsController *user, NSError *error))completionBlock;


@end
