//
//  Contention.h
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 07/06/16.
//  Copyright © 2016 cekisakurek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contention : NSObject

@property (readonly, copy) NSString *owner;
@property (readonly, copy) NSString *title;
@property (readonly, copy) NSString *uri;
@property (readonly, copy) NSString *language;
@property (readonly, copy) NSNumber *ID;

- (instancetype)initWithJSONResponse:(NSDictionary *)response;

@end
