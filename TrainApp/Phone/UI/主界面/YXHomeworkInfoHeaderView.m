//
//  YXHomeworkInfoHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/4.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHomeworkInfoHeaderView.h"
#import "YXHomeworkInfoRequest.h"
#import "CoreTextViewHandler.h"
#import "YXGradientView.h"
#import "YXWebViewController.h"
@interface YXHomeworkInfoHeaderView()
{
    UILabel *_scoreLabel;//成绩
    UILabel *_pointLabel;//分数
    UILabel *_endDateLabel;//结束日期
    UILabel *_finishedLabel;//作业状态
    UIImageView *_finishedImageView;
    
    UIImageView *_firstImageView;//第一个状态
    UIImageView *_secondImageView;//第二个状态
    NSTextAttachment *_textAttachment;

}
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) UIButton *openCloseButton;
@property (nonatomic, strong) CoreTextViewHandler *coreTextHandler;
@property (nonatomic, strong) YXGradientView *gradientView;
@property (nonatomic, copy) HomeworkHtmlOpenAndCloseBlock openCloseBlock;
@property (nonatomic, copy) HomeworkHtmlHeightChangeBlock heightChangeBlock;
@property (nonatomic, assign) BOOL isFirstRefresh;
@property (nonatomic, assign) BOOL isOpen;
@end


@implementation YXHomeworkInfoHeaderView
- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _textAttachment= [[NSTextAttachment alloc] init];
        self.isOpen = NO;
        self.isFirstRefresh = YES;
        [self setupUI];
        [self layoutInterface];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI{
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
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    self.htmlView.clipsToBounds = YES;
    self.htmlView.shouldDrawImages = NO;
    [self addSubview:self.htmlView];
    self.coreTextHandler = [[CoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:kScreenWidth - 50.0f];
    WEAK_SELF
    [self.coreTextHandler setCoreTextViewHeightChangeBlock:^(CGFloat height) {
        STRONG_SELF
        self ->_changeHeight = height;
        if (self.isFirstRefresh) {
            [self updateHtmlViewWithHeight:height];
            BLOCK_EXEC(self.heightChangeBlock);
        }
    }];
    [self.coreTextHandler setCoreTextViewLinkPushedBlock:^(NSURL *url) {
        STRONG_SELF
        YXWebViewController *VC = [[YXWebViewController alloc] init];
        VC.urlString = url.absoluteString;
        VC.isUpdatTitle = YES;
        [[self viewController].navigationController pushViewController:VC animated:YES];
    }];
    
    self.openCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openCloseButton.layer.cornerRadius = YXTrainCornerRadii;
    self.openCloseButton.layer.borderWidth = 1.0f;
    self.openCloseButton.clipsToBounds = YES;
    self.openCloseButton.layer.borderColor = [UIColor colorWithHexString:@"0070c9"].CGColor;
    self.openCloseButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.openCloseButton setTitle:@"查看全文" forState:UIControlStateNormal];
    [self.openCloseButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
    [self.openCloseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.openCloseButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateHighlighted];
    [self.openCloseButton addTarget:self action:@selector(openCloseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.openCloseButton];
    self.gradientView = [[YXGradientView alloc] initWithColor:[UIColor whiteColor] orientation:YXGradientBottomToTop];
    [self addSubview:self.gradientView];
}

- (void)layoutInterface{
    [_scoreLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(24.5f);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [_pointLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_scoreLabel.mas_bottom).offset(6.0f);
        make.centerX.equalTo(self.mas_centerX);
    }];

    [_endDateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_pointLabel.mas_bottom).offset(16.0f);
        make.centerX.equalTo(self.mas_centerX);
    }];

    [_finishedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_endDateLabel.mas_bottom).offset(6.0f);
        make.left.equalTo(self->_endDateLabel.mas_left);
    }];

    [_firstImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_pointLabel.mas_right).offset(6.0f);
        make.centerY.equalTo(self->_pointLabel.mas_centerY);
        make.width.height.mas_offset(20.0f);
    }];

    [_secondImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_pointLabel.mas_right).offset(6.0f + 6.0f + 20.0f);
        make.centerY.equalTo(self->_pointLabel.mas_centerY);
        make.width.height.mas_offset(20.0f);
    }];
    
    [_finishedImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_finishedLabel.mas_left).offset(80.0f);
        make.top.equalTo(self->_firstImageView.mas_bottom).offset(36.0f);//动态调整 10 标注不同
        make.width.height.mas_offset(45.0f);
    }];
    
    UILabel *label = [self viewWithTag:1001];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(16.0f);
        make.left.equalTo(self.mas_left).offset(25.0f);
        make.right.equalTo(self.mas_right).offset(-25.0f);
        make.bottom.equalTo(self.mas_bottom).offset(-61.0f);
    }];
    
    [self.openCloseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(95.0f, 24.0f));
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-20.0f);
    }];
    
    [self.gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-61.0f);
        make.height.mas_offset(60.0f);
    }];

}

#pragma mark - Actions
- (void)openCloseButtonAction:(UIButton *)sender {
    self.isOpen = !self.isOpen;
    if (self.isOpen) {
        self.gradientView.hidden = YES;
        [sender setTitle:@"收起" forState:UIControlStateNormal];
    }else {
        self.gradientView.hidden = NO;
        [sender setTitle:@"查看全文" forState:UIControlStateNormal];
    }
    BLOCK_EXEC(self.openCloseBlock,self.isOpen);
}
- (void)updateHtmlViewWithHeight:(CGFloat)height {
    if (height < 300.0f) {
        UILabel *label = [self viewWithTag:1001];
        [self.htmlView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(22.0f);
            make.left.equalTo(self.mas_left).offset(25.0f);
            make.right.equalTo(self.mas_right).offset(-25.0f);
            make.bottom.equalTo(self.mas_bottom).offset (-15.0f);
        }];
        self.openCloseButton.hidden = YES;
        self.gradientView.hidden = YES;
    }
}

#pragma mark - data
- (void)setHomeworkHtmlOpenAndCloseBlock:(HomeworkHtmlOpenAndCloseBlock)block {
    self.openCloseBlock = block;
}
- (void)setHomeworkHtmlHeightChangeBlock:(HomeworkHtmlHeightChangeBlock)block {
    self.heightChangeBlock = block;
}
- (void)setBody:(YXHomeworkInfoRequestItem_Body *)body{
    _body = body;
    if([_body.isMarked isEqualToString:@"0"]){
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:@" "];
        _textAttachment = [[NSTextAttachment alloc]init];
        _textAttachment.image = [UIImage imageNamed:@"未批改"];
        _textAttachment.bounds = CGRectMake(0, -3.0f, 105.0f, 28.0f);
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:_textAttachment];
        [attr appendAttributedString:attrStringWithImage];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@" "];
        [attr appendAttributedString:attrString];
        _pointLabel.attributedText = attr;
    }else{
        _pointLabel.attributedText = [self totalScoreStringWithScore:_body.score];
    }
    _endDateLabel.text = [NSString stringWithFormat:@"截止日期  %@",_body.endDate?:@"无"];
    _finishedLabel.text = [NSString stringWithFormat:@"作业状态  %@",[_body.isFinished boolValue]?@"已完成":@"未完成"];
    _finishedImageView.hidden = ![_body.isFinished boolValue];
    [self layoutInterface:[_body.recommend boolValue] withIsmyrec:[_body.ismyrec boolValue]];
//    NSString *readmePath = [[NSBundle mainBundle] pathForResource:@"Image" ofType:@"html"];
//    _body.depiction = [NSString stringWithContentsOfFile:readmePath
//                                                       encoding:NSUTF8StringEncoding
//                                                          error:NULL];
    NSData *data = [_body.depiction?:@"" dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:[CoreTextViewHandler defaultCoreTextOptions] documentAttributes:nil];
    [string enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, string.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(DTTextAttachment *attachment, NSRange range, BOOL *stop) {
        if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
            attachment.originalSize = CGSizeMake(kScreenWidth - 50.0f, 200.0f);
            attachment.displaySize = CGSizeMake(kScreenWidth - 50.0f, 200.0f);
        }
    }];
    self.htmlView.attributedString = string;
    if (_body.type.integerValue == 1) {
        self.gradientView.hidden = YES;
        self.openCloseButton.hidden = YES;
    }
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
- (void)relayoutHtmlText {
    self.isFirstRefresh = NO;
    [self.htmlView relayoutText];
}
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
