//
//  LSTCollectionFilterFooterView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/9/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LSTCollectionFilterFooterView.h"
@interface LSTCollectionFilterFooterView ()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) UIButton *confirmButton;
@end
@implementation LSTCollectionFilterFooterView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self seupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleButton setTitleColor:[UIColor colorWithHexString:@"334466"] forState:UIControlStateNormal];
    [self.cancleButton setTitleColor:[UIColor colorWithHexString:@"334466"] forState:UIControlStateHighlighted];
    [self.cancleButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"ffffff"]] forState:UIControlStateNormal];
    [self.cancleButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]] forState:UIControlStateHighlighted];
    self.cancleButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    WEAK_SELF
    [[self.cancleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.courseFilterCompleteBlock,YES);
    }];
    [self addSubview:self.cancleButton];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"334466"] forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"334466"] forState:UIControlStateHighlighted];
    [self.confirmButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"ffffff"]] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]] forState:UIControlStateHighlighted];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    
    [[self.confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.courseFilterCompleteBlock,NO);
    }];
    [self addSubview:self.confirmButton];
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self addSubview:self.lineView];
}
- (void)seupLayout {
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(-15.0f);
        make.right.equalTo(self.mas_right).offset(15.0f);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_width).multipliedBy(1.0f/2.0f);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self.mas_width).multipliedBy(1.0f/2.0f);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}
@end
