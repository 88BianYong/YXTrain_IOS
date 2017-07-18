//
//  CourseFilterFooterView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseFilterFooterView_17.h"
@interface CourseFilterFooterView_17 ()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) UIButton *confirmButton;
@end
@implementation CourseFilterFooterView_17
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self seupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self addSubview:self.lineView];
    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancleButton.layer.cornerRadius = YXTrainCornerRadii;
    self.cancleButton.clipsToBounds = YES;
    [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleButton setTitleColor:[UIColor colorWithHexString:@"a1a7ae"] forState:UIControlStateNormal];
    [self.cancleButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
    [self.cancleButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f3f7fa"]] forState:UIControlStateNormal];
    [self.cancleButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateHighlighted];
    self.cancleButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:self.cancleButton];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    self.confirmButton.layer.cornerRadius = YXTrainCornerRadii;
    self.confirmButton.clipsToBounds = YES;
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"a1a7ae"] forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
    [self.confirmButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f3f7fa"]] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateHighlighted];
        self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:self.confirmButton];
    
}
- (void)seupLayout {
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
    
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_centerX).offset(-30.0f);
        make.size.mas_offset(CGSizeMake(75.0f, 29.0f));
        make.top.equalTo(self.mas_top).offset(20.0f);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).offset(30.0f);
        make.size.mas_offset(CGSizeMake(75.0f, 29.0f));
        make.top.equalTo(self.mas_top).offset(20.0f);
    }];
    
}
@end
