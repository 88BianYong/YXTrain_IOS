//
//  ReadingDetailHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ReadingDetailTableHeaderView_17.h"
#import "CoreTextViewHandler.h"
#import "YXGradientView.h"
#import "YXWebViewController.h"
@interface ReadingDetailTableHeaderView_17 ()
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) CoreTextViewHandler *coreTextHandler;
@property (nonatomic, assign) CGFloat htmlHeight;
@end

@implementation ReadingDetailTableHeaderView_17
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.htmlHeight = -0.1f;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - set
- (void)setContentString:(NSString *)contentString {
    _contentString = contentString;
//    NSString *readmePath = [[NSBundle mainBundle] pathForResource:@"Image" ofType:@"html"];
//    _contentString = [NSString stringWithContentsOfFile:readmePath
//                                              encoding:NSUTF8StringEncoding
//                                                 error:NULL];
    NSData *data = [_contentString?:@" " dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:[CoreTextViewHandler defaultCoreTextOptions]documentAttributes:nil];
    [string enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, string.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(DTTextAttachment *attachment, NSRange range, BOOL *stop) {
        if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
            attachment.originalSize = CGSizeMake(kScreenWidth - 50.0f, 200.0f);
            attachment.displaySize = CGSizeMake(kScreenWidth - 50.0f, 200.0f);
        }
    }];
    self.htmlView.attributedString = string;
}
#pragma mark - setupUI
- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
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
        if (self.htmlHeight == height) {//TBD:展开收起功能需要手动刷新relayoutText 手动刷新会多次改变高度
            return;
        }
        self.htmlHeight = height;
        dispatch_async(dispatch_get_main_queue(), ^{
            BLOCK_EXEC(self.readingDetailHeaderHeightChangeBlock,height);
        });
    }];
}
- (void)setupLayout {
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(25.0f);
        make.right.equalTo(self.mas_right).offset(-25.0f);
        make.bottom.equalTo(self.mas_bottom);
    }];

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
- (void)relayoutHtmlText{
    [self.htmlView relayoutText];
}

@end
