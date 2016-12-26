//
//  YXLoginTextFiledView.m
//  TrainApp
//
//  Created by 李五民 on 16/6/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXLoginTextFiledView.h"
#import "YXMiddlePlaceholderTextField.h"

@interface YXLoginTextFiledView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) YXMiddlePlaceholderTextField *textField;
@property (nonatomic, strong) UIColor *viewBackgroundColor;
@property (nonatomic, strong) UIColor *editedColor;

@end

@implementation YXLoginTextFiledView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.layer.cornerRadius = YXTrainCornerRadii;
    self.layer.masksToBounds = YES;
    self.rightButton = [[UIButton alloc]init];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"删除当前输入内容"] forState:UIControlStateNormal];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"删除当前输入内容点击态"] forState:UIControlStateHighlighted];
    [self.rightButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.rightButton];
    self.rightButton.hidden = YES;
    
    self.textField = [[YXMiddlePlaceholderTextField alloc]init];
    self.textField.textColor = [UIColor colorWithHexString:@"ffffff"];
    self.textField.font = [UIFont fontWithName:YXFontMetro_Light size:20];
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.returnKeyType = UIReturnKeyDone;
    NSString *placeholder = @"请输入密码";
    self.textField.placeholder = placeholder;
    [self.textField setValue:[UIColor colorWithHexString:@"ffffff"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.textField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    self.textField.delegate = self;
    [self addSubview:self.textField];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.mas_equalTo(self.textField.mas_right).mas_offset(10);
    }];
    
}

- (void)clearAction{
    self.textField.text = nil;
    if (self.textChangedBlock) {
        self.textChangedBlock(nil);
    }
    self.rightButton.hidden = YES;
    [self.textField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.backgroundColor = self.editedColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (![textField.text yx_isValidString]) {
        self.backgroundColor = self.viewBackgroundColor;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
    }else{
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (self.textChangedBlock) {
            self.textChangedBlock(text);
        }
        self.rightButton.hidden = text.length == 0? YES:NO;
    }
    return YES;
}

- (void)setTextFiledViewBackgroundColor:(UIColor *)backgroundColor {
    self.viewBackgroundColor = backgroundColor;
    self.backgroundColor = self.viewBackgroundColor;
}

- (void)setTextFiledEditedBackgroundColor:(UIColor *)backgroundColor {
    self.editedColor = backgroundColor;
}

- (void)setPlaceHolderWithString:(NSString *)str keyType:(UIKeyboardType)keyType isSecure:(BOOL)isSecure{
    self.textField.placeholder = str;
    self.textField.keyboardType = keyType;
    self.textField.secureTextEntry = isSecure;;
}

- (void)setTextColor:(UIColor *)color placeHolderColor:(UIColor *)placeHolderColor{
    self.textField.textColor = color;
    [self.textField setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)resetTextFieldText {
    self.textField.text = @"";
}

- (void)setRightButtonWhiteColor {
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"白色框删除当前输入内容"] forState:UIControlStateNormal];
}

- (void)setText:(NSString *)text {
    self.textField.text = text;
    BLOCK_EXEC(self.textChangedBlock,text);
}

@end
