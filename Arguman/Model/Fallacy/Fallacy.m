//
//  Fallacy.m
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 08/06/16.
//  Copyright © 2016 cekisakurek. All rights reserved.
//

#import "Fallacy.h"
#import "Constants.h"
@implementation Fallacy

- (instancetype)initWithJSONResponse:(NSDictionary *)response
{
    self = [super init];
    if (self)
    {
        _reason = TRY_CAST(response[@"reason"],NSString);
        _fallacyType = TRY_CAST(response[@"fallacy_type"],NSString);
        _premise = [[Premise alloc] initWithJSONResponse:TRY_CAST(response[@"premise"], NSDictionary)];
        _contention = [[Contention alloc] initWithJSONResponse:TRY_CAST(response[@"contention"], NSDictionary)];

    }
    return self;
}

//- (void)updateFromJSONResponse:(NSDictionary *)response
//{
//    _ID = TRY_CAST(response[@"id"], NSNumber);
//    _user = [User userWithJSONResponse:TRY_CAST(response[@"user"], NSDictionary)];
//    _text = TRY_CAST(response[@"text"], NSString);
//    _sources = TRY_CAST(response[@"sources"], NSString);
//    _parentID = TRY_CAST(response[@"parent"], NSNumber);
//    _absoluteURL = TRY_CAST(response[@"parent"], NSString);
//    _type = [TRY_CAST(response[@"premise_type"], NSNumber) integerValue];
//    _creationDate = formatDateFromString(TRY_CAST(response[@"date_creation"], NSString));
//
//
//
//    _contention = [[Contention alloc] initWithJSONResponse:response[@"contention"]];
//    _language = TRY_CAST(response[@"language"], NSString);
//    _relatedArgument = TRY_CAST(response[@"related_argument"], NSString);
//    _premiseClass = TRY_CAST(response[@"premise_class"], NSString);
//}


+ (NSArray *)allFallacies
{
    return @[@"Begging The Question",
            @"Irrelevant Conclusion",
            @"Fallacy of Irrelevant Purpose",
             @"Fallacy of Red Herring",
             @"Argument Against the Man",
             @"Poisoning The Well",
             @"Fallacy Of The Beard",
             @"Fallacy of Slippery Slope",
             @"Fallacy of False Cause",
             @"Fallacy of “Previous This”",
             @"Joint Effect",
             @"Wrong Direction",
             @"False Analogy",
             @"Slothful Induction",
             @"Appeal to Belief",
             @"Pragmatic Fallacy",
             @"Fallacy Of “Is” To “Ought”",
             @"Argument From Force",
             @"Argument To Pity",
             @"Prejudicial Language",
             @"Fallacy Of Special Pleading",
             @"Appeal To Authority"];
}

@end
