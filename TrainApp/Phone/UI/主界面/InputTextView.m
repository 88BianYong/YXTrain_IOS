//
//  InputTextView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//
static CGFloat kInputTextViewMinHeight = 36.0f;
static CGFloat kInputTextViewMaxHeight = 200.0f;
static NSUInteger kPlaceHoldermaxChars = 33;
#import "InputTextView.h"
@interface InputTextView ()<UITextViewDelegate>
@property (nonatomic, assign) CGFloat previousTextViewContentHeight;
@property (nonatomic, copy) InputTextViewHeightBlock heightBlock;
@end
@implementation InputTextView
- (void)dealloc {
    _placeHolder = nil;
    _placeHolderTextColor = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self setupUI];
        self.previousTextViewContentHeight = ceilf([self sizeThatFits:self.frame.size].height);
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveTextDidChangeNotification:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
        _placeHolderTextColor = [UIColor colorWithHexString:@"a1a7ae"];

    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.layer.cornerRadius = 15.0f;
    self.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    self.layer.borderColor = [UIColor colorWithHexString:@"d0d2d5"].CGColor;
    self.backgroundColor = [UIColor whiteColor];
    self.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 8.0f);
    self.contentInset = UIEdgeInsetsZero;
    self.scrollEnabled = YES;
    self.scrollsToTop = NO;
    self.userInteractionEnabled = YES;
    self.font = [UIFont systemFontOfSize:14.0f];
    self.textColor = [UIColor blackColor];
    self.keyboardAppearance = UIKeyboardAppearanceDark;
    self.keyboardType = UIReturnKeySend;
    self.returnKeyType = UIReturnKeyDefault;
    self.textAlignment = NSTextAlignmentLeft;
    self.enablesReturnKeyAutomatically = YES;
    self.delegate = self;
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if([self.text length] == 0 && self.placeHolder) {
        CGRect placeHolderRect = CGRectMake(10.0f,
                                            7.0f,
                                            rect.size.width,
                                            rect.size.height);
        [self.placeHolderTextColor set];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = self.textAlignment;
        
        [self.placeHolder drawInRect:placeHolderRect
                      withAttributes:@{ NSFontAttributeName : self.font,
                                        NSForegroundColorAttributeName : self.placeHolderTextColor,
                                        NSParagraphStyleAttributeName : paragraphStyle }];
    }
}

#pragma mark - setter
- (void)setPlaceHolder:(NSString *)placeHolder {
    if([placeHolder isEqualToString:_placeHolder]) {
        return;
    }
    
    NSUInteger maxChars = kPlaceHoldermaxChars;
    if([placeHolder length] > maxChars) {
        placeHolder = [placeHolder substringToIndex:maxChars - 8];
        placeHolder = [[placeHolder stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByAppendingFormat:@"..."];
    }
    _placeHolder = placeHolder;
    [self setNeedsDisplay];
}

- (void)setPlaceHolderTextColor:(UIColor *)placeHolderTextColor {
    if([placeHolderTextColor isEqual:_placeHolderTextColor]) {
        return;
    }
    _placeHolderTextColor = placeHolderTextColor;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    [self setNeedsDisplay];
}

- (void)setInputTextViewHeight:(InputTextViewHeightBlock)block{
    self.heightBlock = block;
}
#pragma mark - Notifications
- (void)didReceiveTextDidChangeNotification:(NSNotification *)notification {
    [self setNeedsDisplay];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    [self willShowInputTextViewToHeight:ceilf([self sizeThatFits:self.frame.size].height)];
}
- (void)willShowInputTextViewToHeight:(CGFloat)toHeight {
    if (toHeight < kInputTextViewMinHeight) {
        toHeight = kInputTextViewMinHeight;
    }
    if (toHeight > kInputTextViewMaxHeight) {
        toHeight = kInputTextViewMaxHeight;
    }
    if (toHeight != self.previousTextViewContentHeight){
        self.previousTextViewContentHeight = toHeight;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(toHeight);
        }];
        BLOCK_EXEC(self.heightBlock,toHeight);
    }
}
@end
