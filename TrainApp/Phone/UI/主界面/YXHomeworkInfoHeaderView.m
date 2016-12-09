//
//  YXHomeworkInfoHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/4.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHomeworkInfoHeaderView.h"
#import "YXHomeworkInfoRequest.h"
@interface YXHomeworkInfoHeaderView()
{
    UILabel *_scoreLabel;//成绩
    UILabel *_pointLabel;//分数
    UILabel *_endDateLabel;//结束日期
    UILabel *_finishedLabel;//作业状态
    UIImageView *_finishedImageView;
    UILabel *_descriptionLabel;
    UIScrollView *_scrollView;
    
    UIImageView *_firstImageView;//第一个状态
    UIImageView *_secondImageView;//第二个状态
    NSTextAttachment *_textAttachment;

}
@end


@implementation YXHomeworkInfoHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _textAttachment= [[NSTextAttachment alloc] init];
        [self setupUI];
        [self layoutInterface];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(YXTrainCornerRadii, YXTrainCornerRadii)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;    
    
    _scoreLabel = [[UILabel alloc] init];
    _scoreLabel.textColor = [UIColor colorWithHexString:@"334466"];
    _scoreLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    _scoreLabel.text = @"成绩";
    [self addSubview:_scoreLabel];
    
    _pointLabel = [[UILabel alloc] init];
    _pointLabel.font = [UIFont fontWithName:YXFontMetro_Medium size:36];
    _pointLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    _pointLabel.text = @"未批改";
    _pointLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_pointLabel];
    
    _endDateLabel = [[UILabel alloc] init];
    _endDateLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    _endDateLabel.font = [UIFont systemFontOfSize:11.0f];
    _endDateLabel.textAlignment = NSTextAlignmentLeft;
    _endDateLabel.text = @"          ";
    [self addSubview:_endDateLabel];
    
    _finishedLabel = [[UILabel alloc] init];
    _finishedLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    _finishedLabel.font = [UIFont systemFontOfSize:11.0f];
    _finishedLabel.textAlignment = NSTextAlignmentLeft;
    _finishedLabel.text = @"            ";
    [self addSubview:_finishedLabel];
    
    _finishedImageView = [[UIImageView alloc] init];
    _finishedImageView.hidden = YES;
    _finishedImageView.image = [UIImage imageNamed:@"作业详情里面的-已完成标签"];
    [self addSubview:_finishedImageView];
    
    _firstImageView = [[UIImageView alloc] init];
    [self addSubview:_firstImageView];
    
    _secondImageView = [[UIImageView alloc] init];
    [self addSubview:_secondImageView];
    
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
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.numberOfLines = 0;
    [_scrollView addSubview:_descriptionLabel];

}

- (void)layoutInterface{
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(24.5f);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [_pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scoreLabel.mas_bottom).offset(6.0f);
        make.centerX.equalTo(self.mas_centerX);
    }];

    [_endDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pointLabel.mas_bottom).offset(16.0f);
        make.centerX.equalTo(self.mas_centerX);
    }];

    [_finishedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_endDateLabel.mas_bottom).offset(6.0f);
        make.left.equalTo(_endDateLabel.mas_left);
    }];

    [_firstImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_pointLabel.mas_right).offset(6.0f);
        make.centerY.equalTo(_pointLabel.mas_centerY);
        make.width.height.mas_offset(20.0f);
    }];

    [_secondImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_pointLabel.mas_right).offset(6.0f + 6.0f + 20.0f);
        make.centerY.equalTo(_pointLabel.mas_centerY);
        make.width.height.mas_offset(20.0f);
    }];
    
    [_finishedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_finishedLabel.mas_left).offset(80.0f);
        make.top.equalTo(_firstImageView.mas_bottom).offset(36.0f);//动态调整 10 标注不同
        make.width.height.mas_offset(45.0f);
    }];
    
    UILabel *label = [self viewWithTag:1001];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(18.0f);
        make.left.equalTo(self.mas_left).offset(10.0f);
        make.right.equalTo(self.mas_right).offset(-10.0f);
        make.height.mas_offset(80.0f);
    }];
    
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_top);
        make.left.equalTo(self.mas_left).offset(25.0f);
        make.right.equalTo(self.mas_right).offset(-25.0f);
    }];

}

#pragma mark - data
- (void)setBody:(YXHomeworkInfoRequestItem_Body *)body{
    _body = body;
    if(!_body.score.boolValue){
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:@" "];
        _textAttachment.image = [UIImage imageNamed:@"未批改"];
        _textAttachment.bounds = CGRectMake(0, -3.0f, 105.0f, 28.0f);
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:_textAttachment];
        [attr appendAttributedString:attrStringWithImage];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@" "];
        [attr appendAttributedString:attrString];
        _pointLabel.attributedText = attr;
    }else{
        if ([YXTrainManager sharedInstance].isBeijingProject) {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:@" "];
            if (_body.score.integerValue < 60.0f) {
                _textAttachment.image = [UIImage imageNamed:@"未合格"];
            }else {
                _textAttachment.image = [UIImage imageNamed:@"已合格"];
            }
            _textAttachment.bounds = CGRectMake(0, -3.0f, 105.0f, 28.0f);
            NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:_textAttachment];
            [attr appendAttributedString:attrStringWithImage];
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@" "];
            [attr appendAttributedString:attrString];
            _pointLabel.attributedText = attr;
        }else {
            _pointLabel.attributedText = [self totalScoreStringWithScore:_body.score];
        }
        _pointLabel.attributedText = [self totalScoreStringWithScore:_body.score];

    }
    
    _endDateLabel.text = [NSString stringWithFormat:@"截止日期  %@",_body.endDate?:@"无"];
    _finishedLabel.text = [NSString stringWithFormat:@"作业状态  %@",[_body.isFinished boolValue]?@"已完成":@"未完成"];
    _finishedImageView.hidden = ![_body.isFinished boolValue];
    _descriptionLabel.attributedText = [self descriptionStringWithDesc:_body.depiction ?: @" "];
    [self layoutInterface:[_body.recommend boolValue] withIsmyrec:[_body.ismyrec boolValue]];
    _scrollView.contentSize = [self scrollViewContentSizeWithDescription:_body.depiction ?: @" "];
}

- (CGSize)scrollViewContentSizeWithDescription:(NSString*)desc{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    CGRect rect = [desc boundingRectWithSize:CGSizeMake(kScreenWidth - 50.0f, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"334466"],NSParagraphStyleAttributeName:paragraphStyle} context:NULL];
    return rect.size;
}

- (NSMutableAttributedString *)descriptionStringWithDesc:(NSString *)desc{
    NSRange range = NSMakeRange(0, desc.length);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:desc];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"334466"],NSParagraphStyleAttributeName:paragraphStyle} range:range];
    return attributedString;
}

- (NSMutableAttributedString *)totalScoreStringWithScore:(NSString *)score{
    _textAttachment.image = [UIImage imageNamed:@"成绩详情页面的分"];
    _textAttachment.bounds = CGRectMake(0, -6.0f, 34.0f, 34.0f);
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:_textAttachment];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:score];
    [attr appendAttributedString:attrStringWithImage];
    return attr;
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
