//
//  ArgumentTableHeaderView.m
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 09/06/16.
//  Copyright © 2016 cekisakurek. All rights reserved.
//

#import "ArgumentTableHeaderView.h"
#import "Argument.h"

@interface ArgumentTableHeaderView ()
@property (strong) UILabel *titleLabel;
@property (strong) UIImageView *avatarImageView;
@property (strong) UILabel *usernameLabel;
@property (strong) UILabel *sourceLabel;
@end


@implementation ArgumentTableHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.numberOfLines = 0;
        [self addSubview:self.titleLabel];

        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.usernameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.usernameLabel];

        self.sourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.sourceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.sourceLabel];

        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.avatarImageView.layer.masksToBounds = YES;
        [self addSubview:self.avatarImageView];

        NSMutableArray *constraints = [NSMutableArray array];
        NSDictionary *views = NSDictionaryOfVariableBindings(_titleLabel,_usernameLabel,_sourceLabel,_avatarImageView);

        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_avatarImageView][_usernameLabel]|" options:0 metrics:nil views:views]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleLabel][_sourceLabel]|" options:0 metrics:nil views:views]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_avatarImageView][_titleLabel]|" options:0 metrics:nil views:views]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_avatarImageView][_sourceLabel]|" options:0 metrics:nil views:views]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_usernameLabel][_titleLabel]|" options:0 metrics:nil views:views]];

        [NSLayoutConstraint activateConstraints:constraints];
    }
    return self;
}

- (void)setArgument:(Argument *)argument
{
    _argument = argument;

    self.titleLabel.text = _argument.title;
    self.usernameLabel.text = _argument.user.username;
    self.sourceLabel.text = [NSString stringWithFormat:@"%@ : %@ ",NSLocalizedString(@"Sources", nil),_argument.sources];
    if (!_argument.user.avatarURL)
    {
        self.avatarImageView.image = [UIImage imageNamed:@"noavatar.jpg"];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
