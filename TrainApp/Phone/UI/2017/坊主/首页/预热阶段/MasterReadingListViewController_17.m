//
//  MasterReadingListViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterReadingListViewController_17.h"
#import "ReadingListRequest_17.h"
#import "ReadingListCell_17.h"
#import "ReadingDetailViewController_17.h"
#import "YXSectionHeaderFooterView.h"
@interface MasterReadingListViewController_17 ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;

@property (nonatomic, strong) ReadingListRequest_17 *listRequest;
@property (nonatomic, strong) ReadingListRequest_17Item *listItem;

@end

@implementation MasterReadingListViewController_17
- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预热阶段";
    [self setupUI];
    [self setupLayout];
    [self startLoading];
    [self requestForReadingList];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    [self.tableView registerClass:[ReadingListCell_17 class] forCellReuseIdentifier:@"ReadingListCell_17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    [self.view addSubview:self.tableView];
    WEAK_SELF
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self requestForReadingList];
    };
    self.emptyView = [[YXEmptyView alloc]init];
    self.dataErrorView = [[DataErrorView alloc]init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self requestForReadingList];
    };
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listItem == nil ? 0 : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listItem.objs.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReadingListCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"ReadingListCell_17" forIndexPath:indexPath];
    cell.reading = self.listItem.objs[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"ReadingListCell_17" configuration:^(ReadingListCell_17 *cell) {
        cell.reading = self.listItem.objs[indexPath.row];
    }];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YXSectionHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ReadingDetailViewController_17 *VC = [[ReadingDetailViewController_17 alloc] init];
    VC.reading = self.listItem.objs[indexPath.row];
    VC.stageString = self.stageString;
    WEAK_SELF
    VC.readingDetailFinishCompleteBlock = ^{
        STRONG_SELF
        self.listItem.scheme.process.userFinishNum = [NSString stringWithFormat:@"%ld",self.listItem.scheme.process.userFinishNum.integerValue + 1];
    };
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - request
- (void)requestForReadingList {
    ReadingListRequest_17 *request = [[ReadingListRequest_17 alloc] init];
    request.stageID = self.stageString;
    request.toolID = self.toolString;
    request.role = [LSTSharedInstance sharedInstance].trainManager.currentProject.role;
    WEAK_SELF
    [request startRequestWithRetClass:[ReadingListRequest_17Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        ReadingListRequest_17Item *item = retItem;
        self.listItem = item;
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }];
    self.listRequest = request;
}
@end
