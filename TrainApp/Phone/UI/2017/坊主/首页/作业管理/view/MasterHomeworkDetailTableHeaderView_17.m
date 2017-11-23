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

@property (nonatomic, assign) CGFloat heightFloat;

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
    self.heightFloat = 0.0f;
    if (_body.score.integerValue > 0) {
        self.scoreLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
        self.scoreLabel.text = [NSString stringWithFormat:@"%@分",_body.score];
    }else {
        self.scoreLabel.textColor = [UIColor colorWithHexString:@"334466"];
        self.scoreLabel.text = @"未批阅";
    }
    self.recommendImageView.hidden = !_body.isRecommend.boolValue;
    
    BOOL isLayoutBool = YES;
    if (_body.publishUser.length > 0) {
        self.publishLabel.attributedText = [self homeworkInfo:@"提交人:" withContent:_body.publishUser?:@""];
        [self.publishLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15.0f);
            make.right.equalTo(self.mas_centerX).offset(-15.0f);
            make.top.equalTo(self.lineView.mas_bottom).offset(floorf(self.heightFloat)*43.0f + 31.0f);
        }];
        isLayoutBool = !isLayoutBool;
        self.heightFloat = self.heightFloat + 0.5f;
    }
    if (_body.finishDate.length > 0) {
           self.finishDateLabel.attributedText = [self homeworkInfo:@"提交时间:" withContent:_body.finishDate?:@""];
        if (isLayoutBool) {
            [self.finishDateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(15.0f);
                make.right.equalTo(self.mas_centerX).offset(-15.0f);
                make.top.equalTo(self.lineView.mas_bottom).offset(floorf(self.heightFloat)*43.0f + 31.0f);
            }];
        }else {
            [self.finishDateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_centerX);
                make.right.equalTo(self.mas_right).offset(-15.0f);
                make.top.equalTo(self.lineView.mas_bottom).offset(floorf(self.heightFloat)*43.0f + 31.0f);
            }];
        }
        isLayoutBool = !isLayoutBool;
        self.heightFloat = self.heightFloat + 0.5f;
    }
    if (_body.template.segmentName.length > 0) {
           self.segmentLabel.attributedText = [self homeworkInfo:@"学段:" withContent:_body.template.segmentName?:@""];
        if (isLayoutBool) {
            [self.segmentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(15.0f);
                make.right.equalTo(self.mas_centerX).offset(-10.0f);
                make.top.equalTo(self.lineView.mas_bottom).offset(floorf(self.heightFloat)*43.0f + 31.0f);
            }];
        }else {
            [self.segmentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_centerX);
                make.right.equalTo(self.mas_right).offset(-15.0f);
                make.top.equalTo(self.lineView.mas_bottom).offset(floorf(self.heightFloat)*43.0f + 31.0f);
            }];
        }
        isLayoutBool = !isLayoutBool;
        self.heightFloat = self.heightFloat + 0.5f;
    }
    if (_body.template.studyName.length > 0) {
            self.studyLabel.attributedText = [self homeworkInfo:@"学科:" withContent:_body.template.studyName?:@""];
        if (isLayoutBool) {
            [self.studyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(15.0f);
                make.right.equalTo(self.mas_centerX).offset(-10.0f);
                make.top.equalTo(self.lineView.mas_bottom).offset(floorf(self.heightFloat)*43.0f + 31.0f);
            }];
            
        }else {
            [self.studyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_centerX);
                make.right.equalTo(self.mas_right).offset(-15.0f);
                make.top.equalTo(self.lineView.mas_bottom).offset(floorf(self.heightFloat)*43.0f + 31.0f);
            }];
        }
        isLayoutBool = !isLayoutBool;
        self.heightFloat = self.heightFloat + 0.5f;
    }
    if (_body.template.versionName.length > 0) {
            self.versionLabel.attributedText = [self homeworkInfo:@"教材版本:" withContent:_body.template.versionName ?:@""];
        if (isLayoutBool) {
            [self.versionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(15.0f);
                make.right.equalTo(self.mas_centerX).offset(-10.0f);
                make.top.equalTo(self.lineView.mas_bottom).offset(floorf(self.heightFloat)*43.0f + 31.0f);
            }];
        }else {
            [self.versionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_centerX);
                make.right.equalTo(self.mas_right).offset(-15.0f);
                make.top.equalTo(self.lineView.mas_bottom).offset(floorf(self.heightFloat)*43.0f + 31.0f);
            }];
            
        }
        isLayoutBool = !isLayoutBool;
        self.heightFloat = self.heightFloat + 0.5f;
    }
    if (_body.template.gradeName.length > 0) {
        self.gradeLabel.attributedText = [self homeworkInfo:@"年级/册:" withContent:_body.template.gradeName?:@""];
        if (isLayoutBool) {
            [self.gradeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(15.0f);
                make.right.equalTo(self.mas_centerX).offset(-10.0f);
                make.top.equalTo(self.lineView.mas_bottom).offset(floorf(self.heightFloat)*43.0f + 31.0f);
            }];
        }else {
            [self.gradeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_centerX);
                make.right.equalTo(self.mas_right).offset(-15.0f);
                make.top.equalTo(self.lineView.mas_bottom).offset(floorf(self.heightFloat)*43.0f + 31.0f);
            }];
        }
        isLayoutBool = !isLayoutBool;
        self.heightFloat = self.heightFloat + 0.5f;
    }
    if (_body.template.chapterName.length > 0) {
            self.chapterLabel.attributedText = [self homeworkInfo:@"目录:" withContent:_body.template.chapterName?:@""];
        if (isLayoutBool) {
            [self.chapterLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(15.0f);
                make.right.equalTo(self.mas_right).offset(-15.0f);
                make.top.equalTo(self.lineView.mas_bottom).offset(floorf(self.heightFloat)*43.0f + 31.0f);
            }];
        }else {
            [self.chapterLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_centerX);
                make.right.equalTo(self.mas_right).offset(-15.0f);
                make.top.equalTo(self.lineView.mas_bottom).offset(floorf(self.heightFloat)*43.0f + 31.0f);
            }];
        }

        self.heightFloat = self.heightFloat + 0.5f;
    }
    if (_body.template.keyword.length > 0) {
        self.keywordLabel.attributedText = [self homeworkInfo:@"本次作业主要知识点:" withContent:[NSString stringWithFormat:@"\n%@",_body.template.keyword]?:@""];
        [self.keywordLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15.0f);
            make.right.equalTo(self.mas_right).offset(-15.0f);
            make.top.equalTo(self.lineView.mas_bottom).offset(ceilf(self.heightFloat)*43.0f + 31.0f);
        }];
    }else {
        [self.keywordLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15.0f);
            make.right.equalTo(self.mas_right).offset(-15.0f);
            make.top.equalTo(self.lineView.mas_bottom).offset(ceilf(self.heightFloat)*43.0f);
        }];
    }

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:_body.template.content?:@""];
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
- (CGFloat)summaryHeight {
    return ceilf([self.keywordLabel sizeThatFits:CGSizeMake(kScreenWidth - 15.0f - 15.0f , MAXFLOAT)].height + ceilf(self.heightFloat) * 43.0f);
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
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.keywordLabel.mas_bottom).offset(30.0f);
        make.width.mas_offset(100.0f);
    }];

    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.height.mas_offset(1.0f);
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
