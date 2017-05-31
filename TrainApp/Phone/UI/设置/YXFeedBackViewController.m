//
//  YXFeedBackViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFeedBackViewController.h"
#import "SAMTextView.h"
#import "YXFeedBackRequest.h"
@interface YXFeedBackViewController ()
<
  UITextViewDelegate
>
{
    UIView *_feedBackView;
    SAMTextView *_feedBackTextView;
    UIView *_contactView;
    UITextField *_contactTextField;
    UILabel *_contactLabel;
    UIButton *_submitButton;
    
    UIScrollView *_scrollView;
    UIView *_contentView;
    
    YXFeedBackRequest *_feedBackRequest;
}
@end

@implementation YXFeedBackViewController
- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self setupUI];
    [self layoutInterface];
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]subscribeNext:^(id x) {
        @strongify(self);
        if (!self) {
            return;
        }
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSValue *keyboardFrameValue = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
        CGFloat bottom = [UIScreen mainScreen].bounds.size.height-keyboardFrame.origin.y;
        [self ->_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-bottom);
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Setting
- (void)setupUI{
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64.0f);
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.contentSize = frame.size;
    _scrollView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.view addSubview:_scrollView];
    
    _contentView = [[UIView alloc] initWithFrame:frame];
    [_scrollView addSubview:_contentView];
    
    _feedBackView = [[UIView alloc] init];
    _feedBackView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_feedBackView];
    
    _feedBackTextView = [[SAMTextView alloc] init];
    _feedBackTextView.delegate = self;
    _feedBackTextView.font = [UIFont systemFontOfSize:14.0f];
    _feedBackTextView.textColor = [UIColor colorWithHexString:@"334466"];
    [_feedBackView addSubview:_feedBackTextView];
    _feedBackTextView.placeholder = @"请简单描述您的问题，或对我们提出宝贵建议(4-500字)";
    
    _contactView = [[UIView alloc] init];
    _contactView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_contactView];
    
    _contactTextField = [[UITextField alloc] init];
    _contactTextField.font = [UIFont systemFontOfSize:14];
    _contactTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_contactView addSubview:_contactTextField];
    _contactTextField.placeholder = @"我们会第一时间联系你";
    
    _contactLabel = [[UILabel alloc] init];
    _contactLabel.textColor = [UIColor colorWithHexString:@"334466"];
    _contactLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    _contactLabel.text = @"电话/QQ";
    [_contactView addSubview:_contactLabel];
    
    _submitButton = [[UIButton alloc] init];
    [_contentView addSubview:_submitButton];
    [_submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    _submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitButton.backgroundColor = [UIColor colorWithHexString:@"cf2627"];
    _submitButton.layer.cornerRadius = 4;
    _submitButton.layer.masksToBounds = YES;
}

- (void)layoutInterface{
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    

    
    [_feedBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_contentView.mas_top).offset(5.0f);
        make.height.mas_offset(165.0f);
        make.left.equalTo(self->_contentView.mas_left);
        make.right.equalTo(self->_contentView.mas_right);
    }];
    [_feedBackTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_feedBackView).offset(5.0f);
        make.left.equalTo(self->_feedBackView).offset(15.0f);
        make.right.equalTo(self->_feedBackView.mas_right).offset(-15.0f);
        make.bottom.equalTo(self->_feedBackView.mas_bottom);
    }];
    
    [_contactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_feedBackView.mas_bottom).offset(10.0f);
        make.left.right.equalTo(self->_contentView);
        make.height.mas_offset(45.0f);
    }];
    [_contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_contactView.mas_left).offset(15.0f);
        make.centerY.equalTo(self->_contactView.mas_centerY);
    }];
    [_contactTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->_contactView.mas_right).offset(-15.0f);
        make.left.equalTo(self->_contactLabel.mas_right).offset(16.0f);
        make.centerY.equalTo(self->_contactView.mas_centerY);
        make.height.mas_offset(30.0f);
    }];
    
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_contentView.mas_left).offset(15.0f);
        make.right.equalTo(self->_contentView.mas_right).offset(-15.0f);
        make.top.equalTo(self->_contactView.mas_bottom).offset(34.0f);
        make.height.mas_offset(44.0f);
    }];
}

#pragma mark -uitextview delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location >500)
    {
        [self showToast:@"内容最多500个字"];
        [textView resignFirstResponder];
        return  NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length > 500)
    {
        [self showToast:@"内容最多500个字"];
        textView.text = [textView.text substringToIndex:500];
        [textView resignFirstResponder];;
    }
}

#pragma mark - button Action
- (void)submitButtonAction:(UIButton *)sender{
    [self yx_hideKeyboard];
    NSString *string = [_feedBackTextView.text yx_stringByTrimmingCharacters];
    if ([string yx_isValidString] && string.length >= 4) {
        [self requestForFeedback];
    } else {
        [self showToast:@"内容最少4字"];
    }
}

#pragma mark request
- (void)requestForFeedback{
    if(_feedBackRequest){
        [_feedBackRequest  stopRequest];
    }
    NSString *content = [_feedBackTextView.text yx_stringByTrimmingCharacters];
    content = (content.length > 500) ? [content substringToIndex:500]:content;
    YXFeedBackRequest *request = [[YXFeedBackRequest alloc] init];
    request.sysver = [UIDevice currentDevice].systemVersion;
    request.content = content;
    request.phonenumber = _contactTextField.text.length > 0?_contactTextField.text:@"unKnown";
    NSData *data = [@"iOS客户端暂不上传日志" dataUsingEncoding:NSUTF8StringEncoding];
    [request.request setData:data  withFileName:@"crash.txt" andContentType:nil  forKey:@"file"];
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[YXFeedBackRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        [self stopLoading];
        STRONG_SELF
        YXFeedBackRequestItem *item = retItem;
        if (item && !error) {
            [self showToast:@"提交成功，感谢您的宝贵意见"];
            [YXDataStatisticsManger trackEvent:@"意见反馈" label:@"成功提交意见反馈" parameters:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else{
            [self showToast:error.localizedDescription];
        }
    }];
    _feedBackRequest = request;
}
@end
