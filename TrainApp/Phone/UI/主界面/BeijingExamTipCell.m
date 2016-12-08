//
//  BeijingExamTipCell.m
//  TrainApp
//
//  Created by ZLL on 2016/12/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingExamTipCell.h"

@interface BeijingExamTipCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *explainButton;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) BeijingExamTipButtonBlock buttonBlock;
@end

@implementation BeijingExamTipCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.tipView = [[UIView alloc]init];
    self.tipView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    self.tipView.layer.cornerRadius = 2.0f;
    self.tipView.clipsToBounds = YES;
    
    self.tipLabel = [[UILabel alloc]init];
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    self.tipLabel.textColor = [UIColor colorWithHexString:@"505f84"];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    
    self.bottomView = [[UIView alloc]init];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    self.titleLabel.text = @"课程案例";

    self.explainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.explainButton setImage:[UIImage imageNamed:@"解释说明图标正常态"]
                        forState:UIControlStateNormal];
    [self.explainButton setImage:[UIImage imageNamed:@"解释说明图标点击态"]
                        forState:UIControlStateHighlighted];
    [self.explainButton addTarget:self action:@selector(explainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:11.0f];
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    self.contentLabel.textColor = [UIColor colorWithHexString:@"0067be"];

    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e7e8ec"];
}

- (void)setupLayout {
    
    [self.contentView addSubview:self.tipView];
    [self.tipView addSubview:self.tipLabel];
    [self.contentView addSubview:self.bottomView];
    [self.bottomView addSubview:self.titleLabel];
    [self.bottomView addSubview:self.explainButton];
    [self.bottomView addSubview:self.contentLabel];
    [self.contentView addSubview:self.lineView];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tipView);
    }];
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(40);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.tipView);
        make.top.equalTo(self.tipView.mas_bottom);
        make.height.mas_equalTo(70.0f);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView);
        make.centerY.equalTo(self.bottomView);
    }];
    [self.explainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(7.0f);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.size.mas_offset(CGSizeMake(19.0f, 19.0f));
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView);
        make.centerY.equalTo(self.bottomView);
        make.left.greaterThanOrEqualTo(self.explainButton.mas_right).offset(10.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bottomView);
        make.top.equalTo(self.bottomView.mas_bottom);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(1.0f / [UIScreen mainScreen].scale);
    }];
}

- (NSAttributedString *)formatContent:(NSString *)selectedTime Study:(NSString *)studyTime {
    selectedTime = [NSString stringWithFormat:@"已选%0.1f学时 /",selectedTime.doubleValue];
    studyTime = [NSString stringWithFormat:@"已学习%0.1f学时",studyTime.doubleValue];
    NSString *completeStr = [NSString stringWithFormat:@"%@%@",selectedTime,studyTime];
    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc]initWithString:completeStr];
    NSRange range = [completeStr rangeOfString:selectedTime];
    [mStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"505f84"] range:range];
    return mStr;
}

#pragma mark - buttonAction
- (void)explainButtonAction:(UIButton *)sender {
    BLOCK_EXEC(self.buttonBlock,sender);
}
- (void)setBeijingExamTipButtonBlock:(BeijingExamTipButtonBlock)block {
    self.buttonBlock = block;
}
- (void)setToolExamineVo:(BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList *)toolExamineVo {
    _toolExamineVo = toolExamineVo;
    self.titleLabel.text = _toolExamineVo.name;
    self.explainButton.hidden = !(_toolExamineVo.toolid.integerValue == 2180 || _toolExamineVo.toolid.integerValue == 2176);
    self.contentLabel.attributedText = [self formatContent:_toolExamineVo.totalCredit Study:_toolExamineVo.totalHasCredit];
}
- (void)setTipLabelContent:(NSString *)tipLabelContent {
    _tipLabelContent = tipLabelContent;
    self.tipLabel.text = tipLabelContent;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event  {
    if (CGRectContainsPoint(self.bottomView.frame, point)) {
        return [super hitTest:point withEvent:event];
    }
    return nil;
}
@end
