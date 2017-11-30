//
//  MasterFilterEmptyFooterView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterFilterEmptyFooterView_17.h"
@interface MasterFilterEmptyFooterView_17 ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *containerView;

@end
@implementation MasterFilterEmptyFooterView_17
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.containerView = [[UIView alloc] init];
    [self addSubview:self.containerView];
    self.imageView = [[UIImageView alloc]init];
    self.imageView.image = [UIImage imageNamed:@"无内容"];
    [self.containerView addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = @"无内容";
    [self.containerView addSubview:self.titleLabel];
}
- (void)setupLayout {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(202, 202));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.imageView.mas_bottom).mas_offset(2);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top);
    }];
}
@end
