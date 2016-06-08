//
//  ARGError.m
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 08/06/16.
//  Copyright © 2016 cekisakurek. All rights reserved.
//

#import "ARGError.h"

#define ERROR_DOMAIN @"com.cekisakurek.arguman"

@implementation ARGError

+ (ARGError *)notAuthenticatedError
{
    return [ARGError errorWithDomain:ERROR_DOMAIN code:-1 userInfo:@{NSLocalizedDescriptionKey:@"Not Authenticated"}];

}

@end
