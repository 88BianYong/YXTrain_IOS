//
//  ActivityCommentInputView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

//NSFoundationVersionNumber_iOS_7_0
#import "ActivityCommentInputView.h"
#import "InputTextView.h"
@interface ActivityCommentInputView()
@property (nonatomic, strong) InputTextView *textView;
@end

@implementation ActivityCommentInputView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setupUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.textView = [[InputTextView alloc] init];
    self.textView.placeHolder = @"开始评论";
    self.textView.backgroundColor = [UIColor blueColor];
    WEAK_SELF
    [self.textView setInputTextViewHeight:^(CGFloat height) {
        STRONG_SELF
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(height + 14.0f);
        }];
    }];
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10.0f);
        make.width.equalTo(self.mas_width).offset(-70.0f);
        make.top.equalTo(self.mas_top).offset(7.0f);
        make.height.mas_offset(36.0f);
        make.bottom.equalTo(self.mas_bottom).offset(-7.0f);
    }];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    if (endFrame.origin.y != kScreenHeight) {
        [UIView animateWithDuration:curve animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.superview.mas_bottom).offset(-endFrame.size.height);
            }];
        }];
    }else{
        [UIView animateWithDuration:curve animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.superview.mas_bottom);
            }];
        }];
    }
    [self.superview layoutIfNeeded];
}

@end
