//
//  ArgumentCell.m
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 07/06/16.
//  Copyright © 2016 cekisakurek. All rights reserved.
//

#import "ArgumentCell.h"

@interface ArgumentCell ()

@property (strong) UIView *topContainerView;
@property (strong) UIImageView *avatarImageView;
@property (strong) UILabel *usernameLabel;
@property (strong) UILabel *timeLabel;

@property (strong) UILabel *premiseTypeLabel;
@property (strong) UILabel *premiseTextLabel;

@end


@implementation ArgumentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {

        self.topContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        self.topContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.topContainerView];

        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.topContainerView addSubview:self.avatarImageView];

        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.usernameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.topContainerView addSubview:self.usernameLabel];

        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.topContainerView addSubview:self.timeLabel];

        self.premiseTypeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.premiseTypeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.topContainerView addSubview:self.premiseTypeLabel];


        self.premiseTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.premiseTextLabel.numberOfLines = 0;
        self.premiseTextLabel.textColor = [UIColor colorWithWhite:70.0/255.0 alpha:1];
        self.premiseTextLabel.preferredMaxLayoutWidth = 320;
        self.premiseTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.premiseTextLabel];


        NSMutableArray *constraints = [NSMutableArray array];

        NSDictionary *views = NSDictionaryOfVariableBindings(_avatarImageView,_usernameLabel,_timeLabel,_premiseTextLabel,_premiseTypeLabel,_topContainerView);

        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_avatarImageView][_usernameLabel][_premiseTypeLabel][_timeLabel]-|" options:0 metrics:nil views:views]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_avatarImageView]|" options:0 metrics:nil views:views]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_usernameLabel]|" options:0 metrics:nil views:views]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_premiseTypeLabel]|" options:0 metrics:nil views:views]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_timeLabel]|" options:0 metrics:nil views:views]];




        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_topContainerView][_premiseTextLabel]-|" options:0 metrics:nil views:views]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_topContainerView]-|" options:0 metrics:nil views:views]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_premiseTextLabel]-|" options:0 metrics:nil views:views]];

        [NSLayoutConstraint activateConstraints:constraints];
    }
    return self;
}

- (void)setPremise:(Premise *)premise
{
    self.usernameLabel.text = premise.user.username;
    self.premiseTextLabel.text = premise.text;
    switch (premise.type) {
        case PremiseTypeBut:
            self.premiseTypeLabel.text = NSLocalizedString(@"But", nil);
            self.premiseTextLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:216.0/255.0 blue:213.0/255.0 alpha:1];
            break;
        case PremiseTypeBecause:
            self.premiseTypeLabel.text = NSLocalizedString(@"Because", nil);
            self.premiseTextLabel.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:255.0/255.0 blue:179.0/255.0 alpha:1];
            break;
        case PremiseTypeHowever:
            self.premiseTypeLabel.text = NSLocalizedString(@"However", nil);
            self.premiseTextLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:241.0/255.0 blue:164.0/255.0 alpha:1];
            break;
        default:
            break;
    }
}

@end
