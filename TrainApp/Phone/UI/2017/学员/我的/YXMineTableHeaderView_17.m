//
//  YXMineTableHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2018/3/13.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXMineTableHeaderView_17.h"
@interface YXMineTableHeaderView_17 ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *userHeaderImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *studySegmentLabel;
@property (nonatomic, strong) UIImageView *nextImageView;
@end
@implementation YXMineTableHeaderView_17
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    //    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:_userProfile.headDetail ?: _userProfile.head] placeholderImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0067be"]]];
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:_userProfile.headDetail ?: _userProfile.head] placeholderImage:[UIImage imageNamed:@"个人信息默认用户头像"]];
    self.nameLabel.text = _userProfile.realName;
    NSString *contentString =_userProfile.stage;
    if ([_userProfile.subject yx_isValidString]) {
        if ([contentString yx_isValidString]) {
            contentString = [NSString stringWithFormat:@"%@ / %@", _userProfile.subject, contentString];
        } else {
            contentString = _userProfile.subject;
        }
    }
    self.studySegmentLabel.text = contentString;
}
#pragma mark - setupUI
- (void)setupUI {
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    self.backgroundImageView.userInteractionEnabled = YES;
    self.backgroundImageView.image = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0067be"]];
    [self addSubview:self.backgroundImageView];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    WEAK_SELF
    [[tapGestureRecognizer rac_gestureSignal] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.mineHeaderUserCompleteBlock);
    }];
    [self.backgroundImageView addGestureRecognizer:tapGestureRecognizer];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.alpha = 0.95f;
    
    [self.backgroundImageView addSubview:effectView];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.backgroundImageView);
    }];
    
    UIImageView *userHeaderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"头像背景"]];
    userHeaderView.userInteractionEnabled = NO;
    [self addSubview:userHeaderView];
    
    self.userHeaderImageView = [[UIImageView alloc] init];
    self.userHeaderImageView.contentMode = UIViewContentModeScaleToFill;
    self.userHeaderImageView.clipsToBounds = YES;
    self.userHeaderImageView.layer.cornerRadius = 37.5f;
    [self addSubview:self.userHeaderImageView];
    
    [userHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.userHeaderImageView);
        make.size.mas_offset(CGSizeMake(143.0f, 143.0f));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    self.nameLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.nameLabel];
    self.studySegmentLabel = [[UILabel alloc] init];
    self.studySegmentLabel.font = [UIFont systemFontOfSize:13.0f];
    self.studySegmentLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.studySegmentLabel];
    
    self.nextImageView = [[UIImageView alloc] init];
    self.nextImageView.image = [UIImage imageNamed:@"意见反馈展开箭头"];
    [self addSubview:self.nextImageView];
}
- (void)setupLayout {
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    [self.userHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(75.0f, 75.0f));
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(20.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userHeaderImageView.mas_right).offset(18.0f);
        make.bottom.equalTo(self.userHeaderImageView.mas_centerY).offset(-5.5f);
    }];
    [self.studySegmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userHeaderImageView.mas_right).offset(18.0f);
        make.top.equalTo(self.userHeaderImageView.mas_centerY).offset(5.5f);
    }];
    
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.height.width.mas_equalTo(16.0f);
        make.centerY.equalTo(self.mas_centerY);
    }];
}
@end
