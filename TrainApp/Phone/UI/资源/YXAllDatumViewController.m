//
//  YXAllDatumViewController.m
//  TrainApp
//
//  Created by 李五民 on 16/6/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXAllDatumViewController.h"
#import "YXDatumOrderFilterMenuView.h"
#import "YXDatumOrderModel.h"
#import "YXDatumOrderView.h"
#import "YXWholeDatumFetcher.h"
#import "YXAllDatumTableViewCell.h"
#import "YXAttachmentTypeHelper.h"
#import "YXResourceCollectionRequest.h"
#import "YXPagedListEmptyView.h"

@interface YXAllDatumViewController ()

@property (nonatomic, strong) YXDatumOrderFilterMenuView *menuView;

@property (nonatomic, strong) YXWholeDatumFetcher *wholeDatumFetcher;

@property (nonatomic, strong) YXResourceCollectionRequest *collectionRequest;

@property (nonatomic, copy) NSString *currentConditon;//错误刷新用到

@end

@implementation YXAllDatumViewController

- (void)viewDidLoad {
    //self.bIsGroupedTableViewStyle = YES;
    [self setupDataFetcher];
    YXEmptyView *emptyView = [[YXEmptyView alloc]init];
    emptyView.imageName = @"暂无资源";
    emptyView.title = @"没有符合条件的资源";
    self.emptyView = emptyView;

    [super viewDidLoad];
    [self configUI];
    // Do any additional setup after loading the view.
}

- (void)configUI {
    [self.emptyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.left.right.bottom.mas_equalTo(0);
    }];
    self.emptyView.hidden = YES;
    [self.errorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.left.right.bottom.mas_equalTo(0);
    }];
    @weakify(self);
    self.errorView.retryBlock = ^(){
        @strongify(self);
        [self startLoading];
        [self firstPageFetch];
    };
    self.view.backgroundColor = [UIColor redColor];
    self.menuView = [[YXDatumOrderFilterMenuView alloc]initWithFrame:CGRectZero];
    self.menuView.refreshFilterBlock = ^(NSString *condition) {
        @strongify(self);
        self.currentConditon = condition;
        [self.tableView setContentOffset:CGPointZero];
        [self firstPageFetch];
    };
    [self.view addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.estimatedRowHeight = 800;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YXAllDatumTableViewCell class] forCellReuseIdentifier:@"YXAllDatumTableViewCell"];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.menuView.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 3)];
    tableViewHeaderView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.tableHeaderView = tableViewHeaderView;
}

- (void)firstPageFetch {
    self.wholeDatumFetcher.condition = self.currentConditon;
    [super firstPageFetch];
}

- (void)setupDataFetcher{
    self.wholeDatumFetcher = [[YXWholeDatumFetcher alloc]init];
    self.wholeDatumFetcher.pagesize = 20;
    NSDictionary *dic = @{@"interf":@"SearchFilter",@"source":@"ios"};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    if (error) {
        self.wholeDatumFetcher.condition = nil;
        self.currentConditon = nil;
    } else {
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        self.wholeDatumFetcher.condition = jsonString;
        self.currentConditon = jsonString;
    }
    self.dataFetcher = self.wholeDatumFetcher;
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
    return [tableView fd_heightForCellWithIdentifier:@"YXAllDatumTableViewCell" configuration:^(YXAllDatumTableViewCell *cell) {
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
    if(item.type == YXFileTypeUnknown) {
        [self showToast:@"暂不支持该格式文件预览"];
        return;
    }
    if (!data.isFavor) {
        [[YXFileBrowseManager sharedManager]addFavorWithData:data completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:YXFavorSuccessNotification object:data userInfo:nil];
            [self.tableView reloadData];
        }];
    }
    [YXFileBrowseManager sharedManager].fileItem = item;
    [YXFileBrowseManager sharedManager].baseViewController = self;
    [[YXFileBrowseManager sharedManager] browseFile];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.tableView.showsVerticalScrollIndicator = YES;

}

- (void)viewWillDisappear:(BOOL)animated {
    self.tableView.showsVerticalScrollIndicator = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
