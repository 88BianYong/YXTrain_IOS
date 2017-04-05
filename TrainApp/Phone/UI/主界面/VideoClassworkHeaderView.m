//
//  VideoClassworkHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/28.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoClassworkHeaderView.h"
@interface VideoClassworkHeaderView ()
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *stemLabel;
@end
@implementation VideoClassworkHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        [self layoutIfNeeded];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self);
    }];
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.layer.cornerRadius = YXTrainCornerRadii;
    self.typeLabel.clipsToBounds = YES;
    self.typeLabel.text = @"单选题";
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.backgroundColor = [UIColor colorWithHexString:@"65aee7"];
    self.typeLabel.textColor = [UIColor whiteColor];
    self.typeLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.contentView addSubview:self.typeLabel];
    
    self.stemLabel = [[UILabel alloc] init];
    self.stemLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    self.stemLabel.numberOfLines = 0;
    self.stemLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.stemLabel];
}
- (void)setupLayout {
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(18.0f);
        make.top.equalTo(self.contentView.mas_top).offset(20.0f);
        make.size.mas_offset(CGSizeMake(55.0f, 18.0f));
    }];
    
    [self.stemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel.mas_right).offset(12.0f);
        make.top.equalTo(self.contentView.mas_top).offset(18.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-11.0f);
    }];
}
- (void)setQuestion:(YXVideoQuestionsRequestItem_Result_Questions_Question *)question {
    if (!question) {
        return;
    }
    _question = question;
    if (_question.types.integerValue == 1) {
        self.typeLabel.text = @"单选题";
    }else if (_question.types.integerValue == 2){
        self.typeLabel.text = @"多选题";
    }else {
        self.typeLabel.text = @"判断题";
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_question.title];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_question.title length])];
    self.stemLabel.attributedText = attributedString;
}
@end
