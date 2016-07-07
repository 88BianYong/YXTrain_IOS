//
//  YXUserImageTableViewCell.m
//  TrainApp
//
//  Created by 李五民 on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXUserImageTableViewCell.h"

@interface YXUserImageTableViewCell ()

@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *desLabel;

@end

@implementation YXUserImageTableViewCell

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
    self.userImageView = [[UIImageView alloc] init];
    self.userImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.userImageView];
    UITapGestureRecognizer * tapUserImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserImageGesture:)];
    [self.userImageView addGestureRecognizer:tapUserImageGesture];
    
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.iconImageView];
    
    self.desLabel = [[UILabel alloc] init];
    self.desLabel.text = @"点击修改头像";
    self.desLabel.font = [UIFont systemFontOfSize:12];
    self.desLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.desLabel];
    
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(28);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    self.userImageView.layer.cornerRadius = 50;
    self.userImageView.layer.masksToBounds = YES;
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.userImageView.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(4);
    }];
}

- (void)tapUserImageGesture:(UIGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.userImageTap) {
            self.userImageTap();
        }
    }
}

@end
