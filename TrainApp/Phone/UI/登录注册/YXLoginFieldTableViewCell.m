//
//  YXLoginFieldTableViewCell.m
//  TrainApp
//
//  Created by 李五民 on 16/6/24.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXLoginFieldTableViewCell.h"
#import "YXLoginTextFiledView.h"

@interface YXLoginFieldTableViewCell ()

@property (nonatomic,strong) YXLoginTextFiledView *loginTextField;

@end

@implementation YXLoginFieldTableViewCell

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.loginTextField = [[YXLoginTextFiledView alloc] init];
    [self.loginTextField setTextColor:[UIColor colorWithHexString:@"334466"] placeHolderColor:[UIColor colorWithHexString:@"c6c9cc"]];
    @weakify(self);
    self.loginTextField.textChangedBlock = ^(NSString *text) {
        @strongify(self);
        if (self.textChangedBlock) {
            self.textChangedBlock(text);
        }
    };
    [self.loginTextField setTextFiledViewBackgroundColor:[UIColor whiteColor]];
    [self.loginTextField setTextFiledEditedBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.loginTextField];
    [self.loginTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
}

- (void)setPlaceHolderWithString:(NSString *)str keyType:(UIKeyboardType)keyType isSecure:(BOOL)isSecure {
    [self.loginTextField setPlaceHolderWithString:str keyType:keyType isSecure:isSecure];
}

- (void)setRightButtonImage {
    [self.loginTextField setRightButtonWhiteColor];
}

@end
