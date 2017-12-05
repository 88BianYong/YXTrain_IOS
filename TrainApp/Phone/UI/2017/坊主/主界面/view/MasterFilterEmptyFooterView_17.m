//
//  MasterFilterEmptyFooterView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/30.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterFilterEmptyFooterView_17.h"
@interface MasterFilterEmptyFooterView_17 ()
@property (nonatomic, strong) UILabel *titleLabel;
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
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.containerView = [[UIView alloc] init];
    [self addSubview:self.containerView];
    self.imageView = [[UIImageView alloc]init];
    self.imageView.image = [UIImage imageNamed:@"数据为空"];
    [self.containerView addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = @"数据为空";
    [self.containerView addSubview:self.titleLabel];
}
- (void)setupLayout {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerX.equalTo(self.containerView.mas_centerX);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.top.equalTo(self.imageView.mas_bottom).offset(14.0f);
        make.bottom.equalTo(self.containerView.mas_bottom);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(10.0f);
        make.size.mas_offset(CGSizeMake(80 + 14 + 14, 80 + 14 + 14));
    }];
}
@end
