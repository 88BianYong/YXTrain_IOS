//
//  MasterOverallRatingScoreInputView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterOverallRatingScoreInputView_17.h"
@interface MasterOverallRatingScoreInputView_17 ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *lineView;
@end
@implementation MasterOverallRatingScoreInputView_17
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f2f4f7"];
        [self setupUI];
        [self setupLayout];
        WEAK_SELF
        [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]subscribeNext:^(id x) {
            STRONG_SELF
            NSNotification *noti = (NSNotification *)x;
            NSDictionary *dic = noti.userInfo;
            NSValue *keyboardFrameValue = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
            CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
            NSNumber *duration = [dic valueForKey:UIKeyboardAnimationDurationUserInfoKey];
            [UIView animateWithDuration:duration.floatValue animations:^{
                [self mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(-(kScreenHeight - keyboardFrame.origin.y));
                }];
                [self.superview layoutIfNeeded];
            }];
        }];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"d0d2d5"];
    [self addSubview:self.lineView];
    
    self.textField = [[UITextField alloc] init];
    self.textField.textColor = [UIColor colorWithHexString:@"334466"];
    self.textField.placeholder = @"综合评定成绩 (0-100)";
    self.textField.font = [UIFont systemFontOfSize:14.0f];
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.layer.cornerRadius = 16.0f;
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.clipsToBounds = YES;
    self.textField.delegate = self;
    self.textField.layer.borderColor = [UIColor colorWithHexString:@"d0d2d5"].CGColor;
    self.textField.layer.borderWidth = 1.0f;
    [self addSubview:self.textField];
}
- (void)setupLayout {
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.mas_offset(1.0f);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_offset(32.0f);
    }];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if ([string isEqualToString:@"\n"]) {
//        [textField resignFirstResponder];
//        BLOCK_EXEC(self.masterOverallRatingScoreInputBlock);
//    }
    if (self.textField.text.length > 2) {
       self.textField.text = [self.textField.text substringToIndex:2];
    }
    return YES;
}
@end
