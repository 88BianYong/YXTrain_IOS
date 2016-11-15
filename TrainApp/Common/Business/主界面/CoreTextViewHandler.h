//
//  CoreTextViewHandler.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreTextViewHandler : UIControl
@property (nonatomic, strong) void(^relayoutBlock)();
@property (nonatomic, strong) void(^heightChangeBlock)(CGFloat height);

+ (NSDictionary *)defaultCoreTextOptions;

- (instancetype)initWithCoreTextView:(DTAttributedTextContentView *)view
                            maxWidth:(CGFloat)width NS_DESIGNATED_INITIALIZER;
@end
