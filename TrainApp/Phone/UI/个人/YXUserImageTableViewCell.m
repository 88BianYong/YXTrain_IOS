//
//  YXUserImageTableViewCell.m
//  TrainApp
//
//  Created by 李五民 on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXUserImageTableViewCell.h"
#import "UserStatusView.h"
@interface YXUserImageTableViewCell ()

@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UserStatusView *statusView;

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
    self.userImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.userImageView];
    UITapGestureRecognizer * tapUserImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserImageGesture:)];
    [self.userImageView addGestureRecognizer:tapUserImageGesture];
    
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.image = [UIImage imageNamed:@"点击修改头像图标"];
    [self.contentView addSubview:self.iconImageView];
    
    self.desLabel = [[UILabel alloc] init];
    self.desLabel.text = @"点击修改头像";
    self.desLabel.font = [UIFont systemFontOfSize:12];
    self.desLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.desLabel];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:self.bottomView];
    
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(28);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    self.userImageView.layer.cornerRadius = 50;
    self.userImageView.layer.masksToBounds = YES;
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.userImageView.mas_bottom).offset(-15);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(4);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    if ([YXTrainManager sharedInstance].currentProject.isDoubel.boolValue) {
        self.statusView = [[UserStatusView alloc]init];
        self.statusView.isMasterBool = [YXTrainManager sharedInstance].currentProject.role.intValue == 99;
        [self.contentView addSubview:self.statusView];
        [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(169.0f, 26.0f));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.0f);
            make.centerX.equalTo(self.contentView.mas_centerX);
        }];
    }
}

- (void)tapUserImageGesture:(UIGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.userImageTap) {
            self.userImageTap();
        }
    }
}

-(void)setImageWithUrl:(NSString *)urlString{
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"个人信息默认用户头像"]];
}
-(void)setImageWithDataImage:(UIImage *)image{
    self.userImageView.image = image;
}

@end
