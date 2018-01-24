//
//  MasterLearningInfoCell_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterLearningInfoCell_17.h"
@interface MasterLearningInfoCell_17 ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *passLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation MasterLearningInfoCell_17
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - set
- (void)setLearningInfo:(MasterLearningInfoRequestItem_Body_XueQing_LearningInfoList *)learningInfo {
    _learningInfo = learningInfo;
    self.nameLabel.text = _learningInfo.realName;
    self.passLabel.text = _learningInfo.isPass.boolValue ? @"通过" : @"未通过";
    self.passLabel.textColor = _learningInfo.isPass.boolValue ?[UIColor colorWithHexString:@"e5581a"] : [UIColor colorWithHexString:@"0067b8"];
    self.scoreLabel.text = [NSString stringWithFormat:@"%@分",[_learningInfo.totalScore yx_formatInteger]];
}
#pragma mark - setupUI
- (void)setupUI {
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"林依依";
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.nameLabel];
    
    self.passLabel = [[UILabel alloc] init];
    self.passLabel.text = @"通过";
    self.passLabel.font = [UIFont systemFontOfSize:14.0f];
    self.passLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    [self.contentView addSubview:self.passLabel];
    
    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.textAlignment = NSTextAlignmentRight;
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.scoreLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:self.scoreLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:self.lineView];
}
- (void)setupLayout {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.passLabel.mas_left).offset(-10.0f);
    }];
    
    [self.passLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(1.0f/3.0f).offset(-30.0f);
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(1.0f);
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
