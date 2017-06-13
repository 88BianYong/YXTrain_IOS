//
//  StudentsLearnSwipeCell.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "StudentsLearnSwipeCell.h"
@interface StudentsLearnSwipeCell ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *pointView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *studyLabel;
@property (nonatomic, strong) UIView *middleLineView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *totalNameLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UILabel *leadNameLabel;
@property (nonatomic, strong) UILabel *leadLabel;
@property (nonatomic, strong) UILabel *expandNameLabel;
@property (nonatomic, strong) UILabel *expandLabel;
@property (nonatomic, strong) UIView *lineView;


@end
@implementation StudentsLearnSwipeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

#pragma mark - setup UI
- (void)setupUI {
    self.topView = [[UIView alloc] init];
    [self.containerView addSubview:self.topView];
    self.pointView = [[UIView alloc] init];
    self.pointView.backgroundColor = [UIColor colorWithHexString:@"334466"];
    self.pointView.layer.cornerRadius = 1.5f;
    [self.topView addSubview:self.pointView];
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"测试学员001";
    self.nameLabel.font = [UIFont systemFontOfSize:13.0f];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.topView addSubview:self.nameLabel];
    
    self.studyLabel = [[UILabel alloc] init];
    self.studyLabel.text = @"陕西省网络学校 | 语文";
    self.studyLabel.font = [UIFont systemFontOfSize:12.0f];
    self.studyLabel.textAlignment = NSTextAlignmentRight;
    self.studyLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.topView addSubview:self.studyLabel];
    
    self.middleLineView = [[UIView alloc] init];
    self.middleLineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.topView addSubview:self.middleLineView];
    
    self.bottomView = [[UIView alloc] init];
    [self.containerView addSubview:self.bottomView];
    self.totalNameLabel = [[UILabel alloc] init];
    self.totalNameLabel.text = @"总成绩:";
    self.totalNameLabel.font = [UIFont systemFontOfSize:12.0f];
    self.totalNameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.bottomView addSubview:self.totalNameLabel];
    self.totalLabel = [[UILabel alloc] init];
    self.totalLabel.text = @"10.0";
    self.totalLabel.font = [UIFont systemFontOfSize:12.0f];
    self.totalLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    [self.bottomView addSubview:self.totalLabel];
    
    self.leadNameLabel = [[UILabel alloc] init];
    self.leadNameLabel.text = @"引领学习:";
    self.leadNameLabel.font = [UIFont systemFontOfSize:12.0f];
    self.leadNameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.bottomView addSubview:self.leadNameLabel];
    self.leadLabel = [[UILabel alloc] init];
    self.leadLabel.text = @"1.4";
    self.leadLabel.font = [UIFont systemFontOfSize:12.0f];
    self.leadLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.bottomView addSubview:self.leadLabel];
    
    self.expandNameLabel = [[UILabel alloc] init];
    self.expandNameLabel.text = @"拓展学习";
    self.expandNameLabel.font = [UIFont systemFontOfSize:12.0f];
    self.expandNameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.bottomView addSubview:self.expandNameLabel];
    self.expandLabel = [[UILabel alloc] init];
    self.expandLabel.text = @"22.0";
    self.expandLabel.font = [UIFont systemFontOfSize:12.0f];
    self.expandLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.bottomView addSubview:self.expandLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.bottomView addSubview:self.lineView];
}
- (void)setIsChooseBool:(BOOL)isChooseBool {
    [super setIsChooseBool:isChooseBool];
    if (isChooseBool) {
        self.learningInfo.isChoose = @"1";
    }else {
        self.learningInfo.isChoose = @"0";
    }
}
- (void)setupLayout {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.top.equalTo(self.containerView.mas_top);
        make.height.mas_offset(40.0f);
    }];
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(15.0f);
        make.centerY.equalTo(self.topView.mas_centerY);
        make.size.mas_offset(CGSizeMake(3.0f, 3.0f));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pointView.mas_right).offset(7.0f);
        make.centerY.equalTo(self.topView.mas_centerY);
    }];
    [self.studyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right).offset(-15.0f);
        make.centerY.equalTo(self.topView.mas_centerY);
    }];
    [self.middleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(15.0f);
        make.right.equalTo(self.topView.mas_right);
        make.top.equalTo(self.topView.mas_bottom);
        make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.top.equalTo(self.topView.mas_bottom);
        make.bottom.equalTo(self.containerView.mas_bottom);
    }];
    [self.totalNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left).offset(15.0f);
        make.centerY.equalTo(self.bottomView.mas_centerY);
    }];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalNameLabel.mas_right).offset(5.0f);
        make.centerY.equalTo(self.bottomView.mas_centerY);
    }];
    [self.leadNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_centerX).multipliedBy(0.666);
        make.centerY.equalTo(self.bottomView.mas_centerY);
    }];
    [self.leadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leadNameLabel.mas_right).offset(5.0f);
        make.centerY.equalTo(self.bottomView.mas_centerY);
    }];
    [self.expandNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_right).offset(-kScreenWidth/3.0f);
        make.centerY.equalTo(self.bottomView.mas_centerY);
    }];
    [self.expandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.expandNameLabel.mas_right).offset(5.0f);
        make.centerY.equalTo(self.bottomView.mas_centerY);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left);
        make.right.equalTo(self.bottomView.mas_right);
        make.bottom.equalTo(self.bottomView.mas_bottom);
        make.height.mas_offset(1.0f);
    }];
}
- (void)setLearningInfo:(MasterLearningInfoListRequestItem_Body_LearningInfoList *)learningInfo {
    _learningInfo = learningInfo;
    self.nameLabel.text = _learningInfo.realname;
    self.studyLabel.text = [NSString stringWithFormat:@"%@ | %@",_learningInfo.unit,_learningInfo.studyname];
    self.totalLabel.text = _learningInfo.totalscore;
    self.leadLabel.text = _learningInfo.leadscore;
    self.expandLabel.text = _learningInfo.expandscore;
    self.isChooseBool = _learningInfo.isChoose.boolValue;
}
@end
