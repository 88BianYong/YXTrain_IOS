//
//  CommentPageListViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/14.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
#import "ActivityFirstCommentRequest.h"
@class CommentPagedListFetcher;
@interface CommentPageListViewController : YXBaseViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CommentPagedListFetcher *dataFetcher;
@property (nonatomic, strong) NSMutableArray *dataMutableArray;
@property (nonatomic, assign) BOOL isHiddenInputView;
- (void)setupUI;
- (void)setupLayout;
- (void)inputActitvityCommentReply:(ActivityFirstCommentRequestItem_Body_Replies *)replies;
- (void)reportActitvityCommentReply:(NSString *)replyString;
@end
