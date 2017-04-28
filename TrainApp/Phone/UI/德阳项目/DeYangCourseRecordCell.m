//
//  DeYangCourseRecordCell.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "DeYangCourseRecordCell.h"
@interface DeYangCourseRecordCell ()
@property (nonatomic, strong) UIImageView *courseImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *recordLabel;
@property (nonatomic, strong) UILabel *quizzesLabel;

@property (nonatomic, strong) UILabel *statsLabel;

@end
@implementation DeYangCourseRecordCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIView *selectedBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    self.courseImageView = [[UIImageView alloc]init];
    self.courseImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.courseImageView.clipsToBounds = YES;
    self.courseImageView.layer.cornerRadius = YXTrainCornerRadii;
    [self.contentView addSubview:self.courseImageView];
    [self.courseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(125);
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.courseImageView.mas_left);
        make.right.mas_equalTo(self.courseImageView.mas_right);
        make.top.mas_equalTo(self.courseImageView.mas_bottom).mas_offset(11);
    }];
    
    UIView *recordBgView = [[UIView alloc]init];
    recordBgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.38];
    recordBgView.clipsToBounds = YES;
    recordBgView.layer.cornerRadius = YXTrainCornerRadii;
    [self.courseImageView addSubview:recordBgView];
    [recordBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(120);
    }];
    
    UIImageView *historyImageView = [[UIImageView alloc]init];
    historyImageView.image = [UIImage imageNamed:@"看课记录时间icon"];
    [recordBgView addSubview:historyImageView];
    [historyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.mas_equalTo(5);
    }];
    
    self.recordLabel = [[UILabel alloc]init];
    self.recordLabel.font = [UIFont systemFontOfSize:11];
    self.recordLabel.textColor = [UIColor whiteColor];
    [recordBgView addSubview:self.recordLabel];
    [self.recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(historyImageView.mas_right).mas_offset(5);
        make.right.mas_equalTo(-3);
    }];
    
    self.quizzesLabel = [[UILabel alloc]init];
    self.quizzesLabel.text = @"[随堂练] 已答对0个 / 共2个";
    self.quizzesLabel.font = [UIFont systemFontOfSize:11];
    self.quizzesLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    self.quizzesLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.quizzesLabel];
    [self.quizzesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8.0f);
        make.right.mas_equalTo(-10);
    }];
    
    
    self.statsLabel = [[UILabel alloc] init];
    self.statsLabel.font = [UIFont systemFontOfSize:10.0f];
    self.statsLabel.textColor = [UIColor whiteColor];
    self.statsLabel.clipsToBounds = YES;
    self.statsLabel.layer.cornerRadius = 3.0f;
    self.statsLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.statsLabel];
    [self.statsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.courseImageView.mas_right).offset(5.0f);
        make.bottom.equalTo(self.courseImageView.mas_bottom).offset(-5.0f);
        make.size.mas_offset(CGSizeMake(29.0f, 15.0f));
    }];
}

- (void)setCourse:(YXCourseRecordRequestItem_body_module_course *)course{
    _course = course;
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:course.course_img] placeholderImage:[UIImage imageNamed:@"默认图片"]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:course.course_title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [course.course_title length])];
    self.titleLabel.attributedText = attributedString;
    
    int second = course.record.intValue;
    int minute = second / 60;
    int hour = minute / 60;
    minute = minute % 60;
    second = second % 60;
    self.recordLabel.text = [NSString stringWithFormat:@"已观看 %02d:%02d:%02d", hour, minute, second];
    self.quizzesLabel.text = [NSString stringWithFormat:@"[随堂练] 已答对%@个 / 共%@个",_course.quiz.finish,_course.quiz.total];
    
    if (_course.type.integerValue == 101) {
        self.statsLabel.text = @"选修";
        self.statsLabel.backgroundColor = [UIColor colorWithHexString:@"efa280"];
    }else {
        self.statsLabel.text = @"必修";
        self.statsLabel.backgroundColor = [UIColor colorWithHexString:@"65aee7"];
    }
}

@end
