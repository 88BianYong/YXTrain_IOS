//
//  MasterMainTableHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterMainTableHeaderView_17.h"
@interface MasterMainTableHeaderView_17 ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *nextImageView;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *schooleLabel;
@end
@implementation MasterMainTableHeaderView_17
- (void)dealloc {
    DDLogDebug(@"release======>>%@",NSStringFromClass([self class]));
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - set
- (void)setUserProfile:(YXUserProfile *)userProfile {
    _userProfile = userProfile;
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[LSTSharedInstance sharedInstance].userManger.userModel.profile.head] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
    self.schooleLabel.text = [LSTSharedInstance sharedInstance].userManger.userModel.profile.school;
}
#pragma mark - setupUI
- (void)setupUI {
    self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"导航栏-拷贝"]];
    self.bgImageView.userInteractionEnabled = YES;
    [self addSubview:self.bgImageView];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [[gestureRecognizer rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer * sender) {
        if (sender.state == UIGestureRecognizerStateEnded) {
            BLOCK_EXEC(self.masterMainUserCompleteBlock);
        }
    }];
    [self.bgImageView addGestureRecognizer:gestureRecognizer];
    self.nextImageView = [[UIImageView alloc] init];
    self.nextImageView.image = [UIImage imageNamed:@"意见反馈展开箭头"];
    [self.bgImageView addSubview:self.nextImageView];
    
    self.userImageView = [[UIImageView alloc] init];
    self.userImageView.layer.cornerRadius = 37.5f;
    self.userImageView.clipsToBounds = YES;
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[LSTSharedInstance sharedInstance].userManger.userModel.profile.head] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
    [self.bgImageView addSubview:self.userImageView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:19.0f];
    self.nameLabel.text = [LSTSharedInstance sharedInstance].userManger.userModel.profile.realName;
    [self.bgImageView addSubview:self.nameLabel];
    
    self.schooleLabel = [[UILabel alloc] init];
    self.schooleLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    self.schooleLabel.text = [LSTSharedInstance sharedInstance].userManger.userModel.profile.school;
    self.schooleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.bgImageView addSubview:self.schooleLabel];
}
- (void)setupLayout {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImageView.mas_right).offset(-15.0f);
        make.size.mas_offset(CGSizeMake(16.0f, 16.0f));
        make.centerY.equalTo(self.bgImageView.mas_centerY);
    }];
    
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView.mas_left).offset(15.0f);
        make.size.mas_offset(CGSizeMake(75.0f, 75.0f));
        make.centerY.equalTo(self.bgImageView.mas_centerY);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImageView.mas_right).offset(25.0f);
        make.bottom.equalTo(self.userImageView.mas_centerY).offset(-5.5f);
    }];
    [self.schooleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImageView.mas_right).offset(25.0f);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(9.0f);
    }];
}
@end
