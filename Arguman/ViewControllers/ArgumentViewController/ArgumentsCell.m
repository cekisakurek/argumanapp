//
//  ArgumentCell.m
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 07/06/16.
//  Copyright © 2016 cekisakurek. All rights reserved.
//

#import "ArgumentsCell.h"

@interface ArgumentsCell ()

@property (strong) UILabel *premiseStatsLabel;
@property (strong) UILabel *titleLabel;
@property (strong) UILabel *timeLabel;


@end


@implementation ArgumentsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {

        self.backgroundColor = [UIColor colorWithWhite:246.0/255.0 alpha:1];
        
        self.premiseStatsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.premiseStatsLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.premiseStatsLabel.numberOfLines = 0;
        [self.contentView addSubview:self.premiseStatsLabel];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.preferredMaxLayoutWidth = 260;
        [self.contentView addSubview:self.titleLabel];


        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.timeLabel];



        NSMutableArray *constraints = [NSMutableArray array];

        NSDictionary *views = NSDictionaryOfVariableBindings(_premiseStatsLabel,_titleLabel,_timeLabel);


        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_premiseStatsLabel][_titleLabel]-|" options:0 metrics:nil views:views]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_premiseStatsLabel][_timeLabel]-|" options:0 metrics:nil views:views]];

        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_premiseStatsLabel]-|" options:0 metrics:nil views:views]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_titleLabel][_timeLabel]-|" options:0 metrics:nil views:views]];

        [NSLayoutConstraint activateConstraints:constraints];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setArgument:(Argument *)arg
{

    NSMutableAttributedString *statsString = [[NSMutableAttributedString alloc] init];

    NSMutableAttributedString *becauseString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",arg.becauseCount,NSLocalizedString(@"Because", nil)]];
    [becauseString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:123.0/255.0 green:195.0/255.0 blue:112.0/255.0 alpha:1] range:NSMakeRange(0, becauseString.length)];

    NSMutableAttributedString *butString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",arg.butCount,NSLocalizedString(@"But", nil)]];
    [butString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:142.0/255.0 alpha:1] range:NSMakeRange(0, butString.length)];

    NSMutableAttributedString *howeverString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",arg.howeverCount,NSLocalizedString(@"However", nil)]];
    [howeverString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:180.0/255.0 blue:110.0/255.0 alpha:1] range:NSMakeRange(0, howeverString.length)];


    NSMutableAttributedString *breakString = [[NSMutableAttributedString alloc] initWithString:@"\n"];


    [statsString appendAttributedString:becauseString];
    [statsString appendAttributedString:breakString];
    [statsString appendAttributedString:butString];
    [statsString appendAttributedString:breakString];
    [statsString appendAttributedString:howeverString];

    self.premiseStatsLabel.attributedText = statsString;

    self.titleLabel.text = arg.title;
    self.timeLabel.text = [NSString stringWithFormat:@"%@",arg.dateCreated];
}

@end
