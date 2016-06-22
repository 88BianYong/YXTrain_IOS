//
//  PagedListViewControllerBase.h
//  YanXiuApp
//
//  Created by Lei Cai on 5/21/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "YXBaseViewController.h"
#import "PagedListFetcherBase.h"
#import "YXCommonErrorView.h"

@interface PagedListViewControllerBase : YXBaseViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL bIsGroupedTableViewStyle;    // currently trick
@property (nonatomic, strong) NSMutableArray *dataArray;        // the model
@property (nonatomic, assign) BOOL bNeedHeader;
@property (nonatomic, assign) BOOL bNeedFooter;

@property (nonatomic, strong) PagedListFetcherBase *dataFetcher;
@property (nonatomic, strong) YXCommonErrorView *errorView;

@property (nonatomic, strong) UIView *emptyView;

- (void)firstPageFetch;
- (void)stopAnimation;
- (void)setPulldownViewHidden:(BOOL)hidden;
- (void)setPullupViewHidden:(BOOL)hidden;

@property (nonatomic, assign) int emptyViewTopInset;

- (void)tableViewWillRefresh;
@end
