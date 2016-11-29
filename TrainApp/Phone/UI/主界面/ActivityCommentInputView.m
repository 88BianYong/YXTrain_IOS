//
//  ActivityCommentInputView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

//NSFoundationVersionNumber_iOS_7_0
#import "ActivityCommentInputView.h"
#import "YXPromtController.h"
@interface ActivityCommentInputView ()<UITextViewDelegate>
@property (nonatomic, strong) UILabel *inputNumberLabel;
@property (nonatomic, strong) UILabel *totalNumberLabel;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, copy) ActivityCommentShowInputViewBlock isShowBlock;
@property (nonatomic, copy) ActivityCommentInputTextBlock inputTextBlock;
@end

@implementation ActivityCommentInputView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setupUI];
        [self setupLayout];
        self.backgroundColor = [UIColor colorWithHexString:@"f2f4f7"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
        
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.textView = [[SAMTextView alloc] init];
    if ([YXTrainManager sharedInstance].currentProject.w.integerValue == 3) {//只有15评论不支持表情
        self.textView.delegate = self;
    }
    self.textView.placeholder = @"评论 :";
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
    self.sendButton.clipsToBounds = YES;
    [self.sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sendButton];
    
    self.inputNumberLabel = [[UILabel alloc] init];
    self.inputNumberLabel.font = [UIFont systemFontOfSize:14.0f];
    self.inputNumberLabel.text = @"0";
    self.inputNumberLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self addSubview:self.inputNumberLabel];
    
    self.totalNumberLabel = [[UILabel alloc] init];
    self.totalNumberLabel.font = [UIFont systemFontOfSize:14.0f];
    self.totalNumberLabel.text = @" / 200";
    self.totalNumberLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self addSubview:self.totalNumberLabel];
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
    
    [self.inputNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView.mas_left).offset(15.0f);
        make.centerY.equalTo(self.sendButton.mas_centerY);
    }];
    
    [self.totalNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputNumberLabel.mas_right);
        make.centerY.equalTo(self.sendButton.mas_centerY);
    }];
    
}
#pragma mark - button Action 
- (void)sendButtonAction:(UIButton *)sender {
    if ([[self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]!=0) {
        BLOCK_EXEC(self.inputTextBlock,self.textView.text);
    }else {
        [YXPromtController showToast:@"发布内容不能为空" inView:[self viewController].view];
    }
    
}
- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - notification
- (void)keyboardWillChangeFrame:(NSNotification *)aNotification {
    NSDictionary *userInfo = aNotification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    if (endFrame.origin.y != kScreenHeight) {
        BLOCK_EXEC(self.isShowBlock, YES);
        [UIView animateWithDuration:curve animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.superview.mas_bottom).offset(-endFrame.size.height);
            }];
        }];
    }else{
        BLOCK_EXEC(self.isShowBlock, NO);
        [UIView animateWithDuration:curve animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.superview.mas_bottom).offset(140.0f);
            }];
        }];
    }
    [self.superview layoutIfNeeded];
}
- (void)textDidChange:(NSNotification *)aNotification {
    UITextView *tempTextView = (UITextView *)aNotification.object;
    if (tempTextView.text.length == 0) {
        self.inputNumberLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
        self.sendButton.enabled = NO;
        self.sendButton.layer.borderColor = [UIColor colorWithHexString:@"b9c0c7"].CGColor;
    }else {
        self.inputNumberLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
        self.sendButton.enabled = YES;
        self.sendButton.layer.borderColor = [UIColor colorWithHexString:@"0070c9"].CGColor;

    }
    if (tempTextView.text.length > 200) {
         tempTextView.text = [tempTextView.text substringToIndex:200];
    }
    self.inputNumberLabel.text = [NSString stringWithFormat:@"%d",(int)tempTextView.text.length];
}

- (void)setActivityCommentShowInputViewBlock:(ActivityCommentShowInputViewBlock)block {
    self.isShowBlock = block;
}
- (void)setActivityCommentInputTextBlock:(ActivityCommentInputTextBlock)block {
    self.inputTextBlock = block;
}
- (void)inputTextViewClear {
    self.textView.text = nil;
    self.inputNumberLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.sendButton.enabled = NO;
    self.sendButton.layer.borderColor = [UIColor colorWithHexString:@"b9c0c7"].CGColor;
    self.self.inputNumberLabel.text = @"0";
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
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}
@end
