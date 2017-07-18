//
//  CourseListCell_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseListCell_17.h"
@interface CourseListCell_17 ()
@property (nonatomic, strong) UIImageView *courseImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *recordLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *finishLabel;

@property (nonatomic, strong) UILabel *statsLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *recordBgView;


@end
@implementation CourseListCell_17
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
    if (_course.type.integerValue == 101) {
        self.statsLabel.text = @"选修";
        self.statsLabel.backgroundColor = [UIColor colorWithHexString:@"efa280"];
        self.recordBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.38];
    }else {
        self.statsLabel.text = @"必修";
        self.statsLabel.backgroundColor = [UIColor colorWithHexString:@"65aee7"];
        self.recordBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.38];
    }
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
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];

    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.timeLabel.hidden = YES;
    [self.contentView addSubview:self.timeLabel];
    
    self.statsLabel = [[UILabel alloc] init];
    self.statsLabel.font = [UIFont systemFontOfSize:10.0f];
    self.statsLabel.textColor = [UIColor whiteColor];
    self.statsLabel.clipsToBounds = YES;
    self.statsLabel.layer.cornerRadius = 3.0f;
    self.statsLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.statsLabel];
    
    self.recordBgView = [[UIView alloc]init];
    self.recordBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.38];
    self.recordBgView.clipsToBounds = YES;
    self.recordBgView.layer.cornerRadius = YXTrainCornerRadii;
    [self.courseImageView addSubview:self.recordBgView];
    
    self.recordLabel = [[UILabel alloc]init];
    self.recordLabel.font = [UIFont systemFontOfSize:11];
    self.recordLabel.numberOfLines = 2;
    self.recordLabel.textColor = [UIColor whiteColor];
    [self.recordBgView addSubview:self.recordLabel];
    
    self.finishLabel = [[UILabel alloc] init];
    self.finishLabel.text = @"已完成";
    self.finishLabel.textColor = [UIColor colorWithHexString:@"0070c9"];
    self.finishLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.contentView addSubview:self.finishLabel];
    
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
        make.right.mas_equalTo(-20);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(9.0f);
        make.right.mas_equalTo(-20);
    }];
    
    
    [self.statsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.courseImageView.mas_left).offset(5.0f);
        make.top.equalTo(self.courseImageView.mas_top).offset(5.0f);
        make.size.mas_offset(CGSizeMake(29.0f, 15.0f));
    }];
    
    [self.finishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.bottom.equalTo(self.courseImageView.mas_bottom).offset(-10.0f);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.courseImageView.mas_left);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
}

- (void)setCourse:(CourseListRequest_17Item_Objs *)course {
    _course = course;
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:course.content.imgUrl] placeholderImage:[UIImage imageNamed:@"默认图片"]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:course.name];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:0];//调整行间距
    paragraphStyle.minimumLineHeight = 20;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [course.name length])];
    self.titleLabel.attributedText = attributedString;
    self.timeLabel.text = [NSString stringWithFormat:@"课程时长: %@",course.time];
    int second = course.timeLength.intValue;
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
    
    if (_course.type.integerValue == 101) {
        self.statsLabel.text = @"选修";
        self.statsLabel.backgroundColor = [UIColor colorWithHexString:@"efa280"];
    }else {
        self.statsLabel.text = @"必修";
        self.statsLabel.backgroundColor = [UIColor colorWithHexString:@"65aee7"];
    }
    self.finishLabel.hidden = _course.isFinish.boolValue;
}

@end
