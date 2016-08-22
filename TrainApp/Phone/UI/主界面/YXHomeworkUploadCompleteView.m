//
//  YXHomeworkUploadCompleteView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/16.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHomeworkUploadCompleteView.h"
@interface YXHomeworkUploadCompleteView()
{
    UILabel *_segmentLabel;//学段
    UILabel *_studyLabel;//学科
    UILabel *_versionLabel;//版本
    UILabel *_gradeLabel;//年级
    UILabel *_chapterLabel;//目录
    UILabel *_keywordLabel;//知识点
    UIView *_lineView;
    UIButton *_writeButton;
    UILabel *_againLabel;
    UIButton *_againButton;
}
@end

@implementation YXHomeworkUploadCompleteView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
        [self layoutInterface];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI{
    UIView *backgrounView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, [UIScreen mainScreen].bounds.size.width - 10.0f, 233.0f)];
    backgrounView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backgrounView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backgrounView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(YXTrainCornerRadii, YXTrainCornerRadii)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = backgrounView.bounds;
    maskLayer.path = maskPath.CGPath;
    backgrounView.layer.mask = maskLayer;
    
    
    
    _segmentLabel = [[UILabel alloc] init];
    [self addSubview:_segmentLabel];
    
    _studyLabel = [[UILabel alloc] init];
    [self addSubview:_studyLabel];
    
    _versionLabel = [[UILabel alloc] init];
    [self addSubview:_versionLabel];
    
    _gradeLabel = [[UILabel alloc] init];
    [self addSubview:_gradeLabel];
    
    _chapterLabel = [[UILabel alloc] init];
    [self addSubview:_chapterLabel];
    
    _keywordLabel = [[UILabel alloc] init];
    _keywordLabel.numberOfLines = 0;
    [self addSubview:_keywordLabel];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self addSubview:_lineView];
    
    _writeButton = [[UIButton alloc] init];
    [_writeButton setImage:[UIImage imageNamed:@"修改作业信息icon-正常态"] forState:UIControlStateNormal];
    [_writeButton setImage:[UIImage imageNamed:@"修改作业信息icon-点击态"] forState:UIControlStateHighlighted];
    _writeButton.tag = YXRecordVideoInterfaceStatus_Change;
    [_writeButton setTitle:@"修改作业信息" forState:UIControlStateNormal];
    [_writeButton setTitleColor:[UIColor colorWithHexString:@"a1a7ae"] forState:UIControlStateNormal];
    [_writeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10.0f, 0, 0)];
    _writeButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_writeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_writeButton];
    
    
    
    _againLabel = [[UILabel alloc] init];
    _againLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    _againLabel.font = [UIFont systemFontOfSize:12.0f];
    _againLabel.text = @"录制不满意?";
    [self addSubview:_againLabel];
    
    _againButton = [[UIButton alloc] init];
    _againButton.tag = YXRecordVideoInterfaceStatus_Record;
    [_againButton setTitle:@"重新录制" forState:UIControlStateNormal];
    [_againButton setTitleColor:[UIColor colorWithHexString:@"0070c9"] forState:UIControlStateNormal];
    [_againButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [_againButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_againButton];
}

- (void)layoutInterface{
    [_segmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(24.0f);
        make.top.equalTo(self.mas_top).offset(19.0f);
        make.right.equalTo(self.mas_centerX).offset(-10.0f);
    }];
    
    [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_segmentLabel.mas_left);
        make.width.equalTo(_segmentLabel.mas_width);
        make.top.equalTo(_segmentLabel.mas_bottom).offset(10.0f);
    }];
    
    [_chapterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_segmentLabel.mas_left);
        make.right.equalTo(self.mas_right).offset(-24.0f);
        make.top.equalTo(_versionLabel.mas_bottom).offset(10.0f);
    }];
    
    [_studyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX);
        make.right.equalTo(self.mas_right).offset(-24.0f);
        make.top.equalTo(_segmentLabel.mas_top);
    }];
    
    [_gradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_studyLabel.mas_left);
        make.right.equalTo(self.mas_right).offset(-24.0f);
        make.top.equalTo(_versionLabel.mas_top);
    }];
    
    [_keywordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_segmentLabel.mas_left);
        make.top.equalTo(_chapterLabel.mas_bottom).offset(15.0f);
        make.right.equalTo(_studyLabel.mas_right);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10.0f);
        make.top.equalTo(self.mas_top).offset(188.0f);
        make.right.equalTo(self.mas_right).offset(-10.0f);
        make.height.offset(0.5f);
    }];
    
    [_writeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(-6.0f);
        make.width.mas_offset(200.0f);
        make.height.mas_offset(45.0f);
        make.top.equalTo(_lineView.mas_bottom);
    }];
    
    [_againLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_writeButton.mas_bottom).offset(29.0f);
        make.right.equalTo(self.mas_centerX);
    }];
    
    [_againButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).offset(9.0f);
        make.centerY.equalTo(_againLabel.mas_centerY);
        make.height.mas_offset(30.0f);
        make.width.mas_offset(50.0f);
    }];
}
- (void)setDetail:(YXHomeworkInfoRequestItem_Body_Detail *)detail{
    _detail = detail;
    _segmentLabel.attributedText = [self homeworkInfo:@"学段:" withContent:_detail.segmentName?:@""];
    _studyLabel.attributedText = [self homeworkInfo:@"学科:" withContent:_detail.studyName?:@""];
    _versionLabel.attributedText = [self homeworkInfo:@"版本:" withContent:_detail.versionName ?:@""];
    _gradeLabel.attributedText = [self homeworkInfo:@"书册:" withContent:_detail.gradeName?:@""];
    _chapterLabel.attributedText = [self homeworkInfo:@"目录:" withContent:_detail.chapterName?:@""];
    _keywordLabel.attributedText = [self homeworkInfo:@"本次作业主要知识点:" withContent:_detail.keyword?:@""];
    _versionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _chapterLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _keywordLabel.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (NSMutableAttributedString *)homeworkInfo:(NSString *)title withContent:(NSString *)content{
    NSString *temString = [NSString stringWithFormat:@"%@  %@",title,content];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:temString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"334466"],NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, [temString length])];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"a1a7ae"]} range:NSMakeRange(0, title.length + 2)];
    return attributedString;
}

#pragma mark - button Action
- (void)buttonAction:(UIButton *)sender{
    BLOCK_EXEC(self.buttonActionHandler,sender.tag);
}
@end
