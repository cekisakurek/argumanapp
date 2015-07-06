//
//  Argument.h
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 06/07/15.
//  Copyright (c) 2015 cekisakurek. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;
@interface Argument : NSObject

@property (readonly) NSNumber *Id;
@property (readonly) User *user;
@property (copy) NSString *title;
@property (readonly) NSString *slug;
@property (readonly) NSString *argumentDescription;
@property (copy) NSString *sources;
@property (readonly) NSArray *premises;
@property (readonly) NSDate *creationDate;
@property (readonly) NSURL *absoluteURL;
@property (readonly) NSNumber *reportCount;
@property (assign,readonly,getter = isFeatured) BOOL featured;
@property (assign,getter = isPublished) BOOL published;
/*
 
 Request:
 curl -X POST  -H "Authorization: Token 66e84d2dd71ecb992c9baa331c72eca58f239909"
 -H "Content-Type: application/json"
 -d '{"title":"Sanat toplum içindir.", "sources": "Türk Dil Kurumu", "owner": "http://google.com/", "is_published": true}'
 http://arguman.org/api/v1/arguments/
 
 Response (201 Created)
 {
 "id":5,
 "user":{
 "id":1,
 "username":"bahattincinic",
 "absolute_url":"/api/v1/users/bahattincinic/",
 "avatar":"https://secure.gravatar.com/avatar/c1184fefac22e49bbf59e3775ef6e9dd.jpg?s=80&r=g&d=mm"
 },
 "title":"Sanat toplum i\u00e7indir.",
 "slug":"sanat-toplum-icindir",
 "description":null,
 "owner":"http://google.com/",
 "sources":"Türk Dil Kurumu",
 "premises":[
 
 ],
 "date_creation":"20-02-2015 12:02",
 "absolute_url":"/api/v1/arguments/5/",
 "report_count":0,
 "is_featured":false,
 "is_published":true
 }
 */


+ (void)postArgumentWithTitle:(NSString *)title published:(BOOL)published completion:(void (^)(Argument *argument, NSError *error))completionBlock;
+ (void)postArgumentWithTitle:(NSString *)title published:(BOOL)published sources:(NSString *)sources owner:(NSString *)owner completion:(void (^)(Argument *argument, NSError *error))completionBlock;

/*
 curl -X PUT  -H "Authorization: Token 66e84d2dd71ecb992c9baa331c72eca58f239909"
 -H "Content-Type: application/json"
 -d '{"title":"Sanat toplum içindir.", "sources": "Türk Dil Kurumu", "owner": "http://google.com/", "is_published": true}'
 http://arguman.org/api/v1/arguments/9/
 response : same
 */

- (void)saveWithCompletion:(void (^)(Argument *argument, NSError *error))completionBlock;


@end
