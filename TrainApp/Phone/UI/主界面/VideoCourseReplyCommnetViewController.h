//
//  VideoCourseReplyCommnetViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
@class VideoCourseCommentsRequestItem_Body_Comments;
typedef void(^VideoCourseReplyCommnetBlock) (VideoCourseCommentsRequestItem_Body_Comments *comment);
@interface VideoCourseReplyCommnetViewController : YXBaseViewController
@property (nonatomic, copy) NSString *courseId;
- (void)setVideoCourseReplyCommnetBlock:(VideoCourseReplyCommnetBlock)block;
@end
