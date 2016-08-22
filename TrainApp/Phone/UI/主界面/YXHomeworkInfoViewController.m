//
//  YXHomeworkInfoViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/3.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHomeworkInfoViewController.h"
#import "YXHomeworkInfoHeaderView.h"
#import "YXHomeworkInfoRequest.h"
#import "YXVideoRecordViewController.h"
#import "YXVideoRecordManager.h"
#import "YXHomeworkInfoNoRecordCell.h"
#import "YXHomeworkAlreadyRecordCell.h"
#import "YXUploadDepictionViewController.h"
#import "YXWriteHomeworkInfoViewController.h"
#import "YXHomeworkUploadCompleteView.h"
#import "YXHomeworkInfoFinishHeaderView.h"
#import "YXHomeworkPlayVideoCell.h"
@interface YXHomeworkInfoViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    UITableView *_tableView;
    YXErrorView *_errorView;
    YXEmptyView *_emptyView;
    
    YXHomeworkInfoRequest *_infoRequest;
}
@property (nonatomic ,strong)YXHomeworkInfoHeaderView *headerView;
@property (nonatomic ,strong)YXHomeworkUploadCompleteView *footerView;

@end

@implementation YXHomeworkInfoViewController
- (void)dealloc{
    DDLogDebug(@"release=====>%@",NSStringFromClass([self class]));
}

#pragma mark - propetry
- (YXHomeworkInfoHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[YXHomeworkInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 310.0f)];
    }
    return _headerView;
}

- (YXHomeworkUploadCompleteView *)footerView{
    if (!_footerView) {
        WEAK_SELF
        _footerView = [[YXHomeworkUploadCompleteView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300.0f)];
        _footerView.buttonActionHandler = ^(YXRecordVideoInterfaceStatus type){
            STRONG_SELF
            [self gotoNextViewController:type];
        };
    }
    return _footerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self setupRightWithTitle:@"       "];
    [self setupUI];
    [self layoutInterface];
    if (![self.itemBody.type isEqualToString:@"1"]) {
        self.title = self.itemBody.title;
        [self requestForHomeworkInfo];
    }
    else{
        _tableView.hidden = NO;
         [self findVideoHomeworkInformation:self.itemBody];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    if (self.itemBody.detail) {
        self.itemBody.lessonStatus = YXVideoLessonStatus_Finish;
    }else{
        self.itemBody.lessonStatus = YXVideoLessonStatus_NoRecord;
    }
    [self findVideoHomeworkInformation:self.itemBody];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString *key = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x42, 0x61, 0x72} length:9] encoding:NSASCIIStringEncoding];
    id object = [UIApplication sharedApplication];
    if ([object respondsToSelector:NSSelectorFromString(key)]) {
        UIView *statusBar = [object valueForKey:key];
        statusBar.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI
- (void)setupUI{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.hidden = YES;
    [_tableView registerClass:[YXHomeworkInfoNoRecordCell class] forCellReuseIdentifier:@"YXHomeworkInfoNoRecordCell"];
    [_tableView registerClass:[YXHomeworkAlreadyRecordCell class] forCellReuseIdentifier:@"YXHomeworkAlreadyRecordCell"];
    [_tableView registerClass:[YXHomeworkInfoFinishHeaderView class] forHeaderFooterViewReuseIdentifier:@"YXHomeworkInfoFinishHeaderView"];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[YXHomeworkPlayVideoCell class] forCellReuseIdentifier:@"YXHomeworkPlayVideoCell"];
    WEAK_SELF
    _errorView = [[YXErrorView alloc]initWithFrame:self.view.bounds];
    _errorView.retryBlock = ^{
        STRONG_SELF
        [self requestForHomeworkInfo];
    };
    _emptyView = [[YXEmptyView alloc]initWithFrame:self.view.bounds];
}

- (void)layoutInterface{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.itemBody.lessonStatus == YXVideoLessonStatus_NoRecord ) {
        return MAX(kScreenHeight - 64.0f - 336.0f, 150.0f);
    }else if (self.itemBody.lessonStatus == YXVideoLessonStatus_AlreadyRecord){
        return 280.0f;
    }else if (self.itemBody.lessonStatus == YXVideoLessonStatus_UploadComplete){
        return kScreenHeightScale(200.0f);
    }
    return 0.0f;
};

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.itemBody.lessonStatus == YXVideoLessonStatus_Finish || self.itemBody.lessonStatus == YXVideoLessonStatus_UploadComplete) {
        return 55.0f;
    }else{
        return 0.1f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.itemBody.lessonStatus == YXVideoLessonStatus_Finish || self.itemBody.lessonStatus == YXVideoLessonStatus_UploadComplete) {
        YXHomeworkInfoFinishHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXHomeworkInfoFinishHeaderView"];
        view.titleString = _itemBody.detail.title;
        return view;
    }else{
        return nil;
    }    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.itemBody.type.integerValue == 2 || self.itemBody.type.integerValue == 3) {
        if (self.itemBody.lessonStatus == YXVideoLessonStatus_Finish){
            return 0;
        }else{
            return 1; 
        }

    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    if (self.itemBody.lessonStatus == YXVideoLessonStatus_NoRecord ) {
        YXHomeworkInfoNoRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeworkInfoNoRecordCell" forIndexPath:indexPath];
        cell.noRecordHandler = ^(YXRecordVideoInterfaceStatus type){
            STRONG_SELF
            [self gotoNextViewController:type];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (self.itemBody.lessonStatus == YXVideoLessonStatus_AlreadyRecord){
        YXHomeworkAlreadyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeworkAlreadyRecordCell" forIndexPath:indexPath];
        cell.filePath = [PATH_OF_VIDEO stringByAppendingPathComponent:self.itemBody.fileName];
        cell.buttonActionHandler = ^(YXRecordVideoInterfaceStatus type){
            STRONG_SELF
            [self gotoNextViewController:type];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (self.itemBody.lessonStatus == YXVideoLessonStatus_UploadComplete){
        YXHomeworkPlayVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeworkPlayVideoCell" forIndexPath:indexPath];
        cell.imageName = [PATH_OF_VIDEO stringByAppendingPathComponent:self.itemBody.fileName];
        cell.buttonActionHandler = ^(YXRecordVideoInterfaceStatus type){
            STRONG_SELF
            [self gotoNextViewController:type];
        };
        return cell;
    }
    return nil;
}

#pragma mark - request
- (void)requestForHomeworkInfo{
    YXHomeworkInfoRequest *request = [[YXHomeworkInfoRequest alloc] init];
    request.pid = [YXTrainManager sharedInstance].currentProject.pid;
    request.requireid = self.itemBody.requireId;
    request.hwid = self.itemBody.homeworkid;
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[YXHomeworkInfoRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            if (error.code == 1) {
                self->_emptyView.frame = self.view.bounds;
                self->_emptyView.imageName = @"数据错误";
                self->_emptyView.title = @"数据错误";
                [self.view addSubview:self->_emptyView];
            }else{
                self ->_errorView.frame = self.view.bounds;
                [self.view addSubview:self ->_errorView];
            }
        }else{
            [self -> _errorView removeFromSuperview];
            YXHomeworkInfoRequestItem *item = retItem;
            if (item) {
                item.body.uid = [YXUserManager sharedManager].userModel.uid;
                item.body.pid = [YXTrainManager sharedInstance].currentProject.pid;
                if (item.body.detail) {
                  item.body.lessonStatus = YXVideoLessonStatus_Finish;
                }else{
                   item.body.lessonStatus = YXVideoLessonStatus_NoRecord; 
                }
                self.itemBody = item.body;
                [self findVideoHomeworkInformation:self.itemBody];
                 self ->_tableView.hidden = NO;
            }
        }
    }];
    
    _infoRequest = request;
}
#pragma mark - format Data
- (void)findVideoHomeworkInformation:(YXHomeworkInfoRequestItem_Body *)item{
    NSArray *saveArray = [YXVideoRecordManager getVideoArrayWithModel];
    [saveArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YXHomeworkInfoRequestItem_Body *model = obj;
        if ([model.fileName yx_isValidString] && [model.uid isEqualToString:item.uid] && [model.pid isEqualToString:item.pid] && [model.requireId isEqualToString:item.requireId]) {
            NSString *filePath = [PATH_OF_VIDEO stringByAppendingPathComponent:model.fileName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                item.fileName = model.fileName;
                item.lessonStatus = model.lessonStatus;
                item.uploadPercent = model.uploadPercent;
                item.isUploadSuccess = model.isUploadSuccess;
            }
        }
    }];
    self.itemBody = item;
    _tableView.tableHeaderView = self.headerView;
    self.headerView.body = self.itemBody;
    self.title = self.itemBody.title;
    if (self.itemBody.detail && (self.itemBody.lessonStatus == YXVideoLessonStatus_UploadComplete || self.itemBody.lessonStatus == YXVideoLessonStatus_Finish )) {
        _tableView.tableFooterView = self.footerView;
        self.footerView.detail = self.itemBody.detail;
    }
    else{
        _tableView.tableFooterView = nil;
    }
    [_tableView reloadData];
}
#pragma mark - present ViewController
- (void)gotoNextViewController:(YXRecordVideoInterfaceStatus)type{
    switch (type) {
        case YXRecordVideoInterfaceStatus_Record:
        {
            if ([YXVideoRecordManager isSupportRecordVideoShowView:self.view]) {//判断权限
                if ([YXVideoRecordManager isEnoughDeviceSpace]) {//判断空间大小
                    if(self.itemBody.type.integerValue == 3){//判断是否是限制时间的视频
                        if (self.itemBody.lessonStatus == YXVideoLessonStatus_UploadComplete || self.itemBody.lessonStatus == YXVideoLessonStatus_AlreadyRecord) {
                            [self againRecordVideo];
                        }
                        else{
                            WEAK_SELF
                            YXAlertAction *knowAction = [[YXAlertAction alloc] init];
                            knowAction.title = @"我知道了";
                            knowAction.style = YXAlertActionStyleAlone;
                            knowAction.block = ^ {
                                STRONG_SELF
                                [self gotoVideoRecordVC];
                            };
                            YXAlertCustomView *alertView = [YXAlertCustomView alertViewWithTitle:@"视频录制时长需要大于10分钟~" image:@"提醒icon" actions:@[knowAction]];
                            [alertView showAlertView:nil];
                        }
                    }
                    else{
                        if (self.itemBody.lessonStatus == YXVideoLessonStatus_UploadComplete || self.itemBody.lessonStatus == YXVideoLessonStatus_AlreadyRecord) {
                            [self againRecordVideo];
                        }else{
                            [self gotoVideoRecordVC];
                        }
                    }
                }else{
                    [self showToast:@"系统空间不足200M,至少需要200M存储空间"];
                }
            }
            
        }
            break;
        case YXRecordVideoInterfaceStatus_Depiction:
        {
            YXUploadDepictionViewController *VC =[[YXUploadDepictionViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case YXRecordVideoInterfaceStatus_Play:
        {
            YXFileVideoItem *videoItem = [[YXFileVideoItem alloc] init];
            videoItem.type = YXFileTypeVideo;
            videoItem.isLocal = NO;
            videoItem.name = self.itemBody.title;
            videoItem.url = [NSURL fileURLWithPath:[PATH_OF_VIDEO stringByAppendingPathComponent:self.itemBody.fileName]].absoluteString;
            [YXFileBrowseManager sharedManager].fileItem = videoItem;
            [YXFileBrowseManager sharedManager].baseViewController = self;
            if (self.itemBody.lessonStatus == YXVideoLessonStatus_AlreadyRecord) {
                [YXFileBrowseManager sharedManager].isDeleteVideo = YES;
            }
            [[YXFileBrowseManager sharedManager] browseFile];
        }
            break;
        case YXRecordVideoInterfaceStatus_Write:
        {
            NSString *filePath = [PATH_OF_VIDEO stringByAppendingPathComponent:self.itemBody.fileName];
            AVURLAsset *mp4Asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:filePath] options:nil];
            CMTime itmeTime = mp4Asset.duration;
            CGFloat durationTime = CMTimeGetSeconds(itmeTime);
            if (self.itemBody.type.integerValue == 3 && durationTime < 600.0f) {
                [self showToast:@"视频时长需大于10分钟"];
                return;
            }
            YXWriteHomeworkInfoViewController *VC = [[YXWriteHomeworkInfoViewController alloc] init];
            VC.videoModel = self.itemBody;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case YXRecordVideoInterfaceStatus_Change:
        {
            YXWriteHomeworkInfoViewController *VC = [[YXWriteHomeworkInfoViewController alloc] init];
            VC.videoModel = self.itemBody;
            VC.isChangeHomeworkInfo = YES;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)againRecordVideo{
    WEAK_SELF
    YXAlertAction *cancelAlertAct = [[YXAlertAction alloc] init];
    cancelAlertAct.title = @"录制";
    cancelAlertAct.style = YXAlertActionStyleCancel;
    cancelAlertAct.block = ^{
        STRONG_SELF
        [self gotoVideoRecordVC];
    };
    YXAlertAction *retryAlertAct = [[YXAlertAction alloc] init];
    retryAlertAct.title = @"取消";
    retryAlertAct.style = YXAlertActionStyleDefault;
    retryAlertAct.block = ^{
        STRONG_SELF
    };
    YXAlertCustomView *alertView = [YXAlertCustomView alertViewWithTitle:@"重新录制将覆盖当前视频\n确定重新录制?" image:@"失败icon" actions:@[cancelAlertAct,retryAlertAct]];
    [alertView showAlertView:nil];
}
- (void)gotoVideoRecordVC{
    YXVideoRecordViewController *VC = [[YXVideoRecordViewController alloc] init];
    VC.videoModel = self.itemBody;
    [[self visibleViewController] presentViewController:VC animated:YES completion:^{
        
    }];
}
@end
