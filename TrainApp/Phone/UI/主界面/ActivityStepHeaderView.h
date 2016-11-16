//
//  ActivityStepHeaderView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityListRequest.h"
typedef void(^ActivityHtmlOpenAndCloseBlock)(BOOL isStatus);
typedef void(^ActivityHtmlHeightChangeBlock) (BOOL height);
@interface ActivityStepHeaderView : UIView
@property (nonatomic, strong) ActivityListRequestItem_Body_Activity_Steps *activityStep;
@property (nonatomic, assign, readonly) CGFloat htmlHeight;
- (void)setActivityHtmlOpenAndCloseBlock:(ActivityHtmlOpenAndCloseBlock)block;
- (void)setActivityHtmlHeightChangeBlock:(ActivityHtmlHeightChangeBlock)block;
- (void)relayoutHtmlText;
@end
