//
//  MasterManageOffActiveDetailViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/28.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterManageOffActiveDetailViewController_17.h"
#import "MasterOffActiveContainerView_17.h"
#import "MasterOffActiveDescriptionViewController_17.h"
#import "MasterOffActiveRecordViewController_17.h"
#import "MasterOffActiveParticipantViewController_17.h"
#import "MasterManagerOffActiveDetailRquest_17.h"
@interface MasterManageOffActiveDetailViewController_17 ()
@property (nonatomic, strong) MasterOffActiveContainerView_17 *containerView;
@property (nonatomic, strong) MasterManagerOffActiveDetailRquest_17 *detailRequest;
@property (nonatomic, strong) MasterManagerOffActiveDetailItem_Body *detailItem;
@end

@implementation MasterManageOffActiveDetailViewController_17

#pragma mark - set
- (void)setDetailItem:(MasterManagerOffActiveDetailItem_Body *)detailItem {
    _detailItem = detailItem;
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:3];
    MasterOffActiveDescriptionViewController_17 *descriptionVC = [[MasterOffActiveDescriptionViewController_17 alloc] init];
    descriptionVC.title = @"活动描述";
    [mutableArray addObject:descriptionVC];
    descriptionVC.descString = _detailItem.desc?:@"";
    [self addChildViewController:descriptionVC];
    if (_detailItem.wonderful.length > 0 || _detailItem.affixs.count > 0) {
       MasterOffActiveRecordViewController_17 *recordVC = [[MasterOffActiveRecordViewController_17 alloc] init];
        recordVC.title = @"精彩记录";
        [mutableArray addObject:recordVC];
        [recordVC reloadMasterOffActiveRecord:_detailItem.wonderful?:@"" withAffix:_detailItem.affixs];
        [self addChildViewController:recordVC];
    }
    MasterOffActiveParticipantViewController_17 *participantVC = [[MasterOffActiveParticipantViewController_17 alloc] init];
    participantVC.title = @"参与人";
    [mutableArray addObject:participantVC];
    participantVC.aId = self.activeId;
    [self addChildViewController:participantVC];
    self.containerView.containerViewControllers = mutableArray;
    self.containerView.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.titleString;
    [self setupUI];
    [self setupLayout];
    [self startLoading];
    [self requestForActiveDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:@"线下活动详情" withStatus:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:@"线下活动详情" withStatus:NO];
}
#pragma mark - setupUI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.containerView = [[MasterOffActiveContainerView_17 alloc] initWithFrame:self.view.bounds];
    self.containerView.hidden = YES;
    [self.view addSubview:self.containerView];
}
- (void)setupLayout {
//    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.top.equalTo(self.view.mas_top).offset(5.0f);
//        make.bottom.equalTo(self.view.mas_bottom);
//    }];
}
#pragma mark - request
- (void)requestForActiveDetail {
    MasterManagerOffActiveDetailRquest_17 *request = [[MasterManagerOffActiveDetailRquest_17  alloc] init];
    request.aId = self.activeId;
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    WEAK_SELF
    [request startRequestWithRetClass:[MasterManagerOffActiveDetailItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        UnhandledRequestData *data = [[UnhandledRequestData alloc] init];
        data.requestDataExist = YES;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        MasterManagerOffActiveDetailItem *item = retItem;
        self.detailItem = item.body;
    }];
    self.detailRequest = request;
}
@end
