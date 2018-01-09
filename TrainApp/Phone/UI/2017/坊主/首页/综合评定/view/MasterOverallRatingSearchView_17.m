//
//  MasterOverallRatingSearchView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterOverallRatingSearchView_17.h"
@interface MasterOverallRatingSearchView_17 ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *searchImageView;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation MasterOverallRatingSearchView_17
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = [UIColor redColor];
        WEAK_SELF
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidChangeNotification object:nil] subscribeNext:^(id x) {
            STRONG_SELF
            BLOCK_EXEC(self.textShouldReturn,self.searchTextField.text.lowercaseString);
        }];
    }
    return self;
}

- (void)setupUI {
    //ios11输入框会变得诡异
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.hidden = YES;
    self.titleLabel.text = @"撒就爱看老实交代克拉斯大卡司大Sasasasasas叔大婶dadahdahsdalkjsalh多撒";
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.searchImageView = [[UIImageView alloc] init];
    self.searchImageView.image = [UIImage imageNamed:@"搜索输入框内的搜索icon"];
    [self addSubview:self.searchImageView];
    
    self.searchTextField = [[UITextField alloc] init];
    self.searchTextField .clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.textColor = [UIColor colorWithHexString:@"334466"];
    self.searchTextField.font = [UIFont systemFontOfSize:14];
    self.searchTextField.keyboardType = UIKeyboardTypeDefault;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    NSString *placeholder = @"请输入学员姓名";
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
    BLOCK_EXEC(self.cancelButtonClickedBlock);
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
       BLOCK_EXEC(self.textBeginEdit);
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    BLOCK_EXEC(self.texEndEdit);
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    BLOCK_EXEC(self.textShouldClear);
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchTextField endEditing:YES];
    return YES;
}
@end
