//
//  ActivityDetailTableHeaderView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityListRequest.h"
//根据UI计算结果
static CGFloat kTableViewHeaderFixedHeight = 346.0f;
static CGFloat kTableViewHeaderOpenAndCloseHeight = 50.0f;
static CGFloat kTableViewHeaderHtmlPlaceholdeHeight = 300.0f;
typedef void(^ActivityHtmlOpenAndCloseBlock)(BOOL isStatus);
typedef void(^ActivityHtmlHeightChangeBlock) (CGFloat htmlHeight, CGFloat labelHeight);
@interface ActivityDetailTableHeaderView : UIView
@property (nonatomic, strong) ActivityListRequestItem_body_activity *activity;
@property (nonatomic, assign, readonly) CGFloat changeHeight;
- (void)setActivityHtmlOpenAndCloseBlock:(ActivityHtmlOpenAndCloseBlock)block;
- (void)setActivityHtmlHeightChangeBlock:(ActivityHtmlHeightChangeBlock)block;
- (void)relayoutHtmlText;
@end
