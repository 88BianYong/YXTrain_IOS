//
//  XYLearningViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXLearningViewController_17.h"
#import "ExamineDetailRequest_17.h"
#import "MJRefresh.h"
#import "ProjectChooseLayerView.h"
#import "TrainSelectLayerRequest.h"
typedef NS_ENUM(NSUInteger, TrainProjectRequestStatus) {
    TrainProjectRequestStatus_Beijing,//请求北京校验
    TrainProjectRequestStatus_LayerList,//请求分层
};
@interface YXLearningViewController_17 ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) UIView *qrCodeView;
@property (nonatomic, strong) MJRefreshHeaderView *header;
@property (nonatomic, strong) ProjectChooseLayerView *chooseLayerView;


@property (nonatomic, strong) ExamineDetailRequest_17 *examineDetailRequest;
@property (nonatomic, strong) ExamineDetailRequest_17Item *examineDetailItem;
@property (nonatomic, strong) TrainLayerListRequest *layerListRequest;
@property (nonatomic, strong) TrainSelectLayerRequest *selectLayerRequest;

@property (nonatomic, strong) NSMutableDictionary *layerMutableDictionary;


@end

@implementation YXLearningViewController_17
- (void)dealloc{
    [self.header free];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
    [self startLoading];
    self.layerMutableDictionary = [[NSMutableDictionary alloc] initWithCapacity:3];
    if ([LSTSharedInstance sharedInstance].trainManager.currentProject.isOpenLayer.boolValue) {
        [self requestForLayerList];
    }else {

        [self requestForExamineDetail];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - set
- (ProjectChooseLayerView *)chooseLayerView {
    if (_chooseLayerView == nil) {
        _chooseLayerView = [[ProjectChooseLayerView alloc] init];
        WEAK_SELF
        [_chooseLayerView setProjectChooseLayerCompleteBlock:^(NSString *layerId){
            STRONG_SELF;
            //[self requestForSelectLayer:layerId];
        }];
    }
    return _chooseLayerView;
}
- (void)setExamineDetailItem:(ExamineDetailRequest_17Item *)examineDetailItem {
    _examineDetailItem = examineDetailItem;
}

#pragma mark - setupUI
- (void)setupUI {
    self.navigationItem.title = [LSTSharedInstance sharedInstance].trainManager.currentProject.name;
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.errorView = [[YXErrorView alloc] init];
    WEAK_SELF
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self requestForExamineDetail];
    };
    self.dataErrorView = [[DataErrorView alloc] init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self requestForExamineDetail];
    };
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self requestForExamineDetail];
    };
    [self setupQRCodeLeftView];
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)showTrainLayerView:(TrainLayerListRequestItem *)item {
    [self.view addSubview:self.chooseLayerView];
    [self.chooseLayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.chooseLayerView.dataMutableArray = item.body;
}

- (void)setupQRCodeLeftView{
    self.qrCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"扫二维码"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"扫二维码"] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(-10, 0, 44.0f, 44.0f);
    WEAK_SELF
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        UIViewController *VC = [[NSClassFromString(@"VideoCourseQRViewController") alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }];
    [self.qrCodeView addSubview:button];
    [self setupLeftWithCustomView:self.qrCodeView];
}
#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.0001f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
#pragma mark - request
- (void)requestForExamineDetail {
    ExamineDetailRequest_17 *request = [[ExamineDetailRequest_17 alloc] init];
    request.projectID = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.role = [LSTSharedInstance sharedInstance].trainManager.currentProject.role;
    WEAK_SELF
    [request startRequestWithRetClass:[ExamineDetailRequest_17Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        [self.header endRefreshing];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        self.examineDetailItem = retItem;
        
    }];
    self.examineDetailRequest = request;
}
- (void)requestForLayerList {
    if (self.layerMutableDictionary[[LSTSharedInstance sharedInstance].trainManager.currentProject.pid]) {
        [self showTrainLayerView:self.layerMutableDictionary[[LSTSharedInstance sharedInstance].trainManager.currentProject.pid]];
    }else {
       // self.requestStatus = TrainProjectRequestStatus_LayerList;
        TrainLayerListRequest *request = [[TrainLayerListRequest alloc] init];
        request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
        WEAK_SELF
        [self startLoading];
        [request startRequestWithRetClass:[TrainLayerListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self stopLoading];
            TrainLayerListRequestItem *item = retItem;
            UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
            data.requestDataExist = YES;
            data.localDataExist = NO;
            data.error = error;
            if ([self handleRequestData:data]) {
                return;
            }
            if (item) {
                self.layerMutableDictionary[[LSTSharedInstance sharedInstance].trainManager.currentProject.pid] = item;
                [self showTrainLayerView:item];
            }
        }];
        self.layerListRequest = request;
    }
}
- (void)requestForSelectLayer:(NSString *)layerId {
    [self startLoading];
    TrainSelectLayerRequest *request = [[TrainSelectLayerRequest alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.layerId = layerId;
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = YES;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        [LSTSharedInstance sharedInstance].trainManager.currentProject.isOpenLayer = @"0";
        [LSTSharedInstance sharedInstance].trainManager.currentProject.layerId = layerId;
        [[LSTSharedInstance sharedInstance].trainManager saveToCache];
        [self.chooseLayerView removeFromSuperview];
        [self requestForExamineDetail];
    }];
    self.selectLayerRequest = request;
}

@end
