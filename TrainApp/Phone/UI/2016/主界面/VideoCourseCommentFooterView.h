//
//  VideoCourseCommentFooterView.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^VideoCourseAllCommentReplyBlock) (void);
@interface VideoCourseCommentFooterView : UITableViewHeaderFooterView
@property (nonatomic, copy) NSString *childNum;
- (void)setVideoCourseAllCommentReplyBlock:(VideoCourseAllCommentReplyBlock)block;
@end
