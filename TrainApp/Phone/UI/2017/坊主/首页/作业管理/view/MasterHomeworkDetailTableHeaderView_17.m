//
//  MasterHomeworkDetailTableHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkDetailTableHeaderView_17.h"
@interface MasterHomeworkDetailTableHeaderView_17 ()
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UIImageView *recommendImageView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *publishLabel;//提交人
@property (nonatomic, strong) UILabel *finishDateLabel;//提交时间
@property (nonatomic, strong) UILabel *segmentLabel;//学段
@property (nonatomic, strong) UILabel *studyLabel;//学科
@property (nonatomic, strong) UILabel *versionLabel;//版本
@property (nonatomic, strong) UILabel *gradeLabel;//年级
@property (nonatomic, strong) UILabel *chapterLabel;//目录
@property (nonatomic, strong) UILabel *keywordLabel;//知识点
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) UIView *bottomLineView;

@end
@implementation MasterHomeworkDetailTableHeaderView_17
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma  makr - set
- (void)setBody:(MasterHomeworkDetailItem_Body *)body {
    _body = body;
    if (_body.score.integerValue > 0) {
        self.scoreLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
        self.scoreLabel.text = [NSString stringWithFormat:@"%@分",_body.score];
    }else {
        self.scoreLabel.textColor = [UIColor colorWithHexString:@"334466"];
        self.scoreLabel.text = @"未批阅";
    }
    self.publishLabel.attributedText = [self homeworkInfo:@"提交人:" withContent:_body.publishUser?:@""];
    self.finishDateLabel.attributedText = [self homeworkInfo:@"提交时间:" withContent:_body.finishDate?:@""];
    self.segmentLabel.attributedText = [self homeworkInfo:@"学段:" withContent:_body.template.segmentName?:@""];
    self.studyLabel.attributedText = [self homeworkInfo:@"学科:" withContent:_body.template.studyName?:@""];
    self.versionLabel.attributedText = [self homeworkInfo:@"教材版本:" withContent:_body.template.versionName ?:@""];
    self.gradeLabel.attributedText = [self homeworkInfo:@"年级/册:" withContent:_body.template.gradeName?:@""];
    self.chapterLabel.attributedText = [self homeworkInfo:@"目录:" withContent:_body.template.chapterName?:@""];
    self.keywordLabel.attributedText = [self homeworkInfo:@"本次作业主要知识点:" withContent:[NSString stringWithFormat:@"\n%@",_body.template.keyword]?:@""];
    _body.template.content = @"萨法回复卡机的回复路口就哈的路费哈罗德回复拉黑的福利哈六块腹肌哈罗德发挥了卡计划地方了哈哈是粉红色发了是京东方啦惊世毒妃拉黑的酸辣粉哈离斗湖发蜡打飞机啊好到了发哈离斗湖法拉第发了哈当返回拉丁方拉拉附近啊啊放假啊;卡积分拉卡积分;咖啡机阿里京东方;爱咖啡卡发空间发;安居房;按键的发酵ad升级非;安居房;按键;发;就发家发酒疯;阿发;加法;金发放;啊;附近;啊京东方;安静的;发;附近;阿发;骄傲;放假啊;附近;安居房;阿道夫;卡的;放假按揭房;阿发;骄傲;放假啊;大姐夫;啊京东方;骄傲;打飞机啊;都是发生的";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:_body.template.content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineHeightMultiple:1.2f];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"334466"],NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, [_body.template.content length])];
    self.descriptionLabel.attributedText = attributedString;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth - 31.0f, ceilf([self.descriptionLabel sizeThatFits:CGSizeMake(kScreenWidth - 15.0f - 15.0f , MAXFLOAT)].height));
    _versionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _chapterLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _keywordLabel.lineBreakMode = NSLineBreakByTruncatingTail;
}
- (NSMutableAttributedString *)homeworkInfo:(NSString *)title withContent:(NSString *)content{
    NSString *temString = [NSString stringWithFormat:@"%@  %@",title,content];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:temString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineHeightMultiple:1.2f];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"334466"],NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, [temString length])];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"a1a7ae"]} range:NSMakeRange(0, title.length + 2)];
    return attributedString;
}
- (CGFloat)keywordHeight {
    return ceilf([self.keywordLabel sizeThatFits:CGSizeMake(kScreenWidth - 15.0f - 15.0f , MAXFLOAT)].height);
}
#pragma mark - setupUI
- (void)setupUI {
    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self addSubview:self.scoreLabel];
    
    self.recommendImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"优标签"]];
    [self addSubview:self.recommendImageView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self addSubview:self.lineView];
    
    self.publishLabel = [[UILabel alloc] init];
    [self addSubview:self.publishLabel];
    
    self.finishDateLabel = [[UILabel alloc] init];
    [self addSubview:self.finishDateLabel];

    self.segmentLabel = [[UILabel alloc] init];
    [self addSubview:self.segmentLabel];
    
    self.studyLabel = [[UILabel alloc] init];
    [self addSubview:self.studyLabel];
    
    self.versionLabel = [[UILabel alloc] init];
    [self addSubview:self.versionLabel];
    
    self.gradeLabel = [[UILabel alloc] init];
    [self addSubview:self.gradeLabel];
    
    self.chapterLabel = [[UILabel alloc] init];
    [self addSubview:self.chapterLabel];
    
    self.keywordLabel = [[UILabel alloc] init];
    self.keywordLabel.numberOfLines = 0;
    [self addSubview:self.keywordLabel];
    
    self.bottomLineView = [[UIView alloc] init];
    self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self addSubview:self.bottomLineView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.titleLabel.text = @"作业内容";
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.descriptionLabel.font = [UIFont systemFontOfSize:13.0f];
    self.descriptionLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.descriptionLabel];
  
}
- (void)setupLayout {
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.height.mas_offset(44.0f);
        make.top.equalTo(self.mas_top);
    }];
    
    [self.recommendImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scoreLabel.mas_right).offset(10.0f);
        make.centerY.equalTo(self.scoreLabel.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(1.0f);
        make.top.equalTo(self.scoreLabel.mas_bottom);
    }];
    
    [self.publishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.right.equalTo(self.mas_centerX).offset(-15.0f);
        make.top.equalTo(self.lineView.mas_bottom).offset(35.0f);
    }];
    
    [self.finishDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.publishLabel.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15.0f);
    }];
    
    [self.segmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.top.equalTo(self.publishLabel.mas_bottom).offset(20.0f);
        make.right.equalTo(self.mas_centerX).offset(-10.0f);
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.segmentLabel.mas_left);
        make.width.equalTo(self.segmentLabel.mas_width);
        make.top.equalTo(self.segmentLabel.mas_bottom).offset(20.0f);
    }];
    
    [self.chapterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.segmentLabel.mas_left);
        make.width.equalTo(self.segmentLabel.mas_width);
        make.top.equalTo(self.versionLabel.mas_bottom).offset(20.0f);
    }];
    
    [self.studyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX);
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.top.equalTo(self.segmentLabel.mas_top);
    }];
    
    [self.gradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.studyLabel.mas_left);
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.top.equalTo(self.versionLabel.mas_top);
    }];
    
    [self.keywordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.publishLabel.mas_left);
        make.top.equalTo(self.chapterLabel.mas_bottom).offset(20.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.height.mas_offset(1.0f);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.keywordLabel.mas_bottom).offset(25.0f);
        make.width.mas_offset(100.0f);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20.0f);
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.height.mas_offset(80.0f);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top);
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
    }];
}

@end
