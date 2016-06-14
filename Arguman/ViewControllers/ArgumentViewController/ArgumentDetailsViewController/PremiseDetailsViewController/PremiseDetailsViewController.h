//
//  PremiseDetailsViewController.h
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 09/06/16.
//  Copyright © 2016 cekisakurek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Premise.h"

@interface PremiseDetailsViewController : UIViewController

@property (strong,nonatomic) Premise *premise;

- (instancetype)initWithPremise:(Premise *)premise;

@end
