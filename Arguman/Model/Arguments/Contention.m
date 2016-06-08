//
//  Contention.m
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 07/06/16.
//  Copyright © 2016 cekisakurek. All rights reserved.
//

#import "Contention.h"
#import "Constants.h"
@implementation Contention

- (instancetype)initWithJSONResponse:(NSDictionary *)response
{
    self = [super init];
    if (self)
    {

        _owner = TRY_CAST(response[@"owner"], NSString);
        _uri = TRY_CAST(response[@"uri"], NSString);
        _title = TRY_CAST(response[@"title"], NSString);
        _language = TRY_CAST(response[@"language"], NSString);
        _ID = TRY_CAST(response[@"id"], NSNumber);
    }
    return self;
}

@end
