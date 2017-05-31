//
//  YXLoginButtonTableViewCell.m
//  TrainApp
//
//  Created by 李五民 on 16/6/24.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXLoginButtonTableViewCell.h"

@interface YXLoginButtonTableViewCell ()

@property (nonatomic, strong) UIButton *btn;

@end

@implementation YXLoginButtonTableViewCell

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
    self.btn = [[UIButton alloc] init];
    self.btn.backgroundColor = [UIColor whiteColor];
    [self.btn setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]] forState:UIControlStateHighlighted];
    [self.btn setTitleColor:[UIColor colorWithHexString:@"cf2627"] forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.btn.layer.cornerRadius = YXTrainCornerRadii;
    self.btn.layer.masksToBounds = YES;
    [self.contentView addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
}

- (void)setTitleWithString:(NSString *)string {
    [self.btn setTitle:string forState:UIControlStateNormal];
}

- (void)btnClicked {
    if (self.buttonClicked) {
        self.buttonClicked();
    }
}

@end
