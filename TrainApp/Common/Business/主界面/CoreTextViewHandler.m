//
//  CoreTextViewHandler.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "CoreTextViewHandler.h"
@interface CoreTextViewHandler ()<
DTAttributedTextContentViewDelegate,
DTLazyImageViewDelegate,
UIActionSheetDelegate
>
@property(nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, strong) NSURL *lastActionLink;

@property (nonatomic, copy) CoreTextViewrRelayoutBlock relayoutBlock;
@property (nonatomic, copy) CoreTextViewLinkPushedBlock linkPushedBlock;
@property (nonatomic, copy) CoreTextViewHeightChangeBlock heightChangeBlock;

@end
@implementation CoreTextViewHandler
- (void)dealloc {
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
}
+ (NSDictionary *)defaultCoreTextOptions{
    CGSize maxImageSize = CGSizeMake(kScreenWidth - 50.0f, kScreenHeight - 100.0f);
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithFloat:1.0], NSTextSizeMultiplierDocumentOption,
                             [UIColor colorWithHexString:@"#334466"], DTDefaultTextColor,
                             [NSNumber numberWithFloat:1.5], DTDefaultLineHeightMultiplier,
                             [NSValue valueWithCGSize:maxImageSize], DTMaxImageSize,
                             [UIColor colorWithHexString:@"#0067be"], DTDefaultLinkColor,
                             [NSNumber numberWithFloat:13.0],DTDefaultFontSize,
                             [NSNumber numberWithFloat:1.0], DTAttachmentParagraphSpacingAttribute,
                             nil];
    return options;
}

- (instancetype)initWithCoreTextView:(DTAttributedTextContentView *)view maxWidth:(CGFloat)width {
    if (self = [super initWithFrame:CGRectZero]) {
        self.htmlView = view;
        self.maxWidth = width;
        self.htmlView.shouldDrawImages = NO;
        self.htmlView.delegate = self;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    return  [self initWithCoreTextView:nil maxWidth:0];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    return  [self initWithCoreTextView:nil maxWidth:0];
}
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame {
    if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        imageView.delegate = self;
        imageView.url = attachment.contentURL;
//        imageView.backgroundColor = [UIColor colorWithHexString:@"e7e8ec"];
        UIImageView *placeholderImageView = [[UIImageView alloc] init];
        placeholderImageView.image = [UIImage imageNamed:@"图片占位图"];
        [imageView addSubview:placeholderImageView];
        [placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(180.0f, 180.0f));
            make.center.equalTo(imageView);
        }];
        placeholderImageView.tag = 10086;
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

- (void)linkPushed:(DTLinkButton *)button {
    BLOCK_EXEC(self.linkPushedBlock,[button.URL absoluteURL]);
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


#pragma mark - DTLazyImageViewDelegate
- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size {
    UIImageView *imageView = [lazyImageView viewWithTag:10086];
    [imageView removeFromSuperview];
    NSURL *url = lazyImageView.url;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    CGFloat maxWidth = self.maxWidth;
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
- (void)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView didDrawLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame inContext:(CGContextRef)context {
    BLOCK_EXEC(self.heightChangeBlock,ceilf(layoutFrame.frame.size.height));
}

#pragma mark - set 
- (void)setCoreTextViewrRelayoutBlock:(CoreTextViewrRelayoutBlock)block {
    self.relayoutBlock = block;
}

- (void)setCoreTextViewLinkPushedBlock:(CoreTextViewLinkPushedBlock)block {
    self.linkPushedBlock = block;
}

- (void)setCoreTextViewHeightChangeBlock:(CoreTextViewHeightChangeBlock)block {
    self.heightChangeBlock = block;
}

@end
