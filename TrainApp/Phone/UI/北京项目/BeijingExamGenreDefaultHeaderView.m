//
//  BeijingExamGenreDefaultHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingExamGenreDefaultHeaderView.h"
@interface BeijingExamGenreDefaultHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *explainButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) BeijingExamGenreDefaultButtonBlock buttonBlock;
@end
@implementation BeijingExamGenreDefaultHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - setupUI {
- (void)setupUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.titleLabel.text = @"课程案例";
    [self.contentView addSubview:self.titleLabel];
    
    self.explainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.explainButton setImage:[UIImage imageNamed:@"解释说明图标正常态"]
                        forState:UIControlStateNormal];
    [self.explainButton setImage:[UIImage imageNamed:@"解释说明图标点击态"]
                        forState:UIControlStateHighlighted];
    [self.explainButton addTarget:self action:@selector(explainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.explainButton];

    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e7e8ec"];
    [self.contentView addSubview:self.lineView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.explainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(7.0f);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.size.mas_offset(CGSizeMake(19.0f, 19.0f));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(1.0f);
    }];
}

#pragma mark - buttonAction
- (void)explainButtonAction:(UIButton *)sender {
    BLOCK_EXEC(self.buttonBlock,sender);
}

- (void)setBeijingExamGenreDefaultButtonBlock:(BeijingExamGenreDefaultButtonBlock)block {
    self.buttonBlock = block;
}
@end
