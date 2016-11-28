//
//  BeijingExamGenreExplainHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingExamGenreExplainHeaderView.h"
@interface BeijingExamGenreExplainHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@end
@implementation BeijingExamGenreExplainHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"活动";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.text = @"至少需要敌对作业";
    self.detailLabel.textColor = [UIColor colorWithHexString:@"505f84"];
    self.detailLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.contentView addSubview:self.detailLabel];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:11.0f];
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    self.contentLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    self.contentLabel.text = @"已参加0ge";
    [self.contentView addSubview:self.contentLabel];
}

- (void)setupLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.bottom.equalTo(self.detailLabel.mas_top).offset(-5.0f);
        make.top.equalTo(self.contentView.mas_top).offset(5.0f);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}
- (void)setToolExamineVo:(BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList *)toolExamineVo {
    _toolExamineVo = toolExamineVo;
    self.titleLabel.text = _toolExamineVo.name;
    if (_toolExamineVo.toolid.integerValue == 202) {
        self.detailLabel.text = [NSString stringWithFormat:@"至少需要参加%@个活动包",_toolExamineVo.totalnum];
        self.contentLabel.text = [NSString stringWithFormat:@"已参加了%@个",_toolExamineVo.finishnum];
        self.detailLabel.textColor = [UIColor colorWithHexString:@"505f84"];
    }else if (_toolExamineVo.toolid.integerValue == 205) {
        self.detailLabel.text = [NSString stringWithFormat:@"需要提交%@份教学资源包",_toolExamineVo.totalnum];
        self.contentLabel.text = [NSString stringWithFormat:@"已提交了%@个",_toolExamineVo.finishnum];
        self.detailLabel.textColor = [UIColor colorWithHexString:@"505f84"];

    }else if (_toolExamineVo.toolid.integerValue == 206) {
        self.detailLabel.text = @"(需要线下完成)";
        self.contentLabel.text = _toolExamineVo.userscore.integerValue > 0 ? @"合格" : @"不合格";
        self.detailLabel.textColor = [UIColor colorWithHexString:@"bbc2c9"];

    }
    
}
@end
