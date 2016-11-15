//
//  ActivityStepCollectionCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityStepCollectionCell.h"
@interface ActivityStepCollectionCell ()
@property (nonatomic, strong) UIImageView *stepImageView;
@property (nonatomic, strong) UILabel *stepNameLabel;
@end
@implementation ActivityStepCollectionCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI{
    self.stepImageView = [[UIImageView alloc] init];
    self.stepImageView.backgroundColor = [UIColor redColor];
    self.stepImageView.layer.cornerRadius = 30.0f;
    self.stepImageView.layer.masksToBounds = YES;
    self.stepImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.stepImageView];
    
    self.stepNameLabel = [[UILabel alloc] init];
    self.stepNameLabel.font = [UIFont systemFontOfSize:12.0f];
    self.stepNameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.stepNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.stepNameLabel];
}

- (void)setupLayout{
    [self.stepImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(60.0f);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(self.stepNameLabel.mas_top).offset(-7.0f);
    }];
    
    [self.stepNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(10.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
        make.height.offset(12.0f);
    }];
}

#pragma mark - reloadData
//- (void)setTools:(ActivityStepListRequestItem_Body_Steps_Tools *)tools{
//    _tools = tools;
//    self.stepNameLabel.text = _tools.title;
//    [self.stepImageView sd_setImageWithURL:[NSURL URLWithString:tools.tooltype] placeholderImage:[UIImage imageNamed:@""]];
//}

@end
