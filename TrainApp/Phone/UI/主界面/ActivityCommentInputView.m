//
//  ActivityCommentInputView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

//NSFoundationVersionNumber_iOS_7_0
#import "ActivityCommentInputView.h"
@interface ActivityCommentInputView()
@property (nonatomic, strong) UILabel *textNumberLabel;
@property (nonatomic, strong) UIButton *sendButton;
@end

@implementation ActivityCommentInputView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setupUI];
        [self setupLayout];
        self.backgroundColor = [UIColor colorWithHexString:@"f2f4f7"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.textView = [[SAMTextView alloc] init];
    self.textView.placeholder = @"开始评论";
    self.textView.textContainerInset = UIEdgeInsetsMake(15.0f, 15.0f, 0.0f, 15.0f);
    self.textView.layer.cornerRadius = YXTrainCornerRadii;
    self.textView.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    self.textView.layer.borderColor = [UIColor colorWithHexString:@"d0d2d5"].CGColor;
    [self addSubview:self.textView];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f4f7"]] forState:UIControlStateDisabled];
    [self.sendButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor colorWithHexString:@"a1a7ae"] forState:UIControlStateDisabled];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.sendButton.layer.cornerRadius = YXTrainCornerRadii;
    self.sendButton.layer.borderWidth = 1.0f;
    self.sendButton.layer.borderColor = [UIColor colorWithHexString:@"b9c0c7"].CGColor;
    self.sendButton.enabled = NO;
    [self addSubview:self.sendButton];
    
    self.textNumberLabel = [[UILabel alloc] init];
    self.textNumberLabel.font = [UIFont systemFontOfSize:14.0f];
    self.textNumberLabel.text = @"98 / 200";
    [self addSubview:self.textNumberLabel];
}
- (void)setupLayout {
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.top.equalTo(self.mas_top).offset(15.0f);
        make.height.mas_offset(80.0f);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(74.0f, 24.0f));
        make.right.equalTo(self.textView.mas_right);
        make.top.equalTo(self.textView.mas_bottom).offset(10.0f);
        make.bottom.equalTo(self.mas_bottom).offset(-11.0f);
    }];
    
    [self.textNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView.mas_left).offset(15.0f);
        make.centerY.equalTo(self.sendButton.mas_centerY);
    }];
    
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    if (endFrame.origin.y != kScreenHeight) {
        self.textView.textAlignment = NSTextAlignmentLeft;
        [UIView animateWithDuration:curve animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.superview.mas_bottom).offset(-endFrame.size.height);
            }];
        }];
    }else{
        self.textView.textAlignment = NSTextAlignmentCenter;
        [UIView animateWithDuration:curve animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.superview.mas_bottom);
            }];
        }];
    }
    [self.superview layoutIfNeeded];
}

@end
