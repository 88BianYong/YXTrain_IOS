//
//  VideoCourseCommentViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
#import "VideoCourseCommentsRequest.h"
#import "VideoCourseCommentHeaderView.h"
@class VideoCourseCommentsFetcher;
@interface VideoCourseCommentViewController : YXBaseViewController
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, copy) NSString *parentID;
@property (nonatomic, copy) NSString *courseId;
@property (nonatomic, strong) VideoCourseCommentsFetcher *dataFetcher;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray<VideoCourseCommentsRequestItem_Body_Comments *> *dataMutableArray;
@property (nonatomic, assign) BOOL isFullReply;

- (void)setupUI;
- (void)setupLayout;
- (void)formatCommentContent;
- (void)userPublishComment;//需要全部回复界面实现
- (void)firstShowInputView;//需要全部回复界面实现
- (void)requestForCommentLaud:(NSInteger)integer;
@end
