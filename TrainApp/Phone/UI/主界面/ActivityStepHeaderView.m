//
//  ActivityStepHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityStepHeaderView.h"
#import "CoreTextViewHandler.h"
#import "YXGradientView.h"
#import "YXWebViewController.h"
@interface ActivityStepHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
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
@implementation ActivityStepHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.isOpen = NO;
        self.isFirstRefresh = YES;
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
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self addSubview:lineView];
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.descriptionLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.descriptionLabel.text = @"步骤描述";
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
    [self addSubview:self.htmlView];
    self.coreTextHandler = [[CoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:kScreenWidth - 50.0f];
    WEAK_SELF
    [self.coreTextHandler setCoreTextViewLinkPushedBlock:^(NSURL *url) {
        STRONG_SELF
        YXWebViewController *VC = [[YXWebViewController alloc] init];
        VC.urlString = url.absoluteString;
        VC.isUpdatTitle = YES;
        [[self viewController].navigationController pushViewController:VC animated:YES];
        
    }];
    [self.coreTextHandler setCoreTextViewHeightChangeBlock:^(CGFloat height) {
        STRONG_SELF
        self ->_changeHeight = height + self.titleLabel.bounds.size.height;
        if (self.isFirstRefresh) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateHtmlViewWithHeight:height];
                BLOCK_EXEC(self.heightChangeBlock,height,self.titleLabel.bounds.size.height);
            });
        }
        self.isFirstRefresh = NO;
    }];
    self.openCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openCloseButton.layer.cornerRadius = YXTrainCornerRadii;
    self.openCloseButton.layer.borderWidth = 1.0f;
    self.openCloseButton.layer.borderColor = [UIColor colorWithHexString:@"0070c9"].CGColor;
    self.openCloseButton.clipsToBounds = YES;
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
        make.top.equalTo(self.mas_top).offset(34.0f + 5.0f);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(37.0f + 2.0f);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_offset(100.0f);
    }];
    
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).offset(16.0f);
        make.left.equalTo(self.mas_left).offset(25.0f);
        make.right.equalTo(self.mas_right).offset(-25.0f);
        make.bottom.equalTo(self.mas_bottom).offset (-41.0f);
    }];
    [self.gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-kTableViewHeaderOpenAndCloseHeight);
        make.height.mas_offset(60.0f);
    }];
    
    [self.openCloseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(80.0f + 15.0f, 24.0f));
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom);
    }];
}
- (void)updateHtmlViewWithHeight:(CGFloat)height {
    if (height < 300.0f) {
        [self.htmlView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.descriptionLabel.mas_bottom).offset(16.0f);
            make.left.equalTo(self.mas_left).offset(25.0f);
            make.right.equalTo(self.mas_right).offset(-25.0f);
            make.bottom.equalTo(self.mas_bottom);
        }];
        self.openCloseButton.hidden = YES;
        self.gradientView.hidden = YES;
    }
}
- (void)relayoutHtmlText{
    [self.htmlView relayoutText];
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
- (void)setActivityStep:(ActivityListRequestItem_Body_Activity_Steps *)activityStep{
    _activityStep = activityStep;
    self.titleLabel.text = _activityStep.title;
    NSData *data = [_activityStep.desc?:@"" dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:[CoreTextViewHandler defaultCoreTextOptions]documentAttributes:nil];
    [string enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, string.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(DTTextAttachment *attachment, NSRange range, BOOL *stop) {
        if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
            attachment.originalSize = CGSizeMake(kScreenWidth - 50.0f, 200.0f);
        }
    }];
    self.htmlView.attributedString = string;
}
- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
