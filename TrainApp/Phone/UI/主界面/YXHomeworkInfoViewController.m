//
//  YXHomeworkInfoViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/3.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHomeworkInfoViewController.h"
#import "YXHomeworkInfoHeaderView.h"
#import "YXVideoRecordViewController.h"
#import "YXVideoRecordManager.h"
#import "YXHomeworkInfoNoRecordCell.h"
#import "YXHomeworkAlreadyRecordCell.h"
#import "YXUploadDepictionViewController.h"
#import "YXWriteHomeworkInfoViewController.h"
#import "YXHomeworkUploadCompleteView.h"
#import "YXHomeworkInfoFinishHeaderView.h"
#import "YXHomeworkPlayVideoCell.h"
static  NSString *const trackPageName = @"作业详情页面";

@interface YXHomeworkInfoViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    UITableView *_tableView;
    YXHomeworkInfoRequest *_infoRequest;
}
@property (nonatomic ,strong)YXHomeworkInfoHeaderView *headerView;
@property (nonatomic ,strong)YXHomeworkUploadCompleteView *footerView;
@property (nonatomic, strong) YXFileVideoItem *videoItem;
@end

@implementation YXHomeworkInfoViewController
- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
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
    if (self.itemBody.detail) {
        self.itemBody.lessonStatus = YXVideoLessonStatus_Finish;
    }else{
        self.itemBody.lessonStatus = YXVideoLessonStatus_NoRecord;
    }
    [self findVideoHomeworkInformation:self.itemBody];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:YES];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:NO];
    self.navigationController.navigationBar.shadowImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]];
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
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kYXTrainFirstGoInHomeworkInfo] && [YXTrainManager sharedInstance].isBeijingProject) {
        static NSString * staticString = @"YXHomeworkPromptView";
        UIView *promptView = [[NSClassFromString(staticString) alloc] init];
        [self.view addSubview:promptView];
        [promptView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kYXTrainFirstGoInHomeworkInfo];
    }
    
    WEAK_SELF
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self requestForHomeworkInfo];
    };
    self.dataErrorView = [[DataErrorView alloc]init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self requestForHomeworkInfo];
    };
}

- (void)layoutInterface{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.itemBody.lessonStatus == YXVideoLessonStatus_NoRecord ) {
        return MAX(kScreenHeight - 64.0f - 310.0f, 150.0f);
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
        return 0.01f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
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
    request.pid = self.itemBody.pid;
    request.requireid = self.itemBody.requireId;
    request.hwid = self.itemBody.homeworkid;
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[YXHomeworkInfoRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = retItem != nil;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        YXHomeworkInfoRequestItem *item = retItem;
        item.body.uid = [YXUserManager sharedManager].userModel.uid;
        item.body.pid = self.itemBody.pid;
        if (item.body.detail) {
            item.body.lessonStatus = YXVideoLessonStatus_Finish;
        }else{
            item.body.lessonStatus = YXVideoLessonStatus_NoRecord;
        }
        self.itemBody = item.body;
        [self findVideoHomeworkInformation:self.itemBody];
        self ->_tableView.hidden = NO;
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
    if ([YXTrainManager sharedInstance].isBeijingProject) {
        self.headerView.frame = CGRectMake(0, 0, kScreenWidth, [self scrollViewContentSizeWithDescription:self.itemBody.depiction ?: @" "].height + 247 + 22);
    }
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
- (CGSize)scrollViewContentSizeWithDescription:(NSString*)desc{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    CGRect rect = [desc boundingRectWithSize:CGSizeMake(kScreenWidth - 50.0f, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"334466"],NSParagraphStyleAttributeName:paragraphStyle} context:NULL];
    return rect.size;
}
#pragma mark - present ViewController
- (void)gotoNextViewController:(YXRecordVideoInterfaceStatus)type{
    switch (type) {
        case YXRecordVideoInterfaceStatus_Record:
        {
            if (![YXVideoRecordManager isSupportRecordVideoShowView:self.view]) {//判断权限
                return;
            }
            if (![YXVideoRecordManager isEnoughDeviceSpace]){//判断空间大小
                [self showToast:@"系统空间不足200M,至少需要200M存储空间"];
                return;
            }
            if(self.itemBody.type.integerValue == 3){//判断是否是限制时间的视频
                if (self.itemBody.lessonStatus == YXVideoLessonStatus_UploadComplete || self.itemBody.lessonStatus == YXVideoLessonStatus_AlreadyRecord) {
                    [self againRecordVideo];
                }
                else{
                    LSTAlertView *alertView = [[LSTAlertView alloc]init];
                    alertView.title = @"视频录制时长需要大于10分钟~";
                    alertView.imageName = @"提醒icon";
                    WEAK_SELF
                    [alertView addButtonWithTitle:@"我知道了" style:LSTAlertActionStyle_Alone action:^{
                        STRONG_SELF
                        [self gotoVideoRecordVC:NO];
                    }];
                    [alertView show];
                }
            }
            else{
                if (self.itemBody.lessonStatus == YXVideoLessonStatus_UploadComplete || self.itemBody.lessonStatus == YXVideoLessonStatus_AlreadyRecord) {
                    [self againRecordVideo];
                }else{
                    [self gotoVideoRecordVC:NO];
                }
            }
            break;
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
            videoItem.isLocal = YES;
            videoItem.name = self.itemBody.title;
            videoItem.url = [NSURL fileURLWithPath:[PATH_OF_VIDEO stringByAppendingPathComponent:self.itemBody.fileName]].absoluteString;
            if (self.itemBody.lessonStatus == YXVideoLessonStatus_AlreadyRecord) {
                videoItem.isDeleteVideo = YES;
                videoItem.sourceType = YXSourceTypeTaskNoUploadedVideos;
            }
            else{
                videoItem.isDeleteVideo = NO;
            }
            videoItem.baseViewController = self;
            [videoItem browseFile];
            self.videoItem = videoItem;
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
    LSTAlertView *alertView = [[LSTAlertView alloc]init];
    alertView.title = @"重新录制将覆盖当前视频\n确定重新录制?";
    alertView.imageName = @"失败icon";
    WEAK_SELF
    [alertView addButtonWithTitle:@"录制" style:LSTAlertActionStyle_Cancel action:^{
        STRONG_SELF
        [self gotoVideoRecordVC:YES];
    }];
    [alertView addButtonWithTitle:@"取消" style:LSTAlertActionStyle_Default action:^{
        STRONG_SELF
    }];
    [alertView show];
}
- (void)gotoVideoRecordVC:(BOOL)isReRecording{
    YXVideoRecordViewController *VC = [[YXVideoRecordViewController alloc] init];
    VC.videoModel = self.itemBody;
    if (isReRecording) {
        VC.isReRecording = YES;
    }
    if (!isReRecording) {
        VC.isReRecording = NO;
    }
    [[self visibleViewController] presentViewController:VC animated:YES completion:^{
        
    }];
}
@end
