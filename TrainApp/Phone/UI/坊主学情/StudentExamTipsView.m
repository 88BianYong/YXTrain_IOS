//
//  StudentExamTipsView.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "StudentExamTipsView.h"
@interface StudentExamTipsView ()
@property (nonatomic, strong) UILabel *promptLabel;
@end
@implementation StudentExamTipsView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0x00/255.0f green:0x11/255.0f blue:0x20/255.0f alpha:0.8];
        self.layer.cornerRadius = 3.0f;
        self.layer.shadowColor = [UIColor colorWithHexString:@"00204b"].CGColor;
        self.layer.shadowOffset = CGSizeMake(2.5,2.5);
        self.layer.shadowOpacity = 0.4;
        self.layer.shadowRadius = 2.5f;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.promptLabel = [[UILabel alloc] init];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7.0f;
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"作为本次培训中的管理者,您不需要进行学员内容的学习,此部分展示仅为方便您了解学员学习内容,进仅需要进行该项目指导即可" attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
    self.promptLabel.attributedText = attString;
    self.promptLabel.font = [UIFont systemFontOfSize:12.0f];
    self.promptLabel.textColor = [UIColor whiteColor];
    self.promptLabel.numberOfLines = 0;
    [self addSubview:self.promptLabel];
    
    self.openCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.openCloseButton setImage:[UIImage imageNamed:@"提示收起后的展开按钮"] forState:UIControlStateNormal];
    [self.openCloseButton setImage:[UIImage imageNamed:@"提示展开后的收起按钮"] forState:UIControlStateSelected];
    WEAK_SELF
    [[self.openCloseButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        self.openCloseButton.selected = !self.openCloseButton.selected;
        BLOCK_EXEC(self.studentExamTipsOpenCloseBlock,self.openCloseButton);
    }];
    self.openCloseButton.selected = YES;
    [self addSubview:self.openCloseButton];
}
- (void)setupLayout {
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(21.0f);
        make.top.equalTo(self.mas_top).offset(21.0f);
        make.right.equalTo(self.openCloseButton.mas_left).offset(-4.0f);
        make.bottom.equalTo(self.mas_bottom).offset(-21.0f);
    }];
    [self.openCloseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_offset(44.0f);
    }];
}
@end
