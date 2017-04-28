//
//  DeYangCourseListCell.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "DeYangCourseListCell.h"
@interface DeYangCourseListCell ()
@property (nonatomic, strong) UIImageView *courseImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *recordLabel;

@property (nonatomic, strong) UILabel *quizzesLabel;
@property (nonatomic, strong) UIImageView *historyImageView;

@property (nonatomic, strong) UILabel *statsLabel;

@end
@implementation DeYangCourseListCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    }else {
        self.statsLabel.text = @"必修";
        self.statsLabel.backgroundColor = [UIColor colorWithHexString:@"65aee7"];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    self.courseImageView = [[UIImageView alloc]init];
    self.courseImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.courseImageView.clipsToBounds = YES;
    self.courseImageView.layer.cornerRadius = YXTrainCornerRadii;
    [self.contentView addSubview:self.courseImageView];
    [self.courseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(112, 84));
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.courseImageView.mas_right).mas_offset(15);
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-20);
    }];
    self.recordLabel = [[UILabel alloc]init];
    self.recordLabel.font = [UIFont systemFontOfSize:11];
    self.recordLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.recordLabel];
    [self.recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8.0f);
        make.right.mas_equalTo(-20);
    }];
    
    self.historyImageView = [[UIImageView alloc]init];
    self.historyImageView.image = [UIImage imageNamed:@"不支持"];
    self.historyImageView.hidden = YES;
    [self.contentView addSubview:self.historyImageView];
    [self.historyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.courseImageView.mas_right).mas_offset(15);
        make.centerY.mas_equalTo(self.recordLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.quizzesLabel = [[UILabel alloc]init];
    self.quizzesLabel.text = @"[随堂练] 已答对0个 / 共2个";
    self.quizzesLabel.font = [UIFont systemFontOfSize:11];
    self.quizzesLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    [self.contentView addSubview:self.quizzesLabel];
    [self.quizzesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.recordLabel.mas_left);
        make.top.mas_equalTo(self.recordLabel.mas_bottom).offset(5.0f);
        make.right.mas_equalTo(-20);
    }];

    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.courseImageView.mas_left);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
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

- (void)setCourse:(YXCourseListRequestItem_body_module_course *)course {
    _course = course;
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:course.course_img] placeholderImage:[UIImage imageNamed:@"默认图片"]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:course.course_title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:0];//调整行间距
    paragraphStyle.minimumLineHeight = 20;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [course.course_title length])];
    self.titleLabel.attributedText = attributedString;
    if (!_course.isSupportApp.boolValue) {
        [self.recordLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left).mas_offset(23);
        }];
        self.historyImageView.hidden = NO;
        self.recordLabel.text = @"暂不支持该类型课程";
        self.recordLabel.textColor = [UIColor colorWithHexString:@"cdd2d9"];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"cdd2d9"];
        self.quizzesLabel.text = @"";
    }else {
        self.historyImageView.hidden = YES;
        [self.recordLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left);
        }];
        self.recordLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
        int second = course.record.intValue;
        if (second == 0) {
            self.recordLabel.text = @"未观看";
        }else{
            int minute = second / 60;
            int hour = minute / 60;
            minute = minute % 60;
            second = second % 60;
            self.recordLabel.text = [NSString stringWithFormat:@"已观看 %02d:%02d:%02d", hour, minute, second];
        }
        self.quizzesLabel.text = [NSString stringWithFormat:@"[随堂练] 已答对%@个 / 共%@个",_course.quiz.finish,_course.quiz.total];
    }
    
    if (_course.type.integerValue == 101) {
        self.statsLabel.text = @"选修";
        self.statsLabel.backgroundColor = [UIColor colorWithHexString:@"efa280"];
    }else {
        self.statsLabel.text = @"必修";
        self.statsLabel.backgroundColor = [UIColor colorWithHexString:@"65aee7"];
    }
}



@end
