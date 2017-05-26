//
//  VideoCourseSecondCommentViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoCourseCommentViewController.h"
typedef void(^VideoCourseSecondCommentRefreshBlock) (NSInteger chooseInteger,NSInteger totalNumber);
@interface VideoCourseSecondCommentViewController : VideoCourseCommentViewController
@property (nonatomic, strong) VideoCourseCommentsRequestItem_Body_Comments *comment;
@property (nonatomic, assign) NSInteger chooseInteger;
@property (nonatomic, assign) BOOL isShowInputView;
- (void)setVideoCourseSecondCommentRefreshBlock:(VideoCourseSecondCommentRefreshBlock)block;
@end
