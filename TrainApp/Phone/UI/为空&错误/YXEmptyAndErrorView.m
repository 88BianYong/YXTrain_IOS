//
//  YXEmptyAndErrorView.m
//  TrainApp
//
//  Created by Lei Cai on 8/18/16.
//  Copyright © 2016 niuzhaowang. All rights reserved.
//

#import "YXEmptyAndErrorView.h"

@interface YXEmptyAndErrorView ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation YXEmptyAndErrorView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self _setupUI];
    }
    return self;
}

- (void)_setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor redColor];
    [self addSubview:self.containerView];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeCenter;
    [self.containerView addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.containerView addSubview:self.titleLabel];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(202, 202));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(2);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}

- (void)updateWithImageNamed:(NSString *)imagename andTitle:(NSString *)title {
    self.imageView.backgroundColor = [UIColor redColor];
    self.titleLabel.text = @"数据错误";
    
    if (!isEmpty(imagename)) {
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.image = [UIImage imageNamed:imagename];
    }
    
    if (!isEmpty(title)) {
        self.titleLabel.text = title;
    }
    
    [self setNeedsLayout];
}

@end
