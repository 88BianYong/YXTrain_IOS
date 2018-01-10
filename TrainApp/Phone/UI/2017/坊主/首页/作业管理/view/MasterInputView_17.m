//
//  MasterInputScrollView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterInputView_17.h"
@interface MasterInputView_17 ()<UITextViewDelegate>
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, assign) CGFloat textMaxHeight;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, copy) NSString *commentString;
@property (nonatomic, copy) NSString *recommendString;
@property (nonatomic, copy) NSString *cancleString;
@end
@implementation MasterInputView_17
- (void)dealloc {
    DDLogDebug(@"======>>%@",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textMaxHeight = 70.0f;
       _inputStatus = MasterInputStatus_Score;
       self.backgroundColor = [UIColor colorWithHexString:@"f2f4f7"];
        [self setupUI];
        [self setupLayout];
        [self setupObservers];
    }
    return self;
}

- (void)setupObservers {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextViewTextDidChangeNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        if (self.inputStatus != MasterInputStatus_Score) {
            [self uploadHeight];
            if (self.inputStatus == MasterInputStatus_Comment) {
                self.sendButton.enabled = [[self.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0;
            }else {
                self.sendButton.enabled = [[self.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] >= 10;
            }
        }else {
            if (self.scoreTextView.text.length > 3) {
                self.scoreTextView.text = [self.scoreTextView.text substringToIndex:3];
            }
            self.sendButton.enabled = ([[self.scoreTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]!=0 && self.scoreTextView.text.floatValue <= 100.0f && self.scoreTextView.text.floatValue >= 0);
        }
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSValue *keyboardFrameValue = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
        NSNumber *duration = [dic valueForKey:UIKeyboardAnimationDurationUserInfoKey];
        [UIView animateWithDuration:duration.floatValue animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                if (kScreenHeight == keyboardFrame.origin.y) {
                    make.bottom.mas_equalTo(-(kScreenHeight - keyboardFrame.origin.y) + self.bounds.size.height);
                    if (self.inputStatus == MasterInputStatus_Comment) {
                        self.commentString = self.commentTextView.text;
                    }else if (self.inputStatus == MasterInputStatus_Recommend) {
                        self.recommendString = self.commentTextView.text;
                    }else if (self.inputStatus == MasterInputStatus_Cancle){
                        self.cancleString = self.commentTextView.text;
                    }
                    self.commentTextView.text = nil;
                }else {
                    make.bottom.mas_equalTo(-(kScreenHeight - keyboardFrame.origin.y));
                }
            }];
            [self.superview layoutIfNeeded];
        }];
    }];
}
- (void)uploadHeight {
    NSInteger height = ceilf([self.commentTextView sizeThatFits:CGSizeMake(self.commentTextView.bounds.size.width, MAXFLOAT)].height);
    if (self.textHeight != height) {
        self.commentTextView.scrollEnabled = height > self.textMaxHeight;
        self.textHeight = height;
        if (!self.commentTextView.scrollEnabled) {
            [self.commentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.textHeight);
            }];
        }
        [self layoutIfNeeded];
    }
}
- (void)setInputStatus:(MasterInputStatus)inputStatus {
    _inputStatus = inputStatus;
    if (_inputStatus == MasterInputStatus_Score) {
        self.commentTextView.text = @"";
       [self uploadHeight];
        [self.scoreTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.inputView.mas_left).offset(15.0);
        }];
        [self.commentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.inputView.mas_left).offset(kScreenWidth);
        }];
        [self layoutIfNeeded];
        if (self.scoreTextView.text.length == 0) {
            self.scoreTextView.text = self.placeholderScoreString;
        }
        [self.sendButton setTitle:@"确认" forState:UIControlStateNormal];
         self.sendButton.enabled = ([[self.scoreTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]!=0 && self.scoreTextView.text.floatValue <= 100.0f && self.scoreTextView.text.floatValue >= 0);
         [self.scoreTextView becomeFirstResponder];
    }else if (_inputStatus == MasterInputStatus_Comment){
        self.commentTextView.placeholder = @"请输您对本作业的评语";
        [UIView animateWithDuration:0.25f animations:^{
            [self.scoreTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.inputView.mas_left).offset(-kScreenWidth + 60.0f);
            }];
            [self.commentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.inputView.mas_left).offset(15.0f);
            }];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.commentTextView.text = self.commentString;
            self.sendButton.enabled = [[self.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0;
            [self uploadHeight];
            [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
        }];
         [self.commentTextView becomeFirstResponder];
    }else if (_inputStatus == MasterInputStatus_Recommend){
        self.commentTextView.placeholder = @"请输入推优原因,不少以10字";
        [self.scoreTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.inputView.mas_left).offset(-kScreenWidth + 60.0f);
        }];
        [self.commentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.inputView.mas_left).offset(15.0f);
        }];
        self.commentTextView.text = self.recommendString;
        [self uploadHeight];
        [self.sendButton setTitle:@"确认" forState:UIControlStateNormal];
        self.sendButton.enabled = [[self.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] >= 10;
         [self.commentTextView becomeFirstResponder];
    }else {
        self.commentTextView.placeholder = @"取消推优的理由不少于10个字";
        [self.scoreTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.inputView.mas_left).offset(-kScreenWidth + 60.0f);
        }];
        [self.commentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.inputView.mas_left).offset(15.0f);
        }];
        self.commentTextView.text = self.cancleString;
        [self uploadHeight];
        [self.sendButton setTitle:@"确认" forState:UIControlStateNormal];
        self.sendButton.enabled = [[self.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] >= 10;
         [self.commentTextView becomeFirstResponder];
    }
}

#pragma mark - setupUI
- (void)setupUI {
    self.inputView = [[UIView alloc] init];
    self.inputView.layer.cornerRadius = YXTrainCornerRadii;
    self.inputView.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
    self.inputView.layer.borderColor = [UIColor colorWithHexString:@"a1a7ae"].CGColor;
    self.inputView.backgroundColor = [UIColor whiteColor];
    self.inputView.clipsToBounds = YES;
    [self addSubview:self.inputView];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setTitle:@"确认" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor colorWithHexString:@"a1a7ae"] forState:UIControlStateDisabled];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f4f7"]] forState:UIControlStateDisabled];
    [self.sendButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0067be"]] forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.sendButton.layer.cornerRadius = YXTrainCornerRadii;
    self.sendButton.layer.borderColor = [UIColor colorWithHexString:@"a1a7ae"].CGColor;
    self.sendButton.layer.borderWidth = 1.0f;
    self.sendButton.enabled = NO;
    WEAK_SELF
    [[self.sendButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        STRONG_SELF
        if (self.inputStatus == MasterInputStatus_Score) {
            if (self.scoreTextView.text.integerValue <= self.minScoreString.integerValue &&  self.minScoreString.integerValue != 0) {
                [YXPromtController showToast:@"再次点评不应该低于当前分数" inView:self.superview];
            }else {
                self.inputStatus = MasterInputStatus_Comment;
            }
        }else {
            BLOCK_EXEC(self.masterInputViewBlock,self.inputStatus);
        }
    }];
    [self addSubview:self.sendButton];
    
    self.commentTextView = [[SAMTextView alloc] init];
    self.commentTextView.placeholder = @"请输入您对本作业的评语";
    self.commentTextView.scrollEnabled = NO;
    self.commentTextView.font = [UIFont systemFontOfSize:14.0f];
    self.commentTextView.textColor = [UIColor colorWithHexString:@"334466"];
    self.commentTextView.returnKeyType = UIReturnKeyDone;
    self.commentTextView.delegate = self;
    [self.inputView addSubview:self.commentTextView];
    
    
    self.scoreTextView = [[SAMTextView alloc] init];
    self.scoreTextView.placeholder = @"请输入分数(0-100)";
    self.scoreTextView.scrollEnabled = NO;
    self.scoreTextView.font = [UIFont systemFontOfSize:14.0f];
    self.scoreTextView.textColor = [UIColor colorWithHexString:@"334466"];
    self.scoreTextView.keyboardType = UIKeyboardTypeNumberPad;
    self.scoreTextView.returnKeyType = UIReturnKeyDone;
    self.scoreTextView.delegate = self;
    [self.inputView addSubview:self.scoreTextView];
}
- (void)setupLayout {
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-45.0f);
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.top.equalTo(self.mas_top).offset(15.0f);
    }];
    
    [self.scoreTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputView.mas_left).offset(15.0f);
        make.width.mas_offset(kScreenWidth - 60.0f);
        make.centerY.equalTo(self.inputView.mas_centerY);
        make.height.mas_offset(33.0f);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10.5f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.size.mas_offset(CGSizeMake(74.0f, 24.0f));
    }];
    
    [self.commentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputView.mas_left).offset(kScreenWidth);
        make.width.mas_offset(kScreenWidth - 60.0f);
        make.centerY.equalTo(self.inputView.mas_centerY);
        make.top.equalTo(self.inputView.mas_top).offset(6.0f);
        make.bottom.equalTo(self.inputView.mas_bottom).offset(-6.0f);
        make.height.mas_offset(33.0f);
    }];
}
- (void)clearContent:(MasterInputStatus) inputStatus{
    if (inputStatus == MasterInputStatus_All) {
        self.commentString = nil;
        self.recommendString = nil;
        self.cancleString = nil;
        self.commentTextView.text = nil;
        self.scoreTextView.text = nil;
    }else if (inputStatus == MasterInputStatus_Recommend) {
         self.recommendString = nil;
         self.commentTextView.text = nil;
    }else if (inputStatus == MasterInputStatus_Comment) {
        self.commentString = nil;
        self.commentTextView.text = nil;
        self.scoreTextView.text = nil;
        self.placeholderScoreString = nil;
    }else if (inputStatus == MasterInputStatus_Cancle) {
        self.cancleString = nil;
        self.commentTextView.text = nil;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage] || [self stringContainsEmoji:text]) {
        return NO;
    }
    return YES;
}

- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    
                                    //                                    if (0x2100 <= high && high <= 0x27BF){
                                    //                                        returnValue = YES;
                                    //                                    }
                                }
                            }];
    
    return returnValue;
}
@end
