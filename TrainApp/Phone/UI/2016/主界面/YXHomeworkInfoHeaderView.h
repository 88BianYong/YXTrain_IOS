//
//  YXHomeworkInfoHeaderView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/4.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YXHomeworkInfoRequestItem_Body;
static CGFloat kTableViewHeaderFixedHeight = 230.0f + 24.0f + 17.0f;
static CGFloat kTableViewHeaderOpenAndCloseHeight = 24.0f + 17.0f;
static CGFloat kTableViewHeaderHtmlPlaceholdeHeight = 300.0f;
typedef void(^HomeworkHtmlOpenAndCloseBlock)(BOOL isStatus);
typedef void(^HomeworkHtmlHeightChangeBlock) (void);
@interface YXHomeworkInfoHeaderView : UIView
@property (nonatomic ,strong) YXHomeworkInfoRequestItem_Body *body;
@property (nonatomic, assign, readonly) CGFloat changeHeight;

- (void)setHomeworkHtmlOpenAndCloseBlock:(HomeworkHtmlOpenAndCloseBlock)block;
- (void)setHomeworkHtmlHeightChangeBlock:(HomeworkHtmlHeightChangeBlock)block;
- (void)relayoutHtmlText;
@end
