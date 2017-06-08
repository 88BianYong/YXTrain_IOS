//
//  VideoCourseReplyCommnetViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoCourseReplyCommnetViewController.h"
#import "SAMTextView.h"
#import "VideoCourseReplyCommnetRequest.h"

NSString *const placeholderString = @"发表感想(200字以内)...";
@interface VideoCourseReplyCommnetViewController ()<UITextViewDelegate >
@property (nonatomic, strong) SAMTextView *commentTextView;
@property (nonatomic, strong) VideoCourseReplyCommnetRequest *replyRequest;
@property (nonatomic, copy) VideoCourseReplyCommnetBlock replyComment;
@property (nonatomic, strong) UIButton *sendButton;
@end

@implementation VideoCourseReplyCommnetViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    [self setupUI];
    [self setupLayout];
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kYXTrainPushNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        [self.commentTextView resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.commentTextView becomeFirstResponder];

}
#pragma mark - setupUI
- (void)setupUI {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"aaabaf"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.frame = CGRectMake(0, 0, 50.0f, 30.0f);
    WEAK_SELF
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        [self.commentTextView resignFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        });
    }];
    [self setupLeftWithCustomView:button];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor colorWithHexString:@"aaabaf"] forState:UIControlStateDisabled];
    [self.sendButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.sendButton.frame = CGRectMake(0, 0, 50.0f, 30.0f);
    self.sendButton.enabled = NO;
    [[self.sendButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        if([[self.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
            [self showToast:@"请输入评论内容"];
        }else{
            [self requestForCommentReply:self.commentTextView.text];
        }
    }];
    [self setupRightWithCustomView:self.sendButton];

    self.commentTextView = [[SAMTextView alloc] init];
    self.commentTextView.delegate = self;
    self.commentTextView.font = [UIFont systemFontOfSize:14.0f];
    self.commentTextView.textColor = [UIColor colorWithHexString:@"334466"];
    self.commentTextView.placeholder = placeholderString;
    [self.view addSubview:self.commentTextView];
    
    RACSignal *validSignal =
    [self.commentTextView.rac_textSignal
     map:^id(NSString *text) {
         @strongify(self);
         return @(self.commentTextView.text.length > 0 ? YES: NO);
     }];
    RACSignal *signUpActiveSignal =
    [RACSignal combineLatest:@[validSignal]
                      reduce:^id(NSNumber *valid) {
                          return @([valid boolValue]);
                      }];
    [signUpActiveSignal subscribeNext:^(NSNumber *signupActive) {
        STRONG_SELF
        self.sendButton.enabled = [signupActive boolValue];
    }];
}
- (void)setupLayout {
    [_commentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(15.0f);
        make.left.equalTo(self.view.mas_left).offset(15.0f);
        make.right.equalTo(self.view.mas_right).offset(-15.0f);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
- (void)requestForCommentReply:(NSString *)inputString {
    [self.commentTextView resignFirstResponder];
    if (self.replyRequest) {
        [self.replyRequest stopRequest];
    }
    [self startLoading];
    VideoCourseReplyCommnetRequest *request = [[VideoCourseReplyCommnetRequest alloc] init];
    request.content = inputString;
    request.courseID = self.courseId;
    WEAK_SELF
    [request startRequestWithRetClass:[VideoCourseReplyCommnetRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        VideoCourseReplyCommnetRequestItem *item = retItem;
        if (error) {
            if (error.code == -2) {
                [self showToast:@"数据异常"];
            }else{
                [self showToast:@"网络异常,请稍后重试"];
            }
        }else if (item.body.comment){
            BLOCK_EXEC(self.replyComment,item.body.comment);
            [self.commentTextView resignFirstResponder];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:^{
                    self.commentTextView.text = nil;
                    self.sendButton.enabled = NO;
                }];
            });
        }else {
            [self showToast:@"数据错误"];
        }
    }];
    self.replyRequest = request;
}
- (void)setVideoCourseReplyCommnetBlock:(VideoCourseReplyCommnetBlock)block {
    self.replyComment = block;
}
#pragma mark - delegate
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
- (void)showToast:(NSString *)toast{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in [windows reverseObjectEnumerator])
    {
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:window];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = toast;
        hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16.0f];
        hud.removeFromSuperViewOnHide = YES;
        [window addSubview:hud];
        [hud show:YES];
        [hud hide:YES afterDelay:2];
    }
}
@end
