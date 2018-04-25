//
//  YXTrainListChooseCell.m
//  TrainApp
//
//  Created by 郑小龙 on 2018/4/25.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXTrainListChooseCell.h"
@interface YXTrainListChooseCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end
@implementation YXTrainListChooseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - set
- (void)setTrain:(YXTrainListRequestItem_body_train *)train {
    _train = train;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.2f;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_train.name?:@""];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _train.name.length)];
    self.nameLabel.attributedText = attributedString;
    NSString *statusString = @"未开始";
    if ([LSTSharedInstance sharedInstance].trainManager.currentProject.status.integerValue == 0) {
        statusString = @"已结束";
    }else if ([LSTSharedInstance sharedInstance].trainManager.currentProject.status.integerValue == 1){
        statusString = @"进行中";
    }
    self.statusLabel.text = [NSString stringWithFormat:@"项目状态: %@",statusString];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",[LSTSharedInstance sharedInstance].trainManager.currentProject.startDate,[LSTSharedInstance sharedInstance].trainManager.currentProject.endDate];
}
#pragma mark - setupUI
- (void)setupUI {
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14.0];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.numberOfLines = 2;
    [self.contentView addSubview:self.nameLabel];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.statusLabel.font = [UIFont systemFontOfSize:14.0f];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.statusLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.timeLabel.font = [UIFont systemFontOfSize:13.0f];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.timeLabel];
}
- (void)setupLayout {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(30.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-30.0f);
        make.top.equalTo(self.contentView.mas_top).offset(20.0f);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(14.0f);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.statusLabel.mas_bottom).offset(18.0f);
    }];
}
- (void)setIsChooseBool:(BOOL)isChooseBool {
    _isChooseBool = isChooseBool;
    if (_isChooseBool) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    }else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
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
