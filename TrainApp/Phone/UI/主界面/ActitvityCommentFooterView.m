//
//  ActitvityCommentFooterView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActitvityCommentFooterView.h"
@interface ActitvityCommentFooterView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *replyButton;
@end
@implementation ActitvityCommentFooterView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(56.0f, 0.0f, kScreenWidth - 56.0f - 10.0f, 44.0f)];
    self.bgView.backgroundColor = [UIColor colorWithHexString:@"f2f4f7"];
    [self.contentView addSubview:self.bgView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(YXTrainCornerRadii, YXTrainCornerRadii)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskPath.CGPath;
    self.bgView.layer.mask = maskLayer;
    self.replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.replyButton setTitle:@"查看全部回复" forState:UIControlStateNormal];
    [self.replyButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
    self.replyButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.replyButton.frame = CGRectMake(71.0f, 0.0f, 90.0f, 14.0f);
    self.replyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.contentView addSubview:self.replyButton];
}


#pragma mark - button Action
- (void)replyButtonAction:(UIButton *)sender {
    
}
@end
