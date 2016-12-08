//
//  BeijingCheckedMobileUserCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingCheckedMobileUserCell.h"
@interface BeijingCheckedMobileUserCell ()
@property (nonatomic, copy) BeijingCheckedMobileUserBlock cancleBlock;

@end
@implementation BeijingCheckedMobileUserCell
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark - setupUI
- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = YXTrainCornerRadii;
    [self.contentView addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    self.textField = [[UITextField alloc] init];
    self.textField.font = [UIFont systemFontOfSize:14.0f];
    self.textField.textColor = [UIColor colorWithHexString:@"334466"];
    [self.textField setValue:[UIColor colorWithHexString:@"c6c9cc"] forKeyPath:@"_placeholderLabel.textColor"];
    self.textField.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:self.textField];
    
    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancleButton setImage:[UIImage imageNamed:@"删除当前内容-正常态"] forState:UIControlStateNormal];
    [self.cancleButton setImage:[UIImage imageNamed:@"删除当前内容-点击态"] forState:UIControlStateHighlighted];
    [self.cancleButton addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cancleButton.hidden = YES;
    [self.contentView addSubview:self.cancleButton];
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(20.0f, 20.0f));
        make.right.equalTo(self.contentView.mas_right).offset(-24.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(25.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.cancleButton.mas_left).offset(-10.0f);
    }];
}

- (void)setupLayout {
    
}

- (void)setBeijingCheckedMobileUserBlock:(BeijingCheckedMobileUserBlock)block {
    self.cancleBlock = block;
}
- (void)cancleButtonAction:(UIButton *)sender {
    self.textField.text = nil;
    self.cancleButton.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainDeleteInfo object:@(YES)];
    BLOCK_EXEC(self.cancleBlock);
}

- (void)textDidChange:(NSNotification *)aNotification {
    if (self.textField.text.length == 0) {
        self.cancleButton.hidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainDeleteInfo object:@(YES)];
    }else {
        self.cancleButton.hidden = NO;
    }
}
@end
