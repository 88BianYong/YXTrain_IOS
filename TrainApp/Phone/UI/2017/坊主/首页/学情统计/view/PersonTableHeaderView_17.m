//
//  PersonTableHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PersonTableHeaderView_17.h"
@interface PersonTableHeaderView_17 ()
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *scoreNumberLabel;
@property (nonatomic, strong) UILabel *passStatusLabel;
@property (nonatomic, strong) UILabel *scoreTitleLabel;
@property (nonatomic, strong) UILabel *passResultLabel;
@property (nonatomic, strong) UIView *bottomView;
@end
@implementation PersonTableHeaderView_17
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"导航栏-拷贝"]];
    [self addSubview:self.topImageView];

    self.userImageView = [[UIImageView alloc] init];
    self.userImageView.layer.cornerRadius = 26.5f;
    self.userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userImageView.layer.borderWidth = 2.0f;
    self.userImageView.clipsToBounds = YES;
    [self.topImageView addSubview:self.userImageView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:19.0f];
    self.nameLabel.textColor = [UIColor whiteColor];
    [self.topImageView addSubview:self.nameLabel];
    
    self.phoneLabel = [[UILabel alloc] init];
    self.phoneLabel.font = [UIFont systemFontOfSize:12.0f];
    self.phoneLabel.textColor = [UIColor whiteColor];
    [self.topImageView addSubview:self.phoneLabel];
    
    self.scoreNumberLabel = [[UILabel alloc] init];
    self.scoreNumberLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreNumberLabel.font = [UIFont systemFontOfSize:18.0f];
    self.scoreNumberLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    [self addSubview:self.scoreNumberLabel];
    
    self.scoreTitleLabel = [[UILabel alloc] init];
    self.scoreTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.scoreTitleLabel.text = @"当前成绩";
    self.scoreTitleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self addSubview:self.scoreTitleLabel];
    
    self.passStatusLabel = [[UILabel alloc] init];
    self.passStatusLabel.textAlignment = NSTextAlignmentCenter;
    self.passStatusLabel.font = [UIFont systemFontOfSize:18.0f];
    self.passStatusLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    [self addSubview:self.passStatusLabel];
    
    self.passResultLabel = [[UILabel alloc] init];
    self.passResultLabel.textAlignment = NSTextAlignmentCenter;
    self.passResultLabel.font = [UIFont systemFontOfSize:12.0f];
    self.passResultLabel.text = @"考核结果";
    self.passResultLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self addSubview:self.passResultLabel];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self addSubview:self.bottomView];
}
- (void)setupLayout {
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.mas_offset(100.0f);
    }];
    
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topImageView.mas_left).offset(15.0f);
        make.centerY.equalTo(self.topImageView.mas_centerY);
        make.size.mas_offset(CGSizeMake(53.0f, 53.0f));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImageView.mas_right).offset(17.0f);
        make.top.equalTo(self.userImageView.mas_top).offset(7.0f);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(7.0f);
    }];
    
    [self.scoreNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_width).multipliedBy(1.0f/2.0f);
        make.top.equalTo(self.topImageView.mas_bottom).offset(33.0f);
    }];
    
    [self.scoreTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_width).multipliedBy(1.0f/2.0f);
        make.top.equalTo(self.scoreNumberLabel.mas_bottom).offset(9.0f);
    }];
    
    [self.passStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self.mas_width).multipliedBy(1.0f/2.0f);
        make.centerY.equalTo(self.scoreNumberLabel.mas_centerY);
    }];
    
    [self.passResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self.mas_width).multipliedBy(1.0f/2.0f);
        make.centerY.equalTo(self.scoreTitleLabel.mas_centerY);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_offset(5.0f);
    }];
    
}
- (void)reloadPersonLearningInfo:(MasterLearningInfoRequestItem_Body_XueQing_LearningInfoList *)info withScore:(NSString *)score withPass:(BOOL)isPass {
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:info.avatar] placeholderImage:nil];
    self.nameLabel.text = info.realName;
    self.phoneLabel.text = info.mobile;
    self.passStatusLabel.text = isPass ? @"通过" : @"暂未通过";
    NSString *string = [NSString stringWithFormat:@"%@分",[score yx_formatInteger]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:YXFontMetro_Medium size:23.0f] range:NSMakeRange(0, string.length - 1)];
    self.scoreNumberLabel.attributedText = attString;
}
@end
