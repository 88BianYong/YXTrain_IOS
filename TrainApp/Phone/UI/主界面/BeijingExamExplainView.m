//
//  BeijingExamExplainView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/30.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingExamExplainView.h"
@interface BeijingExamExplainView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *explainLabel;
@end


@implementation BeijingExamExplainView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI{
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = YXTrainCornerRadii;
    [self addSubview:self.bgView];
    
    self.explainLabel = [[UILabel alloc] init];
    self.explainLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.explainLabel.font = [UIFont systemFontOfSize:13.0f];
    self.explainLabel.text = @"课程: 17学时  案例: 3学时";
    self.explainLabel.numberOfLines = 0;
    [self.bgView addSubview:self.explainLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)setupLayout {
    [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15.0f);
        make.right.equalTo(self.bgView.mas_right).offset(-15.0f);
        make.top.equalTo(self.bgView.mas_top).offset(15.0f);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-15.0);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
    }];
}

- (void)tapAction{
    [self removeFromSuperview];
}

- (void)setOriginRect:(CGRect)originRect{
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.superview.mas_top).offset(originRect.origin.y - 10.0f);
    }];
}

- (void)showInView:(UIView *)view examExplain:(NSString *)string {
    self.frame = view.bounds;
    self.explainLabel.text = string;
    [view addSubview:self];
}
@end
