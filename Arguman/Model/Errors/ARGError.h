//
//  ARGError.h
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 08/06/16.
//  Copyright © 2016 cekisakurek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARGError : NSError

+ (ARGError *)notAuthenticatedError;

@end
