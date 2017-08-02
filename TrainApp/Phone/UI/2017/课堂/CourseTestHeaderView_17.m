//
//  CourseTestHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseTestHeaderView_17.h"
@interface CourseTestHeaderView_17 ()
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation CourseTestHeaderView_17
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor =[UIColor whiteColor];
        self.frame = [UIScreen mainScreen].bounds;
        [self layoutIfNeeded];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self);
        }];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - set 
- (void)setQuestion:(CourseGetQuizesRequest_17Item_Result_Questions *)question {
    if (!question) {
        return;
    }
    _question = question;
    if (_question.question.types.integerValue == 1) {
        self.typeLabel.text = @"单选题";
    }else if (_question.question.types.integerValue == 2){
        self.typeLabel.text = @"多选题";
    }else {
        self.typeLabel.text = @"判断题";
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_question.question.title?:@""];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_question.question.title length])];
    self.questionLabel.attributedText = attributedString;
}
- (void)setNumberInteger:(NSInteger)numberInteger {
    _numberInteger = numberInteger;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld.",_numberInteger + 1];
}
#pragma mark - setupUI
- (void)setupUI {
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.textColor = [UIColor colorWithHexString:@"334455"];
    self.typeLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:self.typeLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.contentView addSubview:self.lineView];
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.font = [UIFont systemFontOfSize:13.0f];
    self.numberLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.numberLabel];
    
    self.questionLabel = [[UILabel alloc] init];
    self.questionLabel.font = [UIFont systemFontOfSize:13.0f];
    self.questionLabel.numberOfLines = 0;
    self.questionLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.questionLabel];
    
}
- (void)setupLayout {
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
         make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.top.equalTo(self.contentView.mas_top);
        make.height.mas_offset(40.0f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.typeLabel.mas_bottom);
        make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel.mas_left);
        make.top.equalTo(self.lineView.mas_top).offset(18.0f);
    }];
    
    [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberLabel.mas_right).offset(8.0f);
        make.top.equalTo(self.numberLabel.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-11.0f);
    }];
}
@end
