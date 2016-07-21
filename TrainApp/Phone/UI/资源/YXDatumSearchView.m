//
//  YXDatumSearchView.m
//  TrainApp
//
//  Created by 李五民 on 16/6/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXDatumSearchView.h"

@interface YXDatumSearchView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *searchImageView;

@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation YXDatumSearchView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.searchImageView = [[UIImageView alloc] init];
    self.searchImageView.image = [UIImage imageNamed:@"搜索输入框内的搜索icon"];
    [self addSubview:self.searchImageView];
    
    self.searchTextField = [[UITextField alloc] init];
    self.searchTextField .clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.textColor = [UIColor colorWithHexString:@"334466"];
    self.searchTextField.font = [UIFont systemFontOfSize:14];
    self.searchTextField.keyboardType = UIKeyboardTypeDefault;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    NSString *placeholder = @"输入文件名搜索";
    self.searchTextField.placeholder = placeholder;
    [self.searchTextField setValue:[UIColor colorWithHexString:@"a1a7ae"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.searchTextField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    self.searchTextField.delegate = self;
    [self addSubview:self.searchTextField];
    
    self.cancelButton = [[UIButton alloc] init];
    [self.cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.cancelButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
    [self addSubview:self.cancelButton];
    
    [self.searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.equalTo(self.searchImageView.mas_right).offset(5);
        make.top.bottom.mas_equalTo(0);
    }];
    [self.searchTextField setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.searchTextField setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchTextField.mas_right);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
}

- (void)setFirstResponse {
    [self.searchTextField becomeFirstResponder];
}

- (void)setTextFieldWithString:(NSString *)string {
    self.searchTextField.text = string;
}

- (void)cancelButtonClicked {
    [self endEditing:YES];
    if (self.cancelButtonClickedBlock) {
        self.cancelButtonClickedBlock();
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.textBeginEdit) {
        self.textBeginEdit();
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.texEndEdit) {
        self.texEndEdit();
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.textShouldClear) {
        self.textShouldClear();
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchTextField endEditing:YES];
    if (self.textShouldReturn) {
        self.textShouldReturn(textField.text);
    }
    return YES;
}


@end
