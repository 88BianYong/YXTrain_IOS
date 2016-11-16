//
//  CommentPageListViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/14.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
@class CommentPagedListFetcher;
@interface CommentPageListViewController : YXBaseViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CommentPagedListFetcher *dataFetcher;
@property (nonatomic, strong) NSMutableArray *dataMutableArray;
- (void)setupUI;
- (void)setupLayout;
- (void)stopAnimation;
@end
