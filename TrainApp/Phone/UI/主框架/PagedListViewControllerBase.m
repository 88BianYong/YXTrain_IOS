//
//  PagedListViewControllerBase.m
//  YanXiuApp
//
//  Created by Lei Cai on 5/21/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "PagedListViewControllerBase.h"

@interface PagedListViewControllerBase () <UITableViewDataSource, UITableViewDelegate> {
    
    
}

@end

@implementation PagedListViewControllerBase

- (id)init {
    self = [super init];
    if (self) {
        _bNeedHeader = YES;
        _bNeedFooter = YES;
        _bIsGroupedTableViewStyle = NO;
    }
    return self;
}

- (void)dealloc
{
    DDLogWarn(@"PagedListViewController Dealloc");
    [self.header free];
    [self.footer free];
    [self.dataFetcher stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentView = [[UIView alloc]init];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    
    // Do any additional setup after loading the view.
    if (self.bIsGroupedTableViewStyle) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    } else {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    self.emptyView = [[YXEmptyView alloc]init];
    self.errorView = [[YXErrorView alloc]init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self startLoading];
        [self firstPageFetch];
    }];
    self.dataErrorView = [[DataErrorView alloc]init];
    [self.dataErrorView setRefreshBlock:^{
        STRONG_SELF
        [self startLoading];
        [self firstPageFetch];
    }];
    
    if (self.bNeedFooter) {
        self.footer = [MJRefreshFooterView footer];
        self.footer.scrollView = self.tableView;
        self.footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
            STRONG_SELF
            [self morePageFetch];
        };
        self.footer.alpha = 0;
    }
    
    if (self.bNeedHeader) {
        self.header = [MJRefreshHeaderView header];
        self.header.scrollView = self.tableView;
        self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
            STRONG_SELF
            [self firstPageFetch];
        };
    }
    
    self.dataArray = [NSMutableArray array];
    [self.dataArray addObjectsFromArray:[self.dataFetcher cachedItemArray]];
    self.total = [self.dataArray count];
    [self startLoading];
    [self firstPageFetch];
}
- (void)firstPageFetch {
    if (!self.dataFetcher) {
        return;
    }
    
    [self.dataFetcher stop];
    self.dataFetcher.pageindex = 0;
    if (!self.dataFetcher.pagesize) {
        self.dataFetcher.pagesize = 20;
    }
    WEAK_SELF
    [self.dataFetcher startWithBlock:^(NSInteger total, NSArray *retItemArray, NSError *error) {
        STRONG_SELF
        self.tableView.tableHeaderView.hidden = NO;
        self.tableView.hidden = NO;
        [self stopLoading];
        [self stopAnimation];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = retItemArray.count != 0;
        data.localDataExist = self.dataArray.count != 0;
        data.error = error;
        if ([self handleRequestData:data inView:self.contentView]) {
            return;
        }
        self.total = total;
        [self tableViewWillRefresh];
        [self.header setLastUpdateTime:[NSDate date]];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:retItemArray];
        [self checkHasMore];
        [self.dataFetcher saveToCache];
//        self.tableView.contentOffset = CGPointZero;
        [self.tableView reloadData];
    }];
}

- (void)tableViewWillRefresh {
    
}

- (void)stopAnimation {
    [self.header endRefreshing];
}

- (void)setPulldownViewHidden:(BOOL)hidden {
    self.header.alpha = hidden ? 0:1;
}

- (void)setPullupViewHidden:(BOOL)hidden {
    self.footer.alpha = hidden ? 0:1;
}

- (void)morePageFetch {
    [self.dataFetcher stop];
    self.dataFetcher.pageindex++;
    WEAK_SELF
    [self.dataFetcher startWithBlock:^(NSInteger total, NSArray *retItemArray, NSError *error) {
        STRONG_SELF
        [self.footer endRefreshing];
        if (error) {
            self.dataFetcher.pageindex--;
            [self showToast:error.localizedDescription];
            return;
        }
        [self.dataArray addObjectsFromArray:retItemArray];
        self.total = total;
        [self.tableView reloadData];
        [self checkHasMore];
    }];
}

- (void)checkHasMore {
    // there is a bug is MJRefresh, so we use alpha instead of hidden
    [self setPullupViewHidden:[self.dataArray count] >= self.total];
}
#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [self.dataArray count];
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
