//
//  YXScoreExpHeaderView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXScoreExpHeaderView.h"
#import "YXScoreNoScoreView.h"

@interface YXScoreExpHeaderView()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) YXScoreNoScoreView *noScoreView;
@end
@implementation YXScoreExpHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:13];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    
    self.scoreLabel = [[UILabel alloc]init];
    self.scoreLabel.font = [UIFont fontWithName:YXFontMetro_DemiBold size:13];
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    self.scoreLabel.textAlignment = NSTextAlignmentRight;
    
    self.noScoreView = [[YXScoreNoScoreView alloc]init];
    
    [self.nameLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"edf1f5"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.nameLabel.text = title;
}

- (void)setScore:(NSString *)score{
    _score = score;
    [self.nameLabel removeFromSuperview];
    [self.scoreLabel removeFromSuperview];
    [self.noScoreView removeFromSuperview];
    if (score.length == 0) {
        [self.contentView addSubview:self.noScoreView];
        [self.noScoreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(2);
        }];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(self.noScoreView.mas_left).mas_offset(-10).priorityHigh();
        }];
    }else{
        [self.contentView addSubview:self.scoreLabel];
        self.scoreLabel.text = score;
        [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(-30.0f);
            make.centerY.mas_equalTo(0.0f);
            make.width.mas_offset(60.0f);
        }];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(self.scoreLabel.mas_left).mas_offset(-10).priorityHigh();
        }];
    }
}

@end
