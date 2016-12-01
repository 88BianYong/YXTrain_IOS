//
//  ActivityStepHeaderView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityListRequest.h"
static CGFloat kTableViewHeaderFixedHeight = 37.0f + 44.0f + 14.0f +22.0f + 12.0f + 17.0f;
static CGFloat kTableViewHeaderOpenAndCloseHeight = 12.0f + 17.0f;
static CGFloat kTableViewHeaderHtmlPlaceholdeHeight = 300.0f;
typedef void(^ActivityHtmlOpenAndCloseBlock)(BOOL isStatus);
typedef void(^ActivityHtmlHeightChangeBlock) (CGFloat htmlHeight, CGFloat labelHeight);
@interface ActivityStepHeaderView : UIView
@property (nonatomic, strong) ActivityListRequestItem_Body_Activity_Steps *activityStep;
@property (nonatomic, assign, readonly) CGFloat changeHeight;

- (void)setActivityHtmlOpenAndCloseBlock:(ActivityHtmlOpenAndCloseBlock)block;
- (void)setActivityHtmlHeightChangeBlock:(ActivityHtmlHeightChangeBlock)block;
- (void)relayoutHtmlText;
@end
