//
//  YXUserTextFieldTableViewCell.m
//  TrainApp
//
//  Created by 李五民 on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXUserTextFieldTableViewCell.h"

@interface YXUserTextFieldTableViewCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *userTitleLabel;
@property (nonatomic, strong) UITextField *contentTextField;

@end

@implementation YXUserTextFieldTableViewCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    self.userTitleLabel = [[UILabel alloc] init];
    self.userTitleLabel.text = @"姓名";
    self.userTitleLabel.textAlignment = NSTextAlignmentRight;
    self.userTitleLabel.font = [UIFont systemFontOfSize:14];
    self.userTitleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.userTitleLabel];
    
    UIButton *editIconButton = [[UIButton alloc] init];
    [editIconButton addTarget:self action:@selector(editButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [editIconButton setImage:[UIImage imageNamed:@"修改个人资料icon"] forState:UIControlStateNormal];
    //editIconImageView.image = [UIImage imageNamed:@"修改个人资料icon"];
    [self.contentView addSubview:editIconButton];
    
    self.contentTextField = [[UITextField alloc] init];
    self.contentTextField.delegate = self;
    self.contentTextField.font = [UIFont boldSystemFontOfSize:14];
    self.contentTextField.text = @"暂无";
    self.contentTextField.textColor = [UIColor colorWithHexString:@"334466"];
    self.contentTextField.keyboardType = UIReturnKeyDone;
    [self.contentView addSubview:self.contentTextField];
    
    [self.userTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(90);
    }];
    
    [self.contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.userTitleLabel.mas_right).offset(14);
        make.right.mas_equalTo(-50);
    }];
    [editIconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.left.equalTo(self.contentTextField.mas_right).offset(0);
    }];
}

- (void)setUserName:(NSString *)name {
    if ([name yx_isValidString]) {
        self.contentTextField.text = name;
    } else {
        self.contentTextField.text = @"暂无";
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.startUpdateUserName) {
        self.startUpdateUserName(textField.text);
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.contentTextField resignFirstResponder];
    return YES;
}

- (void)editButtonClicked {
    [self.contentTextField becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location >20)
    {
        return  NO;
    }
    return YES;
}

- (void)textFieldDidChange
{
    if (self.contentTextField.text.length > 20) {
        self.contentTextField.text = [self.contentTextField.text substringToIndex:20];
    }
}


@end
