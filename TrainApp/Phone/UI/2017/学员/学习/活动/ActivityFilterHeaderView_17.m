//
//  ActivityFilterHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ActivityFilterHeaderView_17.h"
@interface ActivityFilterHeaderView_17 ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *seperatorView;
@end
@implementation ActivityFilterHeaderView_17
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.seperatorView = [[UIView alloc]init];
    self.seperatorView.backgroundColor = [UIColor colorWithHexString:@"e8f0fe"];
    [self addSubview:self.seperatorView];
    [self.seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSeperatorHidden:(BOOL)seperatorHidden {
    _seperatorHidden = seperatorHidden;
    self.seperatorView.hidden = seperatorHidden;
}

@end
