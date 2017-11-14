//
//  BeijingHomeworkInfoView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/22.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingHomeworkInfoView.h"
@interface BeijingHomeworkInfoView ()
@property (nonatomic, strong) UILabel *scoreLabel;//成绩
@property (nonatomic, strong) UILabel *pointLabel;//分数
@property (nonatomic, strong) UILabel *endDateLabel;//结束日期
@property (nonatomic, strong) UILabel *finishedLabel;//作业状态
@property (nonatomic, strong) UIImageView *finishedImageView;
@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) UIImageView *firstImageView;//第一个状态
@property (nonatomic, strong) UIImageView *secondImageView;//第二个状态
@property (nonatomic, strong) NSTextAttachment *textAttachment;
@end
@implementation BeijingHomeworkInfoView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.scoreLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreLabel.text = @"成绩";
    [self addSubview:self.scoreLabel];
    
    self.pointLabel = [[UILabel alloc] init];
    self.pointLabel.font = [UIFont systemFontOfSize:24.0f];
    self.pointLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    self.pointLabel.text = @"未批改";
    self.pointLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.pointLabel];
    
    self.endDateLabel = [[UILabel alloc] init];
    self.endDateLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.endDateLabel.font = [UIFont systemFontOfSize:11.0f];
    self.endDateLabel.textAlignment = NSTextAlignmentLeft;
    self.endDateLabel.text = @"          ";
    [self addSubview:self.endDateLabel];
    
    self.finishedLabel = [[UILabel alloc] init];
    self.finishedLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.finishedLabel.font = [UIFont systemFontOfSize:11.0f];
    self.finishedLabel.textAlignment = NSTextAlignmentLeft;
    self.finishedLabel.text = @"            ";
    [self addSubview:self.finishedLabel];
    
    self.finishedImageView = [[UIImageView alloc] init];
    self.finishedImageView.hidden = YES;
    self.finishedImageView.image = [UIImage imageNamed:@"作业详情里面的-已完成标签"];
    [self addSubview:self.finishedImageView];
    
    self.firstImageView = [[UIImageView alloc] init];
    [self addSubview:self.firstImageView];
    
    self.secondImageView = [[UIImageView alloc] init];
    [self addSubview:self.secondImageView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(183.0f);
        make.height.mas_offset(0.5f);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text = @"    作业要求    ";
    titleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    titleLabel.tag = 1001;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
    }];
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.numberOfLines = 0;
    [self addSubview:self.descriptionLabel];
}

- (void)setupLayout {
    [self.scoreLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(24.5f);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.pointLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_scoreLabel.mas_bottom).offset(6.0f);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.endDateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_pointLabel.mas_bottom).offset(16.0f);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.finishedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_endDateLabel.mas_bottom).offset(6.0f);
        make.left.equalTo(self->_endDateLabel.mas_left);
    }];
    
    [self.firstImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_pointLabel.mas_right).offset(6.0f);
        make.centerY.equalTo(self->_pointLabel.mas_centerY);
        make.width.height.mas_offset(20.0f);
    }];
    
    [self.secondImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_pointLabel.mas_right).offset(6.0f + 6.0f + 20.0f);
        make.centerY.equalTo(self->_pointLabel.mas_centerY);
        make.width.height.mas_offset(20.0f);
    }];
    
    [self.finishedImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_finishedLabel.mas_left).offset(80.0f);
        make.top.equalTo(self->_firstImageView.mas_bottom).offset(36.0f);//动态调整 10 标注不同
        make.width.height.mas_offset(45.0f);
    }];
    
    UILabel *label = [self viewWithTag:1001];
    [_descriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(18.0f);
        make.left.equalTo(self.mas_left).offset(25.0f);
        make.right.equalTo(self.mas_right).offset(-25.0f);
    }];
}
#pragma mark - data
- (void)setBody:(YXHomeworkInfoRequestItem_Body *)body{
    _body = body;
    if ([_body.isMarked isEqualToString:@"0"]) {
        self.pointLabel.text = @"未批改";
        self.pointLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    }else if(_body.score.integerValue >= 0 && _body.score.integerValue <= 59){
        self.pointLabel.text = @"未合格";
        self.pointLabel.textColor = [UIColor colorWithHexString:@"eba180"];
        
    }else if(_body.score.integerValue >= 60 && _body.score.integerValue <= 75){
        self.pointLabel.text = @"合格";
        self.pointLabel.textColor = [UIColor colorWithHexString:@"eac77b"];
        
    }else if(_body.score.integerValue >= 76 && _body.score.integerValue <= 85) {
        self.pointLabel.text = @"良好";
        self.pointLabel.textColor = [UIColor colorWithHexString:@"7ab1e9"];
        
    }else if(_body.score.integerValue >= 86 && _body.score.integerValue <= 100) {
        self.pointLabel.text = @"优秀";
        self.pointLabel.textColor = [UIColor colorWithHexString:@"7ab1e9"];
    }
    self.endDateLabel.text = [NSString stringWithFormat:@"截止日期  %@",_body.endDate?:@"无"];
    self.finishedLabel.text = [NSString stringWithFormat:@"作业状态  %@",[_body.isFinished boolValue]?@"已完成":@"未完成"];
    self.finishedImageView.hidden = ![_body.isFinished boolValue];
    self.descriptionLabel.attributedText = [self descriptionStringWithDesc:_body.depiction ?: @" "];
    [self layoutInterface:[_body.recommend boolValue] withIsmyrec:[_body.ismyrec boolValue]];
}
- (NSMutableAttributedString *)descriptionStringWithDesc:(NSString *)desc{
    NSRange range = NSMakeRange(0, desc.length);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:desc];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"334466"],NSParagraphStyleAttributeName:paragraphStyle} range:range];
    return attributedString;
}
- (void)layoutInterface:(BOOL)recommendBool withIsmyrec:(BOOL)ismyrecBool{
    if (recommendBool && ismyrecBool) {//全部都有
        _firstImageView.image = [UIImage imageNamed:@"优标签"];
        _secondImageView.image = [UIImage imageNamed:@"荐标签"];
    }
    else{
        if (recommendBool){//只有优
            _firstImageView.image = [UIImage imageNamed:@"优标签"];
        }
        if (ismyrecBool) {//只有荐
            _firstImageView.image = [UIImage imageNamed:@"荐标签"];
        }
    }
}

@end
