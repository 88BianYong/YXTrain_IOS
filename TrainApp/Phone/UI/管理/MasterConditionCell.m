//
//  MasterConditionCell.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//
#import "MasterConditionCell.h"
@implementation MasterConditionRoundView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setupUI {
    self.outsideRoundView = [[UIView alloc] init];
    self.outsideRoundView.layer.cornerRadius = 10.0f;
    self.outsideRoundView.layer.borderWidth = 1.0f;
    self.outsideRoundView.layer.borderColor = [UIColor colorWithHexString:@"dfe2e6"].CGColor;
    [self addSubview:self.outsideRoundView];
    
    self.insideRoundView = [[UIView alloc] init];
    self.insideRoundView.layer.cornerRadius = 4.0f;
    self.insideRoundView.backgroundColor = [UIColor colorWithHexString:@"0e7ac9"];
    self.insideRoundView.hidden = YES;
    [self.outsideRoundView addSubview:self.insideRoundView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"未参加";
    self.nameLabel.font = [UIFont systemFontOfSize:13.0f];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self addSubview:self.nameLabel];
}
- (void)setupLayout {
    [self.outsideRoundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_offset(CGSizeMake(20.0f, 20.0f));
    }];
    [self.insideRoundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.outsideRoundView);
        make.size.mas_offset(CGSizeMake(8.0f, 8.0f));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.outsideRoundView.mas_right).offset(9.0f);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right);
    }];
}
- (void)setIsChooseBool:(BOOL)isChooseBool {
    _isChooseBool = isChooseBool;
    if (_isChooseBool) {
        self.outsideRoundView.layer.cornerRadius = 10.0f;
        self.outsideRoundView.layer.borderWidth = 2.0f;
        self.outsideRoundView.layer.borderColor = [UIColor colorWithHexString:@"0e7ac9"].CGColor;
        self.insideRoundView.hidden = NO;
    }else {
        self.outsideRoundView.layer.cornerRadius = 10.0f;
        self.outsideRoundView.layer.borderWidth = 1.0f;
        self.outsideRoundView.layer.borderColor = [UIColor colorWithHexString:@"dfe2e6"].CGColor;
        self.insideRoundView.hidden = YES;
    }
}
@end
@interface MasterConditionCell ()
@property (nonatomic, strong) UIView *containerView;
@end
@implementation MasterConditionCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI 
- (void)setupUI {
    self.containerView = [[UIView alloc] init];
    [self.contentView addSubview:self.containerView];
    self.leftRoundView = [[MasterConditionRoundView alloc] init];
    self.leftRoundView.tag = 1001;
    [self.containerView addSubview:self.leftRoundView];
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    [self.leftRoundView addGestureRecognizer:leftTap];
    self.rightRoundView = [[MasterConditionRoundView alloc] init];
    self.rightRoundView.tag = 1002;
    [self.containerView addSubview:self.rightRoundView];
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    [self.rightRoundView addGestureRecognizer:rightTap];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(70.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-70.0f);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
}
- (void)setupLayout {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.height.mas_offset(75.0f);
        make.width.mas_offset(171.0f);
    }];
    [self.leftRoundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.height.mas_offset(75.0f);
        make.centerY.equalTo(self.containerView.mas_centerY);
    }];
    [self.rightRoundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftRoundView.mas_left).offset(104.0f);
        make.height.mas_offset(75.0f);
        make.centerY.equalTo(self.containerView.mas_centerY);
    }];
}
- (void)setChooseInteger:(NSInteger)chooseInteger {
    _chooseInteger = chooseInteger;
    if (_chooseInteger == 0) {
        self.leftRoundView.isChooseBool = NO;
        self.rightRoundView.isChooseBool = NO;
    }
}
#pragma mark - tap Action
- (void)tapAction:(UITapGestureRecognizer *)sender {
    if (sender.view.tag == 1001) {
        self.leftRoundView.isChooseBool = YES;
        self.rightRoundView.isChooseBool = NO;
        self.chooseInteger = 1;
    }else {
        self.leftRoundView.isChooseBool = NO;
        self.rightRoundView.isChooseBool = YES;
        self.chooseInteger = 2;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
