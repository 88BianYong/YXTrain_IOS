//
//  CommentPageListViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/14.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "CommentPageListViewController.h"
#import "MJRefresh.h"
#import "CommentPagedListFetcher.h"
#import "ActivityCommentTableView.h"
@interface CommentPageListViewController ()
@property (nonatomic, assign) int totalPage;
@property (nonatomic, strong) MJRefreshFooterView *footerView;
@property (nonatomic, strong) MJRefreshHeaderView *headerView;
@end

@implementation CommentPageListViewController

- (void)dealloc
{
    DDLogWarn(@"PagedListViewController Dealloc");
    [self.headerView free];
    [self.footerView free];
    [self.dataFetcher stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
    [self firstPageFetch:YES];

}
- (void)setupUI {
    self.tableView = [[ActivityCommentTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    self.emptyView = [[YXEmptyView alloc] init];
    self.emptyView.hidden = YES;
    [self.view addSubview:self.emptyView];
    
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.hidden = YES;
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self startLoading];
        [self firstPageFetch:YES];
    }];
    [self.view addSubview:self.errorView];
    
    self.dataErrorView = [[DataErrorView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.dataErrorView];
    self.dataErrorView.hidden = YES;
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self firstPageFetch:YES];
    };
    
    self.footerView = [MJRefreshFooterView footer];
    self.footerView.scrollView = self.tableView;
    self.footerView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self morePageFetch];
    };
    self.footerView.alpha = 0;
    
    self.headerView = [MJRefreshHeaderView header];
    self.headerView.scrollView = self.tableView;
    self.headerView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self firstPageFetch:NO];
    };
    self.dataMutableArray = [[NSMutableArray alloc] initWithCapacity:10];
    self.totalPage = (int)[self.dataMutableArray count];
}

- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(@0);
    }];
    
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(@0);
    }];
}



- (void)firstPageFetch:(BOOL)isShow {
    if (!self.dataFetcher) {
        return;
    }
    [self.dataFetcher stop];

    self.dataFetcher.pageindex = 0;
    if (!self.dataFetcher.pageSize) {
        self.dataFetcher.pageSize = 20;
    }
    if (isShow) {
        //[self startLoading];
    }
    WEAK_SELF
    [self.dataFetcher startWithBlock:^(int totalPage, int currentPage, NSMutableArray *retItemArray, NSError *error) {
        STRONG_SELF
        WEAK_SELF
        dispatch_async(dispatch_get_main_queue(), ^{
            STRONG_SELF
            [self stopLoading];
            [self stopAnimation];
            if (error) {
                if (isEmpty(self.dataMutableArray)) {
                    self.totalPage = 0;
                    if (error.code == -2) {
                        self.dataErrorView.hidden = NO;
                        [self.view bringSubviewToFront:self.dataErrorView];
                    }else{
                        [self showErroView];
                    }
                } else {
                    self.totalPage = 0;
                    [self showToast:error.localizedDescription];
                }
                [self pullupViewHidden:!(totalPage >= currentPage)];
            }else {
                [self hideErrorView];
                self.dataErrorView.hidden = YES;
                [self.headerView setLastUpdateTime:[NSDate date]];
                self.totalPage = totalPage;
                [self.dataMutableArray removeAllObjects];
                if (isEmpty(retItemArray)) {
                    self.emptyView.hidden = NO;
                } else {
                    self.emptyView.hidden = YES;
                    [self.dataMutableArray addObjectsFromArray:retItemArray];
                    [self pullupViewHidden:!(totalPage >= currentPage)];
                }
                [self.tableView reloadData];
                self.tableView.contentOffset = CGPointZero;
            }
        });
    }];
}

- (void)stopAnimation
{
    [self.headerView endRefreshing];
}

- (void)pulldownViewHidden:(BOOL)hidden
{
    self.headerView.alpha = hidden ? 0:1;
}

- (void)pullupViewHidden:(BOOL)hidden
{
    self.footerView.alpha = hidden ? 0:1;
}

- (void)morePageFetch {
    [self.dataFetcher stop];
    self.dataFetcher.pageindex++;
    WEAK_SELF
    [self.dataFetcher startWithBlock:^(int totalPage, int currentPage, NSMutableArray *retItemArray, NSError *error) {
        STRONG_SELF
        WEAK_SELF
        dispatch_async(dispatch_get_main_queue(), ^{
            STRONG_SELF
            [self.footerView endRefreshing];
            if (error) {
                self.dataFetcher.pageindex--;
                [self showToast:error.localizedDescription];
                return;
            }else {
                [self.dataMutableArray addObjectsFromArray:retItemArray];
                self.totalPage = totalPage;
                [self.tableView reloadData];
                [self pullupViewHidden:!(totalPage >= currentPage)];
            }
        });
    }];
}

- (void)showErroView {
    self.errorView.hidden = NO;
    [self.view bringSubviewToFront:self.errorView];
}

- (void)hideErrorView {
    self.errorView.hidden = YES;
}
#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [self.dataMutableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}
@end
