//
//  Premise.h
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 06/07/15.
//  Copyright (c) 2015 cekisakurek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contention.h"
#import "User.h"

@class Fallacy;
typedef enum : NSUInteger {
    PremiseTypeBut = 0,
    PremiseTypeBecause = 1,
    PremiseTypeHowever = 2

} PremiseType;

NS_ASSUME_NONNULL_BEGIN

@interface PremiseSupportersController : NSObject

@property (readonly, copy) NSMutableArray *results;
@property (readonly, strong) NSURL *next;
@property (readonly, strong) NSURL *previous;
@property (readonly, assign) NSUInteger count;

- (void)getSupportersWithArgumentID:(NSString *)argID premiseID:(NSString *)premiseID WithCompletion:(void (^)(PremiseSupportersController *controller, NSError * _Nullable error))completionBlock;

@end


@interface Premise : NSObject

@property (readonly, strong) Contention *contention;
@property (readonly, copy) NSString *language;
@property (readonly, assign) PremiseType type;
@property (readonly, copy) NSString *relatedArgument;
@property (readonly, copy) NSString *sources;
@property (readonly, copy) NSString *text;
@property (readonly, copy) NSString *premiseClass;
@property (readonly, strong) NSNumber *ID;
@property (readonly, strong) User *user;

@property (readonly, strong) NSNumber *parentID;
@property (readonly ,copy) NSString *absoluteURL;
@property (readonly, strong) NSDate *creationDate;
@property (readonly, copy) NSArray *supporters;

- (instancetype)initWithJSONResponse:(NSDictionary *)response;

//adding premise to premise
- (void)postPremiseWithType:(PremiseType)type text:(NSString *)text sources:(nullable NSString *)sources completion:(void (^)(Premise * _Nullable premise, NSError * _Nullable error))completionBlock;

- (void)putPremiseWithType:(PremiseType)type text:(NSString *)text parent:(NSString *)parent sources:(NSString *)sources completion:(void (^)(Premise * _Nullable premise, NSError * _Nullable error))completionBlock;

- (void)deletePremiseWithCompletion:(void (^)(NSError * _Nullable error))completionBlock;

- (void)reportWithFallacy:(Fallacy *)fallacy completion:(void (^)(NSError * _Nullable error))completionBlock;

- (void)putSupportWithCompletion:(void (^)(NSError * _Nullable error))completionBlock;
- (void)deleteSupportWithCompletion:(void (^)(NSError * _Nullable error))completionBlock;


@end
NS_ASSUME_NONNULL_END
