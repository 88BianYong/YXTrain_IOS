//
//  MasterOverallRatingListTableViewCell_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterOverallRatingListCell_17.h"
@interface MasterOverallRatingListCell_17 ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *schooleLabel;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation MasterOverallRatingListCell_17

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifie {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifie]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - set
- (void)setUserScore:(MasterOverallRatingListItem_Body_UserScore *)userScore {
    _userScore = userScore;
    self.nameLabel.text = _userScore.userName;
    self.scoreLabel.text = _userScore.score;
    self.schooleLabel.text = _userScore.schoolName;
}
#pragma mark - setupUI
- (void)setupUI {
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.contentView addSubview:self.nameLabel];
    
    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    self.scoreLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.scoreLabel];
    
    self.schooleLabel = [[UILabel alloc] init];
    self.schooleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.schooleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.schooleLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.schooleLabel];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:self.lineView];
    
}
- (void)setupLayout {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_offset((kScreenWidth - 50.0f) / 3.0f);
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_offset((kScreenWidth - 50.0f) / 3.0f);
    }];
    
    [self.schooleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_offset((kScreenWidth - 50.0f) / 3.0f);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1.0f);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
