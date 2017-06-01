//
//  ActivityCommentInputView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ActivityCommentShowInputViewBlock) (BOOL isShow);
typedef void(^ActivityCommentInputTextBlock) (NSString *inputText);
@interface ActivityCommentInputView : UIView
@property (nonatomic, strong) SAMTextView *textView;
@property (nonatomic, copy) NSString *stageId;
@property (nonatomic, assign) NSInteger maxTextNumber;

- (void)setActivityCommentShowInputViewBlock:(ActivityCommentShowInputViewBlock)block;
- (void)setActivityCommentInputTextBlock:(ActivityCommentInputTextBlock)block;
- (void)inputTextViewClear;
@end
