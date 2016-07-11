//
//  YXEmptyView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/7/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXEmptyView.h"

@interface YXEmptyView()
@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation YXEmptyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    self.msgLabel = [[UILabel alloc]init];
    self.msgLabel.numberOfLines = 0;
    self.msgLabel.text = @"内容为空";
    [self addSubview:self.msgLabel];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    self.imageView = [[UIImageView alloc]init];
    self.imageView.backgroundColor = [UIColor redColor];
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.msgLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
}

- (void)setMessage:(NSString *)message{
    _message = message;
    self.msgLabel.text = message;
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:imageName];
}

@end
