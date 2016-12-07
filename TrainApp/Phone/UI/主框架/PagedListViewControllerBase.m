//
//  PagedListViewControllerBase.m
//  YanXiuApp
//
//  Created by Lei Cai on 5/21/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "PagedListViewControllerBase.h"
#import "MJRefresh.h"

@interface PagedListViewControllerBase () <UITableViewDataSource, UITableViewDelegate> {
    int _total;
    
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    NSString *_emptyImageString;
    NSString *_emptyTitleString;
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
    [_header free];
    [_footer free];
    [self.dataFetcher stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    if (self.bIsGroupedTableViewStyle) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    } else {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    self.emptyView.hidden = YES;
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(@0);
    }];
    
    self.errorView = [[YXErrorView alloc]init];
    @weakify(self);
    [self.errorView setRetryBlock:^{
        @strongify(self); if (!self) return;
        [self startLoading];
        [self firstPageFetch:YES];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(@0);
    }];
    [self hideErrorView];
    
    self.dataErrorView = [[DataErrorView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.dataErrorView];
    self.dataErrorView.hidden = YES;
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self firstPageFetch:YES];
    };
    
    if (self.bNeedFooter) {
        _footer = [MJRefreshFooterView footer];
        _footer.scrollView = self.tableView;
        _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
            @strongify(self); if (!self) return;
            [self morePageFetch];
        };
        _footer.alpha = 0;
    }
    
    if (self.bNeedHeader) {
        _header = [MJRefreshHeaderView header];
        _header.scrollView = self.tableView;
        _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
            @strongify(self); if (!self) return;
            [self firstPageFetch:NO];
        };
    }
    
    self.dataArray = [NSMutableArray array];
    [self.dataArray addObjectsFromArray:[self.dataFetcher cachedItemArray]];
    _total = (int)[self.dataArray count];

    [self firstPageFetch:YES];
    _emptyImageString = self.emptyView.imageName;
    _emptyTitleString = self.emptyView.title;
}

- (void)firstPageFetch:(BOOL)isShow {
    if (!self.dataFetcher) {
        return;
    }
    
    [self.dataFetcher stop];
    
    // 1, load cache
//    [self.dataArray removeAllObjects];
//    [self.dataArray addObjectsFromArray:[self.dataFetcher cachedItemArray]];
//    _total = (int)[self.dataArray count];
    
    // 2, fetch
    self.dataFetcher.pageindex = 0;
    if (!self.dataFetcher.pagesize) {
        self.dataFetcher.pagesize = 20;
    }
    if (isShow) {
        [self startLoading];
    }
    @weakify(self);
    [self.dataFetcher startWithBlock:^(int total, NSArray *retItemArray, NSError *error) {
        @strongify(self); if (!self) return;
        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self); if (!self) return;
            [self tableViewWillRefresh];
            [self stopLoading];
            [self stopAnimation];
            if (error) {
                if (isEmpty(self.dataArray)) {  // no cache 强提示, 加载失败界面
                    self->_total = 0;
                    if (error.code == -2) {
                        self.dataErrorView.hidden = NO;
                        [self.view bringSubviewToFront:self.dataErrorView];
                    }else{
                        [self showErroView];
                    }
                } else {
                    self->_total = 0;
                    [self showToast:error.localizedDescription];
                }
                [self checkHasMore];
                return;
            }
            
            // 隐藏失败界面
            [self hideErrorView];
            self.dataErrorView.hidden = YES;
            [self->_header setLastUpdateTime:[NSDate date]];
            self->_total = total;
            [self.dataArray removeAllObjects];
            
            if (isEmpty(retItemArray)) {
                self.emptyView.imageName = self ->_emptyImageString;
                self.emptyView.title = self ->_emptyTitleString;
                self.emptyView.hidden = NO;
            } else {
                self.emptyView.hidden = YES;
                [self.dataArray addObjectsFromArray:retItemArray];
                [self checkHasMore];
                [self.dataFetcher saveToCache];
            }
            self.tableView.contentOffset = CGPointZero;
            [self.tableView reloadData];
        });
    }];
}

- (void)tableViewWillRefresh
{
    
}

- (void)stopAnimation
{
    [self->_header endRefreshing];
}

- (void)setPulldownViewHidden:(BOOL)hidden
{
    _header.alpha = hidden ? 0:1;
}

- (void)setPullupViewHidden:(BOOL)hidden
{
    _footer.alpha = hidden ? 0:1;
}

- (void)morePageFetch {
    [self.dataFetcher stop];
    self.dataFetcher.pageindex++;
    @weakify(self);
    [self.dataFetcher startWithBlock:^(int total, NSArray *retItemArray, NSError *error) {
        @strongify(self); if (!self) return;
        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self); if (!self) return;
            [self->_footer endRefreshing];
            if (error) {
                self.dataFetcher.pageindex--;
                [self showToast:error.localizedDescription];
                return;
            }
            
            [self.dataArray addObjectsFromArray:retItemArray];
            self->_total = total;
            [self.tableView reloadData];
            [self checkHasMore];
        });
    }];
}

- (void)showErroView {
//    [self.view addSubview:self.errorView];
//    [self.errorView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(@0);
//    }];
    self.errorView.hidden = NO;
    [self.view bringSubviewToFront:self.errorView];
}

- (void)hideErrorView {
//    [self.errorView removeFromSuperview];
    self.errorView.hidden = YES;
}

- (void)checkHasMore {
    // there is a bug is MJRefresh, so we use alpha instead of hidden
    [self setPullupViewHidden:[self.dataArray count] >= _total];
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
