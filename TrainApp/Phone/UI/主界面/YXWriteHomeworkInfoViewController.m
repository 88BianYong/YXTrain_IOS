//
//  YXWriteHomeworkInfoViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWriteHomeworkInfoViewController.h"
#import "YXWriteHomeworkInfoTitleView.h"
#import "YXWriteHomeworkInfoMenuView.h"
#import "YXSelectHomeworkInfoView.h"
#import "YXSaveVideoProgressView.h"
#import "YXVideoRecordManager.h"
#import "YXGetQiNiuTokenRequest.h"
#import "YXQiNiuVideoUpload.h"
#import "YXWriteHomeworkInfoViewController+Request.h"
#import "YXWriteHomeworkInfoViewController+Format.h"
@interface YXWriteHomeworkInfoViewController()
<
  UITableViewDelegate,
  UITableViewDataSource,
  YXQiNiuUploadDelegate
>
{
    YXSelectHomeworkInfoView *_infoView;
    YXSaveVideoProgressView *_progressView;
    
    NSArray *_titleArray;
    
    YXQiNiuVideoUpload *_uploadRequest;
    YXGetQiNiuTokenRequest *_getQiNiuTokenRequest;
  

}
@end
@implementation YXWriteHomeworkInfoViewController

- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _titleArray = @[@"学段",@"学科",@"版本",@"书册"];
    self.title = @"填写作业信息";
    _listMutableDictionary = [[NSMutableDictionary alloc] initWithCapacity:4];
    _selectedMutableDictionary = [[NSMutableDictionary alloc] initWithCapacity:7];
    
    [self setupUI];
    [self layoutInterface];
    [self requestForCategoryId];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 60;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}


- (void)setNetObserver {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    WEAK_SELF
    reach.unreachableBlock = ^(Reachability*reach)
    {
        STRONG_SELF
        [self ->_uploadRequest cancelUpload];
        dispatch_async(dispatch_get_main_queue(), ^{
            self ->_progressView.hidden = YES;
            [UIApplication sharedApplication].idleTimerDisabled = NO;
        });
    };
    [reach startNotifier];
}

#pragma mark property
- (YXWriteHomeworkInfoCell *)schoolSectionCell{
    return [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:YXWriteHomeworkListStatus_SchoolSection inSection:0]];
}

- (YXWriteHomeworkInfoCell *)subjectCell{
    return [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:YXWriteHomeworkListStatus_Subject inSection:0]];
}

- (YXWriteHomeworkInfoCell *)versionCell{
    return [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:YXWriteHomeworkListStatus_Version inSection:0]];
}

- (YXWriteHomeworkInfoCell *)gradeCell{
    return [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:YXWriteHomeworkListStatus_Grade inSection:0]];
}

- (YXWriteHomeworkInfoMenuView *)menuView{
    return (YXWriteHomeworkInfoMenuView *)[_tableView footerViewForSection:0];
}

#pragma mark - setupUI
- (void)setupUI{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[YXWriteHomeworkInfoCell class] forCellReuseIdentifier:@"YXWriteHomeworkInfoCell"];
    [_tableView registerClass:[YXWriteHomeworkInfoTitleView class] forHeaderFooterViewReuseIdentifier:@"YXWriteHomeworkInfoTitleView"];
    [_tableView registerClass:[YXWriteHomeworkInfoMenuView class] forHeaderFooterViewReuseIdentifier:@"YXWriteHomeworkInfoMenuView"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10.0f)];
    _tableView.tableHeaderView = headerView;
    
    _bottomView = [[YXWriteHomeworkInfoBottomView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 230.0f)];
    WEAK_SELF
    _bottomView.topicStringHandler = ^(NSString *topic){
        STRONG_SELF
        [self showWorkhomeInfo:YXWriteHomeworkListStatus_Topic withChangeObj:topic];
    };
    [_bottomView.saveButton addTarget:self action:@selector(buttonActionForSave:) forControlEvents:UIControlEventTouchUpInside];
    _tableView.tableFooterView = _bottomView;
    [self.view addSubview:_tableView];

    self.errorView = [[YXErrorView alloc]initWithFrame:self.view.bounds];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self requestForCategoryId];
    };
    _progressView = [[YXSaveVideoProgressView alloc] initWithFrame:CGRectMake(0, 0, 150.0f , 150.0f)];
    _progressView.titleString = @"视频上传中...";
    _progressView.hidden = YES;
    _progressView.closeHandler = ^(){
        STRONG_SELF
        self ->_progressView.hidden = YES;
        [self ->_uploadRequest  cancelUpload];
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    };
    [_progressView isShowView:nil];
}

- (void)layoutInterface{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 100.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YXWriteHomeworkInfoTitleView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXWriteHomeworkInfoTitleView"];
    WEAK_SELF
    view.titleStringHandler = ^(NSString *title){
        STRONG_SELF
        [self showWorkhomeInfo:YXWriteHomeworkListStatus_Title withChangeObj:title];
    };
    view.titleString = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Title)][1];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YXWriteHomeworkInfoMenuView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXWriteHomeworkInfoMenuView"];
    view.item = _chapterList;
    WEAK_SELF
    view.chapterIdHandler = ^(NSString *chapterId, NSString *chapterName){
        STRONG_SELF
        [self showWorkhomeInfo:YXWriteHomeworkListStatus_Menu withChangeObj:@[chapterId,chapterName]];
    };
    view.errorHandler = ^(){
        STRONG_SELF
        [self requestForChapterList];
    };
    view.indexPath = _chapterIndexPath;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDLogDebug(@"点击了");
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXWriteHomeworkInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXWriteHomeworkInfoCell" forIndexPath:indexPath];
    WEAK_SELF
    cell.openCloseHandler = ^(UIView *sender,YXWriteHomeworkListStatus status){
        STRONG_SELF
        CGRect rect = [sender convertRect:sender.bounds toView:self.view];
        [self showWorkhomeInfoChooseMenu:rect withStatus:status];
    };
    cell.titleString = _titleArray[indexPath.row];
    cell.status = indexPath.row;
    cell.isEnabled = [_listMutableDictionary objectForKey:@(cell.status)] ? YES : NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *array = _selectedMutableDictionary[@(cell.status)];
    if (array) {
        cell.contentString = array[1];
    }
    else{
        cell.contentString = @"";
    }
    return cell;
}

- (void)showWorkhomeInfoChooseMenu:(CGRect)rect withStatus:(YXWriteHomeworkListStatus)status{
    [self yx_hideKeyboard];
    CGFloat originY = rect.origin.y;
    if (rect.origin.y > (_tableView.frame.size.height - 300.0f)) {
        CGPoint point = _tableView.contentOffset;
        point.y += rect.origin.y - (_tableView.frame.size.height - 300.0f) ;
        [_tableView setContentOffset:point animated:YES];
        originY = _tableView.frame.size.height - 300.0f;
    }
    YXSelectHomeworkInfoView *infoView = [[YXSelectHomeworkInfoView alloc]initWithFrame:self.view.window.bounds];
    WEAK_SELF
    infoView.tapCloseView = ^(YXWriteHomeworkListStatus status){
        STRONG_SELF
        YXWriteHomeworkInfoCell  *oldCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:status inSection:0]];
        oldCell.isEnabled = YES;
    };
    infoView.didSeletedItem = ^(NSInteger index ,YXWriteHomeworkListStatus status){
        STRONG_SELF
        [self showWorkhomeInfo:status withChangeObj:@(index)];
    };
    [infoView setViewWithDataArray:_listMutableDictionary[@(status)]
                        withStatus:status
                    withSelectedId:_selectedMutableDictionary[@(status)][0]
                       withOriginY:originY + 100.0f];
    
    [self.view.window addSubview:infoView];
}

#pragma mark - upload video
- (void)uploadVideoForQiNiu{
    if (_getQiNiuTokenRequest) {
        [_getQiNiuTokenRequest stopRequest];
    }
    YXGetQiNiuTokenRequest *request = [[YXGetQiNiuTokenRequest alloc] init];
    _progressView.hidden = NO;
    _progressView.progress = 0.0f;
    WEAK_SELF
    [request  startRequestWithRetClass:[YXGetQiNiuTokenRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            _progressView.hidden = YES;
            [self showToast:@"网络异常,请稍后重试"];
        }else{
            YXGetQiNiuTokenRequestItem *item = retItem;
            DDLogDebug(@"%@",item.uploadToken);
            self ->_uploadRequest = [[YXQiNiuVideoUpload alloc] initWithFileName:self.videoModel.fileName qiNiuToken:item.uploadToken];
            self ->_uploadRequest.delegate = self;
            [UIApplication sharedApplication].idleTimerDisabled = YES;
            [self ->_uploadRequest  startUpload];
        }
    }];
    _getQiNiuTokenRequest = request;
    
}



#pragma mark -qiniu delegate
- (void)uploadProgress:(float)progress{
    dispatch_async(dispatch_get_main_queue(), ^{
        self ->_progressView.progress = progress;
    });    
}
- (void)uploadCompleteWithHash:(NSString *)hashStr {
    dispatch_async(dispatch_get_main_queue(), ^{
        self ->_progressView.hidden = YES;
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        self.videoModel.isUploadSuccess = YES;
        self.videoModel.uploadPercent = 1;
        [YXVideoRecordManager saveVideoArrayWithModel:self.videoModel];
        [self requestSaveHomework:hashStr];
    });
}

#pragma mark - button Action
- (void)buttonActionForSave:(UIButton *)sender{
    if (sender.selected) {//信息填写不完全
        [self saveInfoHomeWorkShowToast:YES];
        return;
    }
    [self yx_hideKeyboard];
    if (self.isChangeHomeworkInfo) {//更改作业信息
        [self requestForUpdVideoHomework];
        return;
    }
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if (![r isReachable]) {
        [self showToast:@"网络异常,请稍候重试"];
        return;
    }
    if ([r isReachableViaWWAN] && ![r isReachableViaWiFi]) {
        LSTAlertView *alertView = [[LSTAlertView alloc]init];
        alertView.title = @"当前处于非Wi-Fi环境\n仍要继续吗";
        alertView.imageName = @"失败icon";
        WEAK_SELF
        [alertView addButtonWithTitle:@"上传" style:LSTAlertActionStyle_Cancel action:^{
            STRONG_SELF
            [self setNetObserver];
            [self uploadVideoForQiNiu];
        }];
        [alertView addButtonWithTitle:@"取消" style:LSTAlertActionStyle_Default action:^{
            STRONG_SELF
        }];
        [alertView show];
        return;
    }
    [self setNetObserver];
    [self uploadVideoForQiNiu];
}

@end
