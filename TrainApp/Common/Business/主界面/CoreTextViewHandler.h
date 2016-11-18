//
//  CoreTextViewHandler.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^CoreTextViewHeightChangeBlock) (CGFloat height);
typedef void (^CoreTextViewrRelayoutBlock) ();
typedef void (^CoreTextViewLinkPushedBlock) (NSURL *url);

@interface CoreTextViewHandler : UIControl
+ (NSDictionary *)defaultCoreTextOptions;
- (instancetype)initWithCoreTextView:(DTAttributedTextContentView *)view
                            maxWidth:(CGFloat)width NS_DESIGNATED_INITIALIZER;

- (void)setCoreTextViewHeightChangeBlock:(CoreTextViewHeightChangeBlock)block;
- (void)setCoreTextViewrRelayoutBlock:(CoreTextViewrRelayoutBlock)block;
- (void)setCoreTextViewLinkPushedBlock:(CoreTextViewLinkPushedBlock)block;
@end
