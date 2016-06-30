//
//  YXCourseRecordCell.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/30.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCourseRecordCell.h"

@interface YXCourseRecordCell()
@property (nonatomic, strong) UIImageView *courseImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *recordLabel;
@end

@implementation YXCourseRecordCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.courseImageView = [[UIImageView alloc]init];
    self.courseImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.courseImageView.clipsToBounds = YES;
    self.courseImageView.layer.cornerRadius = 2;
    [self.contentView addSubview:self.courseImageView];
    [self.courseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-6);
        make.height.mas_equalTo(125);
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.courseImageView.mas_left);
        make.right.mas_equalTo(self.courseImageView.mas_right);
        make.top.mas_equalTo(self.courseImageView.mas_bottom).mas_offset(11);
    }];
    
    UIView *recordBgView = [[UIView alloc]init];
    recordBgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    recordBgView.clipsToBounds = YES;
    recordBgView.layer.cornerRadius = 2;
    [self.courseImageView addSubview:recordBgView];
    [recordBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(-14);
        make.center.mas_equalTo(0);
        make.height.mas_equalTo(36);
    }];
    self.recordLabel = [[UILabel alloc]init];
    self.recordLabel.font = [UIFont systemFontOfSize:11];
    self.recordLabel.textColor = [UIColor whiteColor];
    [recordBgView addSubview:self.recordLabel];
    [self.recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(11);
    }];
    UIImageView *historyImageView = [[UIImageView alloc]init];
    historyImageView.backgroundColor = [UIColor redColor];
    [recordBgView addSubview:historyImageView];
    [historyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.mas_equalTo(self.recordLabel.mas_left).mas_offset(-3);
    }];
}

- (void)setCourse:(YXCourseRecordRequestItem_body_module_course *)course{
    _course = course;
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:course.course_img]];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:course.course_title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [course.course_title length])];
    self.titleLabel.attributedText = attributedString;
    
    int second = course.record.intValue;
    int minute = second / 60;
    int hour = minute / 60;
    minute = minute % 60;
    second = second % 60;
    self.recordLabel.text = [NSString stringWithFormat:@"已观看 %02d:%02d:%02d", hour, minute, second];
}

- (void)setIsFirst:(BOOL)isFirst{
    _isFirst = isFirst;
    if (isFirst) {
        [self.courseImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-6);
            make.height.mas_equalTo(125);
        }];
    }else{
        [self.courseImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(6);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(125);
        }];
    }
}

@end
