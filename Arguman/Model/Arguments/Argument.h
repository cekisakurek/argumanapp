//
//  Argument.h
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 06/07/15.
//  Copyright (c) 2015 cekisakurek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Premise.h"
@class User;

NS_ASSUME_NONNULL_BEGIN
@interface ArgumentsController : NSObject

@property (readonly, copy) NSMutableArray *results;
@property (readonly, strong) NSURL *next;
@property (readonly, strong) NSURL *previous;
@property (readonly, assign) NSUInteger count;

+ (void)getArgumentsWithCompletion:(void (^)(ArgumentsController * _Nullable argumentsController, NSError * _Nullable error))completionBlock;
+ (void)getNewArgumentsWithCompletion:(void (^)(ArgumentsController * _Nullable argumentsController, NSError * _Nullable error))completionBlock;
+ (void)getFeaturedArgumentsWithCompletion:(void (^)(ArgumentsController * _Nullable argumentsController, NSError * _Nullable error))completionBlock;
+ (void)searchArguments:(NSString *)keyword completion:(void (^)(ArgumentsController * _Nullable argumentsController, NSError * _Nullable error))completionBlock;

@end


@interface Argument : NSObject


@property (readonly, copy) NSNumber *ID;
@property (readonly,copy) User *user;
@property (readonly,copy) NSString *title;
@property (readonly,copy) NSString *slug;
@property (readonly,copy) NSString *argumentDescription;
@property (readonly,copy) NSString *sources;
@property (readonly,copy) NSArray *premises;
@property (readonly,copy) NSDate *dateCreated;
@property (readonly,copy) NSURL *absoluteURL;
@property (readonly,copy) NSNumber *reportCount;
@property (readonly,assign,getter = isFeatured) BOOL featured;
@property (readonly,assign,getter = isPublished) BOOL published;
@property (readonly,copy) NSString *owner;


- (NSArray *)topLayerPremises;


- (NSNumber *)becauseCount;
- (NSNumber *)butCount;
- (NSNumber *)howeverCount;

- (NSNumber *)supportRate;

// creates a new argument
+ (void)postArgumentWithTitle:(NSString *)title sources:(nullable NSString *)sources owner:(nullable NSString *)owner publish:(BOOL)publish completion:(nullable void (^)(Argument * _Nullable argument, NSError * _Nullable error))completionBlock;


// updates/edits argument
- (void)putArgumentWithTitle:(NSString *)title sources:(nullable NSString *)sources owner:(nullable NSString *)owner publish:(BOOL)publish completion:(void (^)(Argument * _Nullable argument, NSError * _Nullable error))completionBlock;

- (void)deleteArgumentWithCompletion:(void (^)(NSError * _Nullable error))completionBlock;


- (void)postPremiseWithType:(PremiseType)type text:(NSString *)text sources:(nullable NSString *)sources completion:(void (^)(Premise * _Nullable premise, NSError * _Nullable error))completionBlock;


+ (void)getArgumentWithID:(NSString *)ID completion:(void (^)(Argument * _Nullable argument, NSError * _Nullable error))completionBlock;


- (void)getPremisesWithCompletion:(void (^)(NSArray *premises, NSError *error))completionBlock;


@end
NS_ASSUME_NONNULL_END