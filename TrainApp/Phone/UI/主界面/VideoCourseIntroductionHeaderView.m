//
//  VideoCourseIntroductionHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoCourseIntroductionHeaderView.h"
@interface VideoCourseIntroductionHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@end
@implementation VideoCourseIntroductionHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.textColor = [UIColor redColor];
    self.scoreLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:self.scoreLabel];
}
- (void)setupLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(25.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-25.0f);
        make.top.equalTo(self.contentView.mas_top).offset(25.0f);
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(25.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-25.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-11.0f);
    }];
}
- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_titleString?:@""];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7.0f;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_titleString?:@"" length])];
    self.titleLabel.attributedText = attributedString;
}
- (void)setScore:(YXCourseDetailItem_score *)score {
    _score = score;
    
    NSMutableAttributedString *scoreAttributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"评分: %0.1f",_score.avr.floatValue]];
    [scoreAttributed addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"a1a7ae"]} range:NSMakeRange(0,3)];
    self.scoreLabel.attributedText = scoreAttributed;
}
@end
