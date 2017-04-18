//
//  NoticeDetailTableHeaderView.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeAndBriefDetailRequest.h"
static CGFloat kTableViewHeaderFixedHeight = 39.0f + 18.0f + 14.0f + 25.0 + 24.0f + 17.0f ;
static CGFloat kTableViewHeaderOpenAndCloseHeight = 24.0f + 17.0f;
static CGFloat kTableViewHeaderHtmlPlaceholdeHeight = 300.0f;
typedef void(^NoticeAndBriefDetailHtmlOpenAndCloseBlock)(BOOL isStatus);
typedef void(^NoticeAndBriefDetailHtmlHeightChangeBlock) (CGFloat htmlHeight, CGFloat labelHeight);
@interface NoticeAndBriefDetailTableHeaderView : UIView
@property (nonatomic, strong) NoticeAndBriefDetailRequestItem_Body *body;
@property (nonatomic, assign, readonly) CGFloat changeHeight;

- (void)setNoticeAndBriefDetailHtmlOpenAndCloseBlock:(NoticeAndBriefDetailHtmlOpenAndCloseBlock)block;
- (void)setNoticeAndBriefDetailHtmlHeightChangeBlock:(NoticeAndBriefDetailHtmlHeightChangeBlock)block;
- (void)relayoutHtmlText;
@end
