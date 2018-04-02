//
//  MasterThemeViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2018/3/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MasterThemeViewController_17.h"
#import "MasterThemeHeaderView_17.h"
#import "MasterThemeCell_17.h"
#import "MasterThemeListRequest_17.h"
#import "MasterSelectThemeRequest_17.h"
#import "UITableView+TemplateLayoutHeaderView.h"
@interface MasterThemeViewController_17 ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) MasterThemeListRequest_17 *listRequest;
@property (nonatomic, strong) MasterThemeListItem_Body *dataItem;
@property (nonatomic, strong) MasterSelectThemeRequest_17 *selectRequest;
@property (nonatomic, copy) NSString *themeId;
@property (nonatomic, strong) UIButton *confirmButton;
@end

@implementation MasterThemeViewController_17

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"研修主题";
    [self setupUI];
    [self setupLayout];
    [self startLoading];
    [self requestForThemeList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - set
- (void)setDataItem:(MasterThemeListItem_Body *)dataItem {
    _dataItem = dataItem;
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    [_dataItem.themes enumerateObjectsUsingBlock:^(MasterThemeListItem_Body_Theme *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.isSelected.boolValue) {
            self.confirmButton.enabled = YES;
            self.themeId = obj.themeId;
            if(![self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]]){
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
    }];

}
#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0.0f;
    self.tableView.estimatedSectionFooterHeight = 0.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.sectionFooterHeight = 0.0001f;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[MasterThemeHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"MasterThemeHeaderView_17"];
    [self.tableView registerClass:[MasterThemeCell_17 class] forCellReuseIdentifier:@"MasterThemeCell_17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    WEAK_SELF
    self.errorView = [[YXErrorView alloc] init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForThemeList];
    };
    self.dataErrorView = [[DataErrorView alloc] init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForThemeList];
    };
    if ([LSTSharedInstance sharedInstance].trainManager.currentProject.isOpenTheme.boolValue || [LSTSharedInstance sharedInstance].trainManager.currentProject.status.integerValue == 2) {
        [self setupNavgationRightView];
    }
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)setupNavgationRightView {
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"0070c9"] forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"a1a7ae"] forState:UIControlStateDisabled];
    self.confirmButton.enabled = NO;
    [self.confirmButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.confirmButton.frame = CGRectMake(0, 0, 40.0f, 30.0f);
    WEAK_SELF
    [[self.confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        [self requestForSelectTheme];
    }];
    [self setupRightWithCustomView:self.confirmButton];
}
- (void)naviLeftAction {
    if ([LSTSharedInstance sharedInstance].trainManager.currentProject.isOpenTheme.boolValue) {
       [self showAlertView];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)showAlertView {
    WEAK_SELF
    LSTAlertView *alertView = [[LSTAlertView alloc]init];
    alertView.title = @"确定退出[手机研修]吗?";
    alertView.imageName = @"失败icon";
    [alertView addButtonWithTitle:@"取消" style:LSTAlertActionStyle_Cancel action:^{
        STRONG_SELF
    }];
    [alertView addButtonWithTitle:@"确定" style:LSTAlertActionStyle_Default action:^{
        STRONG_SELF
        [[LSTSharedInstance  sharedInstance].webSocketManger close];
        [[LSTSharedInstance sharedInstance].userManger logout];
        [YXDataStatisticsManger trackEvent:@"退出登录" label:@"成功登出" parameters:nil];
    }];
    [alertView show];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataItem.themes.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MasterThemeCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterThemeCell_17" forIndexPath:indexPath];
    cell.theme = self.dataItem.themes[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDataScore
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MasterThemeHeaderView_17 *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MasterThemeHeaderView_17"];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"MasterThemeCell_17" configuration:^(MasterThemeCell_17 *cell) {
        cell.theme = self.dataItem.themes[indexPath.row];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [tableView yx_heightForHeaderWithIdentifier:@"MasterThemeHeaderView_17" configuration:^(MasterThemeHeaderView_17 *header) {
        
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([LSTSharedInstance sharedInstance].trainManager.currentProject.isOpenTheme.boolValue ||[LSTSharedInstance sharedInstance].trainManager.currentProject.status.integerValue == 2) {
        [self.dataItem.themes enumerateObjectsUsingBlock:^(__kindof MasterThemeListItem_Body_Theme * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isSelected = @"0";
        }];
        MasterThemeListItem_Body_Theme *theme = self.dataItem.themes[indexPath.row];
        theme.isSelected = @"1";
        self.themeId = theme.themeId;
        self.confirmButton.enabled = YES;
        [self.tableView reloadData];
    }
}
#pragma mark - request
- (void)requestForThemeList {
    MasterThemeListRequest_17 *request = [[MasterThemeListRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    WEAK_SELF
    [request startRequestWithRetClass:[MasterThemeListItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        [self.tableView.mj_header endRefreshing];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        MasterThemeListItem *item = retItem;
        self.dataItem = item.body;
    }];
    self.listRequest = request;
}
- (void)requestForSelectTheme {
    MasterSelectThemeRequest_17 *request = [[MasterSelectThemeRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.themeId = self.themeId;
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            [self showToast:error.localizedDescription];
        }else {
            [LSTSharedInstance sharedInstance].trainManager.currentProject.isOpenTheme = @"0";
            [LSTSharedInstance sharedInstance].trainManager.currentProject.themeId = self.themeId;
            [[LSTSharedInstance sharedInstance].trainManager saveToCache];
            BLOCK_EXEC(self.masterThemeReloadBlock);
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
    self.selectRequest = request;
}
@end
