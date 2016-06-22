//
//  YXDatumSearchViewController.m
//  YanXiuApp
//
//  Created by niuzhaowang on 15/9/1.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXDatumSearchViewController.h"
#import "YXDatumSearchCell.h"
#import "YXDatumSearchBarView.h"
#import "YXDatumSearchFetcher.h"
#import "YXAttachmentTypeHelper.h"
//#import "YXPagedListEmptyView.h"
//#import "UIViewController+YXPreviewAttachment.h"

@interface YXDatumSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,YXDatumSearchBarViewDelegate>
@property (nonatomic, strong) NSMutableArray *mockArray;
@property (nonatomic, strong) YXDatumSearchBarView *searchBarView;
@end

@implementation YXDatumSearchViewController

- (void)viewDidLoad {
    self.bNeedHeader = FALSE;
//    YXPagedListEmptyView *emptyView = [[YXPagedListEmptyView alloc] init];
//    emptyView.iconName = @"资料";
//    emptyView.title = @"没有找到符合条件的资源";
//    self.emptyView = emptyView;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupDataFetcher{
    YXDatumSearchFetcher *dataFetcher = [[YXDatumSearchFetcher alloc]init];
    dataFetcher.pagesize = 20;
    NSDictionary *dic = @{@"interf":@"SearchKeywords",@"source":@"ios"};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    if (error) {
        dataFetcher.condition = nil;
    } else {
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        dataFetcher.condition = jsonString;
    }
    self.dataFetcher = dataFetcher;
}

- (void)setupUI{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.searchBarView = [[YXDatumSearchBarView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.searchBarView.delegate = self;
    [self.navigationController.navigationBar addSubview:self.searchBarView];
    
//    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[YXDatumSearchCell class] forCellReuseIdentifier:@"datum_search_cell"];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"datum_search_cell";
    YXDatumSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[YXDatumSearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.cellModel = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"datum_search_cell" configuration:^(YXDatumSearchCell *cell) {
        cell.cellModel = self.dataArray[indexPath.row];
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXDatumCellModel *data = self.dataArray[indexPath.row];
    YXFileVideoItem *item = [[YXFileVideoItem alloc]init];
    item.name = data.title;
    item.url = data.url;
    item.type = [YXAttachmentTypeHelper fileTypeWithTypeName:data.type];
    item.isLocal = YES;
    if (!data.isFavor) {
        [[YXFileBrowseManager sharedManager]addFavorWithData:[NSObject new] completion:^{
            NSLog(@"Item favor success!");
        }];
    }
    [YXFileBrowseManager sharedManager].fileItem = item;
    [YXFileBrowseManager sharedManager].baseViewController = self;
    [[YXFileBrowseManager sharedManager] browseFile];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBarView hideKeyboard];
}

#pragma mark - YXDatumSearchBarViewDelegate
- (void)searchWithText:(NSString *)text{
    NSLog(@"text:%@",text);
    [self.searchBarView hideKeyboard];
    if (!self.dataFetcher) {
        [self setupDataFetcher];
    }
    YXDatumSearchFetcher *fetcher = (YXDatumSearchFetcher *)self.dataFetcher;
    fetcher.keyWord = text;
    [self firstPageFetch];
}

- (void)searchCancel{
    [self.searchBarView hideKeyboard];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
