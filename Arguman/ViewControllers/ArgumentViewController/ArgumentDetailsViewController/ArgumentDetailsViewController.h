//
//  ArgumentDetailsViewController.h
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 09/06/16.
//  Copyright © 2016 cekisakurek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Argument;
@interface ArgumentDetailsViewController : UIViewController

@property (strong,nonatomic) Argument *argument;

- (instancetype)initWithArgument:(Argument *)argument;

@end
