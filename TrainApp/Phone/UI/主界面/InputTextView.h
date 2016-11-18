//
//  InputTextView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^InputTextViewHeightBlock)(CGFloat height);
@interface InputTextView : UITextView
@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, strong) UIColor *placeHolderTextColor;

- (void)setInputTextViewHeight:(InputTextViewHeightBlock)block;
@end
