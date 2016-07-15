//
//  YXEmptyView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/7/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXEmptyView.h"

@interface YXEmptyView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
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
    self.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.imageView = [[UIImageView alloc]init];
    //self.imageView.backgroundColor = [UIColor redColor];
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-70);
        make.size.mas_equalTo(CGSizeMake(202, 202));
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = @"无内容";
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(5);
    }];
    self.subTitleLabel = [[UILabel alloc]init];
    self.subTitleLabel.font = [UIFont systemFontOfSize:12];
    self.subTitleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subTitleLabel.numberOfLines = 0;
    [self addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(10);
    }];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle{
    _subTitle = subTitle;
    self.subTitleLabel.text = subTitle;
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:imageName];
}

@end
