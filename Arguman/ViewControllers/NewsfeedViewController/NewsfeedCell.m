//
//  NewsfeedCell.m
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 07/06/16.
//  Copyright © 2016 cekisakurek. All rights reserved.
//

#import "NewsfeedCell.h"

@interface NewsfeedCell ()

@property (strong) UIView *topContainerView;
@property (strong) UIImageView *avatarImageView;
@property (strong) UILabel *usernameLabel;
@property (strong) UILabel *timeLabel;

@property (strong) UILabel *premiseTextLabel;
@end


@implementation NewsfeedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {

        self.backgroundColor = [UIColor colorWithWhite:246.0/255.0 alpha:1];

        self.topContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        self.topContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.topContainerView];

        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.avatarImageView.layer.masksToBounds = YES;
        self.avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.topContainerView addSubview:self.avatarImageView];

        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.usernameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.topContainerView addSubview:self.usernameLabel];

        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.topContainerView addSubview:self.timeLabel];


        self.premiseTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.premiseTextLabel.numberOfLines = 0;
        self.premiseTextLabel.textColor = [UIColor colorWithWhite:70.0/255.0 alpha:1];
        self.premiseTextLabel.preferredMaxLayoutWidth = 320;
        self.premiseTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.premiseTextLabel];


        NSMutableArray *constraints = [NSMutableArray array];

        NSDictionary *views = NSDictionaryOfVariableBindings(_avatarImageView,_usernameLabel,_timeLabel,_premiseTextLabel,_topContainerView);

        [constraints addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_avatarImageView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:_avatarImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40]];

        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(5)-[_avatarImageView]-(10)-[_usernameLabel]-(>=1)-[_timeLabel]-|" options:0 metrics:nil views:views]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_avatarImageView]-|" options:0 metrics:nil views:views]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_usernameLabel]|" options:0 metrics:nil views:views]];

        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_timeLabel]|" options:0 metrics:nil views:views]];




        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topContainerView][_premiseTextLabel]-|" options:0 metrics:nil views:views]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topContainerView]|" options:0 metrics:nil views:views]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_premiseTextLabel]-|" options:0 metrics:nil views:views]];
        
        [NSLayoutConstraint activateConstraints:constraints];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutIfNeeded];
}


- (void)setItem:(NewsfeedItem*)item
{

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = 20.f;
    paragraphStyle.headIndent = 20.f;
    paragraphStyle.paragraphSpacingBefore = 10.f;


    if (item.newsType == NewsTypeNewArgument)
    {
        //created an argument:
        NSMutableAttributedString *actionNameString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"created an argument:", nil)];
        NSMutableAttributedString *breakString = [[NSMutableAttributedString alloc] initWithString:@"\n"];
        [actionNameString appendAttributedString:breakString];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:item.object.text];
        [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
        [actionNameString appendAttributedString:text];
        self.premiseTextLabel.attributedText = actionNameString;
    }
    else if (item.newsType == NewsTypeNewPremise)
    {
        NSMutableAttributedString *argumentTitleString = [[NSMutableAttributedString alloc] initWithString:item.object.contention.title];
        [argumentTitleString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:70.0/255.0 alpha:1] range:NSMakeRange(0, argumentTitleString.length)];

        NSMutableAttributedString *breakString = [[NSMutableAttributedString alloc] initWithString:@"\n"];
        [argumentTitleString appendAttributedString:breakString];

        NSMutableAttributedString *premiseString = [[NSMutableAttributedString alloc] initWithString:item.object.text];
        [premiseString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, premiseString.length)];

        switch (item.object.type) {
            case PremiseTypeBut:
                [premiseString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:142.0/255.0 alpha:1] range:NSMakeRange(0, premiseString.length)];

                break;
            case PremiseTypeBecause:
                [premiseString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:123.0/255.0 green:195.0/255.0 blue:112.0/255.0 alpha:1] range:NSMakeRange(0, premiseString.length)];
                break;
            case PremiseTypeHowever:

                [premiseString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:180.0/255.0 blue:110.0/255.0 alpha:1] range:NSMakeRange(0, premiseString.length)];
                break;
            default:
                break;
        }
        [argumentTitleString appendAttributedString:premiseString];
        self.premiseTextLabel.attributedText = argumentTitleString;
    }
    else

    {   NSString *actionNameString = [NSString stringWithFormat:NSLocalizedString(@"Reported %@ for a premise", nil),item.object.fallacyType];
        NSMutableAttributedString *fallacyTypeString = [[NSMutableAttributedString alloc] initWithString:actionNameString];

        NSMutableAttributedString *breakString = [[NSMutableAttributedString alloc] initWithString:@"\n"];
        [fallacyTypeString appendAttributedString:breakString];

        NSMutableAttributedString *reasonString = [[NSMutableAttributedString alloc] initWithString:item.object.text];
        [reasonString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, reasonString.length)];
        [fallacyTypeString appendAttributedString:reasonString];
        self.premiseTextLabel.attributedText = fallacyTypeString;
    }


    if (!item.sender.avatarURL)
    {
        self.avatarImageView.image = [UIImage imageNamed:@"noavatar.jpg"];
    }
    self.usernameLabel.text = item.sender.username;
    self.timeLabel.text = [NSString stringWithFormat:@"%@",item.dateCreated];
}

@end
