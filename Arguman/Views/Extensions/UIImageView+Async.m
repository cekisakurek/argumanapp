//
//  UIImageView+Async.m
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 08/06/16.
//  Copyright © 2016 cekisakurek. All rights reserved.
//

#import "UIImageView+Async.h"

@implementation UIImageView (Async)

- (void)loadFromURL:(NSURL *)url
{
    __weak UIImageView *weakRef = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:imageData];
            weakRef.image = image;

        });
    });
}

@end
