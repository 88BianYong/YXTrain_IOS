//
//  CommentPageListViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/14.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
#import "ActivityFirstCommentRequest.h"
#import "ActivityStepListRequest.h"
@class CommentPagedListFetcher;
@interface CommentPageListViewController : YXBaseViewController
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *stageId;
@property (nonatomic, strong) CommentPagedListFetcher *dataFetcher;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *dataMutableArray;
@property (nonatomic, strong) ActivityStepListRequestItem_Body_Active_Steps_Tools *tool;
@property (nonatomic, assign) NSInteger totalNum;
@property (nonatomic, assign) BOOL isFullReply;



- (void)setupUI;
- (void)setupLayout;
- (void)formatCommentContent;
- (void)userPublishComment;//需要全部回复界面实现
- (void)firstShowInputView;//需要全部回复界面实现
@end
