//
//  YXUserTextFieldTableViewCell.m
//  TrainApp
//
//  Created by 李五民 on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXUserTextFieldTableViewCell.h"

@interface YXUserTextFieldTableViewCell ()

@property (nonatomic, strong) UILabel *userTitleLabel;
@property (nonatomic, strong) UITextField *contentTextField;

@end

@implementation YXUserTextFieldTableViewCell

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
    self.userTitleLabel = [[UILabel alloc] init];
    self.userTitleLabel.text = @"姓名";
    self.userTitleLabel.textAlignment = NSTextAlignmentRight;
    self.userTitleLabel.font = [UIFont systemFontOfSize:14];
    self.userTitleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.userTitleLabel];
    
    self.contentTextField = [[UITextField alloc] init];
    self.contentTextField.font = [UIFont boldSystemFontOfSize:14];
    self.contentTextField.text = @"暂无";
    self.contentTextField.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.contentTextField];
    
    [self.userTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(90);
    }];
    
    [self.contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.userTitleLabel.mas_right).offset(14);
        make.right.mas_equalTo(-20);
    }];
}

@end
