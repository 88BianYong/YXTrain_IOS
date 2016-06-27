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

@interface YXAllDatumViewController ()

@property (nonatomic, strong) YXDatumOrderFilterMenuView *menuView;

@property (nonatomic, strong) YXWholeDatumFetcher *wholeDatumFetcher;

@property (nonatomic, strong) YXResourceCollectionRequest *collectionRequest;

@end

@implementation YXAllDatumViewController

- (void)viewDidLoad {
//    self.bIsGroupedTableViewStyle = YES;
    [self setupDataFetcher];
//    YXPagedListEmptyView *emptyView = [[YXPagedListEmptyView alloc] init];
//    emptyView.iconName = @"资料";
//    emptyView.title = @"没有符合条件的资源";
//    self.emptyView = emptyView;
    [super viewDidLoad];
    [self configUI];
    // Do any additional setup after loading the view.
}

- (void)configUI {
    self.menuView = [[YXDatumOrderFilterMenuView alloc]initWithFrame:CGRectZero];
    @weakify(self);
    self.menuView.didSelectedOrderCell = ^(NSString *condition) {
        @strongify(self);
        self.wholeDatumFetcher.condition = condition;
        [self firstPageFetch];
    };
    [self.view addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 60;
    [self.tableView registerClass:[YXAllDatumTableViewCell class] forCellReuseIdentifier:@"YXAllDatumTableViewCell"];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.menuView.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setupDataFetcher{
    self.wholeDatumFetcher = [[YXWholeDatumFetcher alloc]init];
    self.wholeDatumFetcher.pagesize = 20;
    NSDictionary *dic = @{@"interf":@"SearchFilter",@"source":@"ios"};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    if (error) {
        self.wholeDatumFetcher.condition = nil;
    } else {
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        self.wholeDatumFetcher.condition = jsonString;
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
    cell.allDatumCellFavor = ^{
        if (self.collectionRequest) {
            [self.collectionRequest stopRequest];
        }
        self.collectionRequest = [[YXResourceCollectionRequest alloc] init];
        self.collectionRequest.aid = model.aid;
        self.collectionRequest.type = model.type;
        self.collectionRequest.iscollection = @"0";
        @weakify(self);
        [self startLoading];
        [self.collectionRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            @strongify(self);
            [self stopLoading];
            HttpBaseRequestItem *item = (HttpBaseRequestItem *)retItem;
            if (item) {
                model.isFavor = TRUE;
                [self.tableView reloadData];
                [self showToast:@"已保存到\"我的资源\""];
            } else {
                [self showToast:error.localizedDescription];
            }
        }];
    };
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
    if (!data.isFavor) {
        [[YXFileBrowseManager sharedManager]addFavorWithData:data completion:^{
            [self.tableView reloadData];
        }];
    }
    [YXFileBrowseManager sharedManager].fileItem = item;
    [YXFileBrowseManager sharedManager].baseViewController = self;
    [[YXFileBrowseManager sharedManager] browseFile];
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    static NSString *header = @"header";
//    YXDatumFilterHeaderView *hv = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header];
//    if (!hv) {
//        hv = [[YXDatumFilterHeaderView alloc]initWithReuseIdentifier:header];
//    }
//    hv.title = self.filterText;
//    return hv;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (isEmpty(self.filterText)) {
//        return 0.1f;
//    }
//    CGRect rect = [self.filterText boundingRectWithSize:CGSizeMake(tableView.frame.size.width-20, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:NULL];
//    return ceil(rect.size.height) + 20;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.1f;
//}

- (void)setMenuViewFold {
    [self.menuView setOrderFolded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
