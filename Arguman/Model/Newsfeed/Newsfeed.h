//
//  Newsfeed.h
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 06/07/15.
//  Copyright (c) 2015 cekisakurek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contention.h"
#import "Premise.h"
@class User;


typedef enum : NSInteger {
    NewsTypeNewArgument = 0,
    NewsTypeNewPremise = 1,
    NewsTypeFallacy = 2
} NewsType;
//
//@interface NewsfeedRelatedObject : NSObject
//@property (readonly, copy) NSString *owner;
//@property (readonly, copy) NSString *uri;
//@property (readonly, copy) NSString *text;
//@property (readonly,assign) PremiseType type;
//@property (readonly,strong) Contention *contention;
//@property (readonly, copy) NSString *reason;
//@property (readonly, copy) NSString *fallacyType;
//@property (readonly,strong) Premise *premise;
//@property (readonly,readonly) NSNumber *ID;
//@end

@interface NewsfeedItem : NSObject
@property (readonly, copy) NSString *ID;
@property (readonly ,assign) NewsType newsType;
@property (readonly, strong) NSDate *dateCreated;
@property (readonly,strong) User *sender;
@property (readonly,copy) NSArray *recipients;
@property (readonly,strong) id object;

@end



@interface NewsfeedController : NSObject
@property (readonly, copy) NSMutableArray *results;
@property (readonly, strong) NSURL *next;
@property (readonly, strong) NSURL *previous;

+ (void)getFeedWithCompletion:(void (^)(NewsfeedController *newsfeedController, NSError *error))completionBlock;

- (void)getNextWithCompletion:(void (^)(NewsfeedController *newsfeedController, NSError *error))completionBlock;
- (void)getPreviousWithCompletion:(void (^)(NewsfeedController *newsfeedController, NSError *error))completionBlock;

@end



