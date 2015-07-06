//
//  User.h
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 06/07/15.
//  Copyright (c) 2015 cekisakurek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (copy) NSString *email;
@property (copy) NSString *username;
@property (readonly) NSString *token;

/*
 
 email is optional
 
 Request:
 curl -X POST  -H "Content-Type: application/json"
 -d '{"username":"bahattincinic", "email": "bahattincinic@gmail.com", "password": "123456"}'
 http://arguman.org/api/v1/auth/register/
 
 Response (Status: 201 CREATED):
 {"email": "bahattincinic@gmail.com", "username": "bahattincinic"}
 
 */
+ (void)registerUserWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(User *user, NSError *error))completionBlock;
+ (void)registerUserWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email completion:(void (^)(User *user, NSError *error))completionBlock;



/*
 Request:
 curl -X POST  -H "Content-Type: application/json"
 -d '{"username":"<username>","password":"<password>"}'
 http://arguman.org/api/v1/auth/login/
 
 Response (Status: 200 OK):
 {
 "token": "d2b443e34d64124dd6d20044c39f6a6c82fd0ee2",
 }
 */

+ (void)authenticateWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(User *user, NSError *error))completionBlock;

@end
