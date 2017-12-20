//
//  MasterCourseListCell_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/4.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterCourseListCell_17.h"
@interface MasterCourseListCell_17 ()
@property (nonatomic, strong) UIImageView *courseImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *segmentLabel;
@property (nonatomic, strong) UILabel *studyLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *recordBgView;
@property (nonatomic, strong) UILabel *recordLabel;
@end
@implementation MasterCourseListCell_17

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.recordBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.38];
}
#pragma mark - setupUI
- (void)setupUI{
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    self.courseImageView = [[UIImageView alloc]init];
    self.courseImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.courseImageView.clipsToBounds = YES;
    self.courseImageView.layer.cornerRadius = YXTrainCornerRadii;
    [self.contentView addSubview:self.courseImageView];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.titleLabel];
    
    self.segmentLabel = [[UILabel alloc]init];
    self.segmentLabel.font = [UIFont systemFontOfSize:11];
    self.segmentLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.segmentLabel];
    
    self.studyLabel = [[UILabel alloc] init];
    self.studyLabel.font = [UIFont systemFontOfSize:11.0f];
    self.studyLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.studyLabel];
    
    self.recordBgView = [[UIView alloc]init];
    self.recordBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    self.recordBgView.clipsToBounds = YES;
    self.recordBgView.layer.cornerRadius = YXTrainCornerRadii;
    [self.courseImageView addSubview:self.recordBgView];
    
    self.recordLabel = [[UILabel alloc]init];
    self.recordLabel.font = [UIFont systemFontOfSize:11.0f];
    self.recordLabel.numberOfLines = 1;
    self.recordLabel.textColor = [UIColor whiteColor];
    [self.recordBgView addSubview:self.recordLabel];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:self.lineView];
}
- (void)setupLayout {
    [self.courseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(112, 84));
    }];
    
    [self.recordBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.courseImageView.mas_centerX);
        make.height.mas_equalTo(20.0f);
        make.width.equalTo(self.courseImageView.mas_width);
        make.bottom.equalTo(self.courseImageView.mas_bottom);
    }];
    
    [self.recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.recordBgView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.courseImageView.mas_right).mas_offset(15);
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-10);
    }];
    
    [self.segmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(9.0f);
    }];
    
    [self.studyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.segmentLabel.mas_right).offset(10.0f);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(9.0f);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.courseImageView.mas_left);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1.0f);
    }];
}

- (void)setCourse:(CourseListRequest_17Item_Objs *)course {
    _course = course;
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:_course.pic] placeholderImage:[UIImage imageNamed:@"默认图片"]];
    self.titleLabel.text = _course.name;
    self.segmentLabel.text = [NSString stringWithFormat:@"学段: %@",_course.segmentName];
    self.studyLabel.text = [NSString stringWithFormat:@"学科: %@",_course.studyName];
    int second = course.timeLengthSec.intValue;
    if (second == 0) {
        self.recordBgView.hidden = YES;
        self.recordLabel.text = @"未观看";
    }else{
        self.recordBgView.hidden = NO;
        int minute = second / 60;
        int hour = minute / 60;
        minute = minute % 60;
        second = second % 60;
        self.recordLabel.text = [NSString stringWithFormat:@"已观看 %02d:%02d:%02d", hour, minute, second];
    }
}
@end
