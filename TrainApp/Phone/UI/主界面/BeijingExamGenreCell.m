//
//  BeijingExamGenreCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingExamGenreCell.h"
@interface BeijingExamGenreCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *explainButton;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) BeijingExamGenreButtonBlock buttonBlock;
@end
@implementation BeijingExamGenreCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    self.titleLabel.text = @"课程案例";
    [self.contentView addSubview:self.titleLabel];
    
    self.explainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.explainButton setImage:[UIImage imageNamed:@"解释说明图标正常态"]
                        forState:UIControlStateNormal];
    [self.explainButton setImage:[UIImage imageNamed:@"解释说明图标点击态"]
                        forState:UIControlStateHighlighted];
    [self.explainButton addTarget:self action:@selector(explainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.explainButton];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:11.0f];
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    self.contentLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    [self.contentView addSubview:self.contentLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e7e8ec"];
    [self.contentView addSubview:self.lineView];
}

- (void)setupLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.explainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(7.0f);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.size.mas_offset(CGSizeMake(19.0f, 19.0f));
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.greaterThanOrEqualTo(self.explainButton.mas_right).offset(10.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(1.0f / [UIScreen mainScreen].scale);
    }];
}

- (NSAttributedString *)formatContent:(NSString *)selectedTime Study:(NSString *)studyTime {
    selectedTime = [NSString stringWithFormat:@"已选了%@学时 /",selectedTime];
    studyTime = [NSString stringWithFormat:@"已学习%@学时",studyTime];
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

- (void)setBeijingExamGenreButtonBlock:(BeijingExamGenreButtonBlock)block {
    self.buttonBlock = block;
}

- (void)setToolExamineVo:(BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList *)toolExamineVo {
    _toolExamineVo = toolExamineVo;
    self.titleLabel.text = _toolExamineVo.name;
    self.explainButton.hidden = !(_toolExamineVo.toolid.integerValue == 2180 || _toolExamineVo.toolid.integerValue == 2176);
    self.contentLabel.attributedText = [self formatContent:_toolExamineVo.totalCredit Study:_toolExamineVo.totalHasCredit];
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
