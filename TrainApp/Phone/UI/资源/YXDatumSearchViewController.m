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
#import "YXAllDatumTableViewCell.h"
#import "YXDatumSearchView.h"
#import "YXPagedListEmptyView.h"
//#import "UIViewController+YXPreviewAttachment.h"

@interface YXDatumSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *mockArray;
//@property (nonatomic, strong) YXDatumSearchBarView *searchBarView;
@end

@implementation YXDatumSearchViewController

- (void)viewDidLoad {
    //self.bNeedHeader = FALSE;
    YXPagedListEmptyView *emptyView = [[YXPagedListEmptyView alloc] init];
    emptyView.iconName = @"资料";
    emptyView.title = @"没有找到符合条件的资源";
    self.emptyView = emptyView;
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupDataFetcher];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self firstPageFetch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupDataFetcher{
    [self setNavigationBar];
    YXDatumSearchFetcher *dataFetcher = [[YXDatumSearchFetcher alloc]init];
    dataFetcher.keyWord = self.keyWord;
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
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[YXAllDatumTableViewCell class] forCellReuseIdentifier:@"YXAllDatumTableViewCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 3)];
    tableViewHeaderView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.tableHeaderView = tableViewHeaderView;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXAllDatumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXAllDatumTableViewCell" forIndexPath:indexPath];
    YXDatumCellModel *model = self.dataArray[indexPath.row];
    cell.cellModel = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"YXAllDatumTableViewCell" configuration:^(YXDatumSearchCell *cell) {
        YXDatumCellModel *model = self.dataArray[indexPath.row];
        cell.cellModel = model;
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXDatumCellModel *data = self.dataArray[indexPath.row];
    YXFileVideoItem *item = [[YXFileVideoItem alloc]init];
    item.name = data.title;
    item.url = data.url;
    item.type = [YXAttachmentTypeHelper fileTypeWithTypeName:data.type];
    if (!data.isFavor) {
        [[YXFileBrowseManager sharedManager]addFavorWithData:data completion:^{
            [self.tableView reloadData];
        }];
    }
    [YXFileBrowseManager sharedManager].fileItem = item;
    [YXFileBrowseManager sharedManager].baseViewController = self;
    [[YXFileBrowseManager sharedManager] browseFile];
}


- (void)setNavigationBar {
    YXDatumSearchView *seachView = [[YXDatumSearchView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    [seachView setTextFieldWithString:self.keyWord];
    seachView.searchTextField.clearButtonMode = UITextFieldViewModeAlways;
    seachView.textBeginEdit = ^{
    };
    seachView.texEndEdit = ^{
    };
    seachView.textShouldClear = ^{
    };
    seachView.textShouldReturn = ^(NSString *text){
        if (!self.dataFetcher) {
            [self setupDataFetcher];
        }
        YXDatumSearchFetcher *fetcher = (YXDatumSearchFetcher *)self.dataFetcher;
        fetcher.keyWord = text;
        [self firstPageFetch];
    };
    seachView.cancelButtonClickedBlock = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    self.navigationItem.titleView = seachView;
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.leftBarButtonItems = nil;
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

@end
