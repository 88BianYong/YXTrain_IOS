//
//  VideoCourseCommentHeaderView.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCourseCommentsRequest.h"
static NSString *kContentSeparator = @"<br />";
static NSString *kNameSeparator = @"：";
static CGFloat kDistanceTopLong = 30.0f;
static CGFloat kDistanceTopMiddle = 15.0f;
static CGFloat kDistanceTopShort = 15.0f;
typedef void(^CourseCommentsFullReplyBlock) (VideoCourseCommentsRequestItem_Body_Comments * replie);

typedef void(^CourseCommentsFavorBlock) (void);
@interface VideoCourseCommentHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) VideoCourseCommentsRequestItem_Body_Comments *comment;
@property (nonatomic, assign) BOOL isFontBold;
@property (nonatomic, assign) BOOL isShowLine;

- (void)setCourseCommentsFavorBlock:(CourseCommentsFavorBlock)block;
- (void)setCourseCommentsFullReplyBlock:(CourseCommentsFullReplyBlock)block;
@end
