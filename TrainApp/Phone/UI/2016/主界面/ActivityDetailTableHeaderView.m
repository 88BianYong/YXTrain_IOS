//
//  ActivityDetailTableHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityDetailTableHeaderView.h"
#import "CoreTextViewHandler.h"
#import "YXGradientView.h"
#import "YXWebViewController.h"
@interface ActivityDetailTableHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UILabel *timeLabel;//活动起止时间
@property (nonatomic, strong) UILabel *publisherTitleLabel;
@property (nonatomic, strong) UILabel *publisherContentLabel;
@property (nonatomic, strong) UILabel *studyTitleLabel;//学科
@property (nonatomic, strong) UILabel *studyContentLabel;
@property (nonatomic, strong) UILabel *segmentTitleLabel;//学段
@property (nonatomic, strong) UILabel *segmentContentLabel;
@property (nonatomic, strong) UILabel *participantsTitleLabel;
@property (nonatomic, strong) UILabel *participantsContentLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) UIButton *openCloseButton;
@property (nonatomic, strong) CoreTextViewHandler *coreTextHandler;
@property (nonatomic, strong) YXGradientView *gradientView;


@property (nonatomic, copy) ActivityHtmlOpenAndCloseBlock openCloseBlock;
@property (nonatomic, copy) ActivityHtmlHeightChangeBlock heightChangeBlock;
@property (nonatomic, assign) BOOL isFirstRefresh;
@property (nonatomic, assign) BOOL isOpen;

@end
@implementation ActivityDetailTableHeaderView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.isFirstRefresh = YES;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.isOpen = NO;
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(5.0f);
        make.top.equalTo(self.mas_top);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    
    self.statusImageView = [[UIImageView alloc] init];
    [self addSubview:self.statusImageView];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.timeLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:self.timeLabel];
    
    self.publisherTitleLabel = [self formatTitleLabel];
    self.publisherTitleLabel.text = @"发布人";
    [self addSubview:self.publisherTitleLabel];
    self.publisherContentLabel = [self formatContentLabel];
    [self addSubview:self.publisherContentLabel];
    
    self.studyTitleLabel = [self formatTitleLabel];
    self.studyTitleLabel.text = @"学段";
    [self addSubview:self.studyTitleLabel];
    self.studyContentLabel = [self formatContentLabel];
    [self addSubview:self.studyContentLabel];
    
    self.segmentTitleLabel = [self formatTitleLabel];
    self.segmentTitleLabel.text = @"学科";
    [self addSubview:self.segmentTitleLabel];
    self.segmentContentLabel = [self formatContentLabel];
    [self addSubview:self.segmentContentLabel];
    
    self.participantsTitleLabel = [self formatTitleLabel];
    self.participantsTitleLabel.text = @"参与人数";
    [self addSubview:self.participantsTitleLabel];
    self.participantsContentLabel = [self formatContentLabel];
    [self addSubview:self.participantsContentLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self addSubview:lineView];
    
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.descriptionLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.descriptionLabel.text = @"活动描述";
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.descriptionLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.descriptionLabel];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(1.0f / [UIScreen mainScreen].scale);
        make.centerY.equalTo(self.descriptionLabel.mas_centerY);
    }];
    
    
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    self.htmlView.clipsToBounds = YES;
    self.htmlView.shouldDrawImages = NO;
    [self addSubview:self.htmlView];
    self.coreTextHandler = [[CoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:kScreenWidth - 50.0f];
    WEAK_SELF
    [self.coreTextHandler setCoreTextViewHeightChangeBlock:^(CGFloat height) {
        STRONG_SELF
        self ->_changeHeight = height + self.titleLabel.bounds.size.height;
        if (self.isFirstRefresh) {
            [self updateHtmlViewWithHeight:height];
            BLOCK_EXEC(self.heightChangeBlock,height,self.titleLabel.bounds.size.height);
        }
        self.isFirstRefresh = NO;
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
- (void)setupLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25.0f);
        make.right.equalTo(self.mas_right).offset(-25.0f);
        make.top.equalTo(self.mas_top).offset(35.0f + 5.0f);
    }];
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(108.0f, 52.0f));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8.0f);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.statusImageView.mas_bottom).offset(9.0f);
    }];
    [self.publisherTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_centerX).offset(-9.0f);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(14.0f);
    }];
    [self.publisherContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).offset(9.0f);
        make.top.equalTo(self.publisherTitleLabel.mas_top);
    }];
    
    [self.studyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.publisherTitleLabel.mas_right);
        make.top.equalTo(self.publisherTitleLabel.mas_bottom).offset(12.0f);
    }];
    [self.studyContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.publisherContentLabel.mas_left);
        make.top.equalTo(self.studyTitleLabel.mas_top);
    }];
    
    [self.segmentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.publisherTitleLabel.mas_right);
        make.top.equalTo(self.studyTitleLabel.mas_bottom).offset(12.0f);
    }];
    [self.segmentContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.publisherContentLabel.mas_left);
        make.top.equalTo(self.segmentTitleLabel.mas_top);
    }];
    
    [self.participantsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.publisherTitleLabel.mas_right);
        make.top.equalTo(self.segmentTitleLabel.mas_bottom).offset(12.0f);
        
    }];
    [self.participantsContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.publisherContentLabel.mas_left);
        make.top.equalTo(self.participantsTitleLabel.mas_top);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.participantsContentLabel.mas_bottom).offset(36.0f);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_offset(100.0f);
    }];
    
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).offset(16.0f);
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
- (void)updateHtmlViewWithHeight:(CGFloat)height {
    if (height < 300.0f) {
        [self.htmlView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.descriptionLabel.mas_bottom).offset(22.0f);
            make.left.equalTo(self.mas_left).offset(25.0f);
            make.right.equalTo(self.mas_right).offset(-25.0f);
            make.bottom.equalTo(self.mas_bottom).offset (-15.0f);
        }];
        self.openCloseButton.hidden = YES;
        self.gradientView.hidden = YES;
    }
}

#pragma mark - format label
- (UILabel *)formatTitleLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    label.font = [UIFont systemFontOfSize:12.0f];
    return label;
}
- (UILabel *)formatContentLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithHexString:@"334466"];
    label.font = [UIFont systemFontOfSize:12.0f];
    return label;
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

#pragma mark - set
- (void)setActivityHtmlOpenAndCloseBlock:(ActivityHtmlOpenAndCloseBlock)block {
    self.openCloseBlock = block;
}
- (void)setActivityHtmlHeightChangeBlock:(ActivityHtmlHeightChangeBlock)block {
    self.heightChangeBlock = block;
}
- (void)setModel:(ActivityListDetailModel *)model{
    _model = model;
    self.titleLabel.attributedText = [self attributedStringForTitle:_model.title?:@""];
    self.timeLabel.text = _model.restrictTime.integerValue == 1 ? [self formatTimeWithStartTime:_model.startTime endTime:_model.endTime] : @"";
    self.publisherContentLabel.text = _model.createUsername;
    self.studyContentLabel.text = _model.segmentName;
    self.segmentContentLabel.text = _model.studyName;
    self.participantsContentLabel.text = _model.joinUserCount;
    self.statusImageView.image = [self formatStatusImageWithStatus:_model.status];
//        NSString *readmePath = [[NSBundle mainBundle] pathForResource:@"Image" ofType:@"html"];
//        _model.desc = [NSString stringWithContentsOfFile:readmePath
//                                                       encoding:NSUTF8StringEncoding
//                                                        error:NULL];
    NSData *data = [_model.desc?:@"" dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:[CoreTextViewHandler defaultCoreTextOptions] documentAttributes:nil];
    [string enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, string.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(DTTextAttachment *attachment, NSRange range, BOOL *stop) {
        if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
            attachment.originalSize = CGSizeMake(kScreenWidth - 50.0f, 200.0f);
            attachment.displaySize = CGSizeMake(kScreenWidth - 50.0f, 200.0f);

        }
    }];
    self.htmlView.attributedString = string;
}
- (NSString *)formatTimeWithStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    if (isEmpty(startTime) && isEmpty(endTime)) {
        return @"";
    }
    if (!isEmpty(startTime) && isEmpty(endTime)) {
        return [NSString stringWithFormat:@"%@ 开始",startTime];
    }
    if (isEmpty(startTime) && !isEmpty(endTime)) {
        return [NSString stringWithFormat:@"%@ 结束",endTime];
    }
    NSString *time = [NSString stringWithFormat:@"%@ 至 %@",startTime,endTime];
    return time;
}
- (UIImage *)formatStatusImageWithStatus:(NSString *)status {
    NSString *imageName;
    switch (status.integerValue) {
        case 0:
            imageName = @"未开始标签";
            break;
        case 2:
            imageName = @"进行中标签";
            break;
        case 3:
            imageName = @"已结束标签";
            break;
        case 4:
            imageName = @"阶段关闭标签";
            break;
        default:
            break;
    }
    return [UIImage imageNamed:imageName];
}
#pragma mark - format data
- (NSMutableAttributedString *)attributedStringForTitle:(NSString *)titleString {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7.0f;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleString length])];
    return attributedString;
}
- (void)relayoutHtmlText {
    self.htmlView.layouter = nil;
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
