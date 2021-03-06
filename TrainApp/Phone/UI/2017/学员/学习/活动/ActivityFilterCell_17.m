//
//  ActivityFilterCell_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ActivityFilterCell_17.h"
@interface ActivityFilterCell_17 ()
@property (nonatomic, strong) UIButton *itemButton;
@end
@implementation ActivityFilterCell_17
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.itemButton = [[UIButton alloc]init];
    UIImage *normalImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"e8f0fe"]];
    UIImage *selectedImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]];
    [self.itemButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.itemButton setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [self.itemButton setTitleColor:[UIColor colorWithHexString:@"505f84"] forState:UIControlStateNormal];
    [self.itemButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
    self.itemButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.itemButton.layer.cornerRadius = YXTrainCornerRadii;
    self.itemButton.clipsToBounds = YES;
    WEAK_SELF
    [[self.itemButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        if (self.itemButton.selected) {
            return;
        }
        BLOCK_EXEC(self.activityFilterButtonActionBlock);
    }];
    [self.contentView addSubview:self.itemButton];
    [self.itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.itemButton setTitle:title forState:UIControlStateNormal];
}

- (void)setIsCurrent:(BOOL)isCurrent {
    _isCurrent = isCurrent;
    self.itemButton.selected = isCurrent;
}

+ (CGSize)sizeForTitle:(NSString *)title {
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    return CGSizeMake(ceilf(size.width+30), 33);
}

@end
