//
//  YXFilterButton.m
//  TrainApp
//
//  Created by 李五民 on 16/6/28.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFilterButton.h"

@interface YXFilterButton ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *btnImageView;

@end

@implementation YXFilterButton

- (instancetype)init{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.contentView = [[UIView alloc] init];
    self.contentView.userInteractionEnabled = NO;
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];
    
    self.btnLabel = [[UILabel alloc] init];
    self.btnLabel.font = [UIFont systemFontOfSize:13];
    self.btnLabel.textColor = [UIColor colorWithHexString:@"505f84"];
    self.btnLabel.userInteractionEnabled = NO;
    [self.contentView addSubview:self.btnLabel];
    
    self.btnImageView = [[UIImageView alloc] init];
    self.btnImageView.userInteractionEnabled = NO;
    [self.contentView addSubview:self.btnImageView];
    
    [self.btnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    [self.btnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.left.equalTo(self.btnLabel.mas_right).offset(2);
    }];
}

- (void)setButtonTitle:(NSString *)title withMaxWidth:(float)width {
    CGRect rect = [title boundingRectWithSize:CGSizeMake(width, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:NULL];
    if (rect.size.width > width - 4 * 2 - 15 - 2) {
        [self.btnLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(width - 25, 45));
        }];
    } else {
        [self.btnLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(0);
        }];
    }
    self.btnLabel.text = title;
}

- (void)btnTitleColor:(UIColor *)color {
    self.btnLabel.textColor = color;
}

- (void)changeButtonImageExpand:(BOOL)isExpand {
    if (isExpand) {
        self.btnImageView.image = [UIImage imageNamed:@"筛选排序学科收起icon"];
    } else {
        self.btnImageView.image = [UIImage imageNamed:@"筛选排序学科i展开con"];
    }
}


@end

