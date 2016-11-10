//
//  ActivityDetailTableHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityDetailTableHeaderView.h"
@interface ActivityDetailTableHeaderView ()<
DTAttributedTextContentViewDelegate,
DTLazyImageViewDelegate,
UIActionSheetDelegate
>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UILabel *publisherTitleLabel;
@property (nonatomic, strong) UILabel *publisherContentLabel;
@property (nonatomic, strong) UILabel *studyTitleLabel;//学段
@property (nonatomic, strong) UILabel *studyContentLabel;
@property (nonatomic, strong) UILabel *segmentTitleLabel;//学科
@property (nonatomic, strong) UILabel *segmentContentLabel;
@property (nonatomic, strong) UILabel *participantsTitleLabel;
@property (nonatomic, strong) UILabel *participantsContentLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) UIButton *openCloseButton;


@property (nonatomic, strong) NSURL *lastActionLink;
@property (nonatomic, copy) ActivityHtmlOpenAndCloseBlock openCloseBlock;

@end
@implementation ActivityDetailTableHeaderView
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
    self.titleLabel.numberOfLines = 2;
    [self addSubview:self.titleLabel];
    
    self.statusImageView = [[UIImageView alloc] init];
    self.statusImageView.backgroundColor = [UIColor redColor];
    [self addSubview:self.statusImageView];
    
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
    self.htmlView.delegate = self;
    self.htmlView.clipsToBounds = YES;
    [self addSubview:self.htmlView];
    
    self.openCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openCloseButton.layer.cornerRadius = YXTrainCornerRadii;
    self.openCloseButton.layer.borderWidth = 1.0f;
    self.openCloseButton.layer.borderColor = [UIColor colorWithHexString:@"0070c9"].CGColor;
    self.openCloseButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.openCloseButton setTitle:@"查看全文" forState:UIControlStateNormal];
    [self.openCloseButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
    [self.openCloseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.openCloseButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateHighlighted];
    [self.openCloseButton addTarget:self action:@selector(openCloseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.openCloseButton];
    
    
}

- (void)setupLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25.0f);
        make.right.equalTo(self.mas_right).offset(-25.0f);
        make.top.equalTo(self.mas_top).offset(37.0f + 5.0f);
    }];
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(108.0f, 72.0f));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(16.0f);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.publisherTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_centerX).offset(-9.0f);
        make.top.equalTo(self.statusImageView.mas_bottom).offset(17.0f);
    }];
    [self.publisherContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).offset(9.0f);
        make.top.equalTo(self.publisherTitleLabel.mas_top);
    }];
    
    [self.studyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.publisherTitleLabel.mas_right);
        make.top.equalTo(self.publisherTitleLabel.mas_bottom).offset(15.0f);
    }];
    [self.studyContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.publisherContentLabel.mas_left);
        make.top.equalTo(self.studyTitleLabel.mas_top);
    }];
    
    [self.segmentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.publisherTitleLabel.mas_right);
        make.top.equalTo(self.studyTitleLabel.mas_bottom).offset(15.0f);
    }];
    [self.segmentContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.publisherContentLabel.mas_left);
        make.top.equalTo(self.studyContentLabel.mas_bottom).offset(15.0f);
    }];
    
    [self.participantsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.publisherTitleLabel.mas_right);
        make.top.equalTo(self.segmentTitleLabel.mas_bottom).offset(15.0f);

    }];
    [self.participantsContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.publisherContentLabel.mas_left);
        make.top.equalTo(self.segmentTitleLabel.mas_bottom).offset(15.0f);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.participantsContentLabel.mas_bottom).offset(40.0f);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_offset(100.0f);
    }];

    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).offset(22.0f);
        make.left.equalTo(self.mas_left).offset(25.0f);
        make.right.equalTo(self.mas_right).offset(-25.0f);
        make.bottom.equalTo(self.mas_bottom).offset (-61.0f);
    }];
    
    [self.openCloseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(80.0f, 24.0f));
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-20.0f);
    }];
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

#pragma mark DTAttributedTextContentViewDelegate
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame {
    if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        imageView.delegate = self;
        imageView.image = [(DTImageTextAttachment *)attachment image];
        imageView.url = attachment.contentURL;
        return imageView;
    }
    return nil;
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForLink:(NSURL *)url identifier:(NSString *)identifier frame:(CGRect)frame {
    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
    button.URL = url;
    button.minimumHitSize = CGSizeMake(25, 25);
    button.GUID = identifier;
    [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
    [button addGestureRecognizer:longPress];
    return button;
}

#pragma mark - DTLazyImageViewDelegate
- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size {
    NSURL *url = lazyImageView.url;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    CGFloat maxWidth = kScreenWidth - 50.0f;
    if (size.width > maxWidth) {
        CGFloat height = size.height * maxWidth / size.width;
        size = CGSizeMake(maxWidth, floorf(height));
    }
    BOOL needUpdate = NO;
    for (DTTextAttachment *oneAttachment in [self.htmlView.layoutFrame textAttachmentsWithPredicate:pred]) {
        if (!CGSizeEqualToSize(oneAttachment.displaySize, size)) {
            oneAttachment.displaySize = size;
            oneAttachment.verticalAlignment = DTTextAttachmentVerticalAlignmentCenter;
            needUpdate = YES;
        }
    }
    if (needUpdate) {
        self.htmlView.layouter = nil;
        [self.htmlView relayoutText];
    }
}

#pragma mark - Actions
- (void)openCloseButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setTitle:@"收起" forState:UIControlStateNormal];
    }else {
        [sender setTitle:@"查看全文" forState:UIControlStateNormal];
    }
    BLOCK_EXEC(self.openCloseBlock,sender.selected);
}

- (void)linkPushed:(DTLinkButton *)button {
    [[UIApplication sharedApplication] openURL:[button.URL absoluteURL]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        [[UIApplication sharedApplication] openURL:[self.lastActionLink absoluteURL]];
    }
}

- (void)linkLongPressed:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        DTLinkButton *button = (id)[gesture view];
        button.highlighted = NO;
        self.lastActionLink = button.URL;
        if ([[UIApplication sharedApplication] canOpenURL:[button.URL absoluteURL]])
        {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:[[button.URL absoluteURL] description] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开 Safari", nil];
            [action showFromRect:button.frame inView:button.superview animated:YES];
        }
    }
}

#pragma mark - set
- (void)setActivityHtmlOpenAndCloseBlock:(ActivityHtmlOpenAndCloseBlock)block{
    self.openCloseBlock = block;
}

- (void)setActivity:(ActivityListRequestItem_body_activity *)activity{
    _activity = activity;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:activity.title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7.0f;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [activity.title length])];
    self.titleLabel.attributedText = attributedString;
    self.publisherContentLabel.text = activity.createUsername;
    self.studyContentLabel.text = activity.studyName;
    self.segmentContentLabel.text = activity.segmentName;
    self.participantsContentLabel.text = @"14人";
    NSString *readmePath = [[NSBundle mainBundle] pathForResource:@"Image" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:readmePath
                                               encoding:NSUTF8StringEncoding
                                                  error:NULL];
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    CGSize maxImageSize = CGSizeMake(kScreenWidth - 50.0f, kScreenHeight - 100.0f);
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithFloat:1.25], NSTextSizeMultiplierDocumentOption,
                             [UIColor colorWithHexString:@"#334466"], DTDefaultTextColor,
                             [NSNumber numberWithFloat:1.5], DTDefaultLineHeightMultiplier,
                             [NSValue valueWithCGSize:maxImageSize], DTMaxImageSize,
                             [UIColor colorWithHexString:@"#0067be"], DTDefaultLinkColor,
                             [NSNumber numberWithFloat:1.0], DTAttachmentParagraphSpacingAttribute,
                             nil];
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:nil];
    self.htmlView.attributedString = string;
}

- (void)relayoutHtmlText{
    [self.htmlView relayoutText];
}
@end
