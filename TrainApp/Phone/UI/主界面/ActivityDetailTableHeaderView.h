//
//  ActivityDetailTableHeaderView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityListRequest.h"
typedef void(^ActivityHtmlOpenAndCloseBlock)(BOOL isStatus);
typedef void(^ActivityHtmlHeightChangeBlock) (CGFloat height);
@interface ActivityDetailTableHeaderView : UIView
@property (nonatomic, strong) ActivityListRequestItem_body_activity *activity;
@property (nonatomic, assign, readonly) CGFloat changeHeight;
- (void)setActivityHtmlOpenAndCloseBlock:(ActivityHtmlOpenAndCloseBlock)block;
- (void)setActivityHtmlHeightChangeBlock:(ActivityHtmlHeightChangeBlock)block;
- (void)relayoutHtmlText;
@end
