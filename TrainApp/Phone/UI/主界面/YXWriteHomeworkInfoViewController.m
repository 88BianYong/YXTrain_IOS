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
#import "YXCategoryListRequest.h"
#import "YXSelectHomeworkInfoView.h"
#import "YXWriteHomeworkInfoViewController+Format.h"
#import "YXGetQiNiuTokenRequest.h"
#import "YXQiNiuVideoUpload.h"
#import "YXSaveVideoProgressView.h"
#import "YXVideoRecordManager.h"
#import "YXSaveHomeWorkRequest.h"
@interface YXWriteHomeworkInfoViewController()
<
  UITableViewDelegate,
  UITableViewDataSource,
  YXQiNiuUploadDelegate
>
{
    UITableView *_tableView;
    YXErrorView *_errorView;
    UIView *_bgView;
    YXSelectHomeworkInfoView *_infoView;
    YXSaveVideoProgressView *_progressView;
    
    NSArray *_titleArray;
    YXCategoryListRequestItem *_listItem;

    
    YXCategoryListRequest *_listRequest;
    YXChapterListRequest *_chapterRequest;
    YXQiNiuVideoUpload *_uploadRequest;
    YXGetQiNiuTokenRequest *_getQiNiuTokenRequest;
    YXSaveHomeWorkRequest *_saveRequest;
    YXWriteHomeworkRequest *_homeworkRequest;
    YXUpdVideoHomeworkRequest *_uploadInfoRequest;
    
}
@end
@implementation YXWriteHomeworkInfoViewController

- (void)dealloc{
    DDLogError(@"release===>%@",NSStringFromClass([self class]));
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _titleArray = @[@"学段",@"学科",@"版本",@"年级"];
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

    _errorView = [[YXErrorView alloc]initWithFrame:self.view.bounds];
    _errorView.retryBlock = ^{
        STRONG_SELF
        [self requestForCategoryId];
    };
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    _bgView = [[UIView alloc] initWithFrame:window.bounds];
    _bgView.hidden = YES;
    [window addSubview:_bgView];
    _progressView = [[YXSaveVideoProgressView alloc] initWithFrame:CGRectMake(0, 0, 143.0f , 143.0f)];
    _progressView.center = _bgView.center;
    _progressView.titleString = @"视频上传中...";
    _progressView.closeHandler = ^(){
        STRONG_SELF
        self ->_bgView.hidden = YES;
        [self ->_uploadRequest  discardUpload];
    };
    [_bgView addSubview:_progressView];
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
        YXWriteHomeworkInfoCell  *oldCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:status inSection:0]];
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

#pragma mark - request
- (void)requestForCategoryId{
    if (_listRequest) {
        [_listRequest stopRequest];
    }
    YXCategoryListRequest *request  = [[YXCategoryListRequest alloc] init];
    request.flag = @"0";
    request.code = @"version_grade";
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[YXCategoryListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            self ->_errorView.frame = self.view.bounds;
            [self.view addSubview:self ->_errorView];
        }else{
            self ->_listItem = retItem;
            [self schoolSectionWithData];
            [self -> _tableView reloadData];
            if (self.videoModel.homeworkid.integerValue != 0) {
                [self requestForHomeworkInfo];
            }
        }
    }];
    _listRequest = request;
}

- (void)requestForChapterList{
    if (_chapterRequest) {
        [_chapterRequest stopRequest];
    }
    YXChapterListRequest *request = [[YXChapterListRequest alloc] init];
    request.stage_id = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_SchoolSection)][0];
    request.subject_id = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Subject)][0];
    request.version_id = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Version)][0];
    request.grade_id = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Grade)][0];
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[YXChapterListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            [self showToast:@"作业章节获取失败"];
        }else{
            self.chapterList = retItem;
            [self saveChapterList];
            [self -> _tableView reloadData];
        }
    }];
    _chapterRequest = request;
}

- (void)requestSaveHomework:(NSString *)hashStr{
    if(_saveRequest){
        [_saveRequest stopRequest];
    }
    NSError *error = nil;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[PATH_OF_VIDEO stringByAppendingPathComponent:self.videoModel.fileName] error:&error];
    NSString * fileSizeString = [fileAttributes objectForKey:@"NSFileSize"];
    unsigned long long fileSize = [fileSizeString longLongValue];
    YXSaveHomeWorkRequest *request = [[YXSaveHomeWorkRequest alloc] init];
    request.rid = [FileHash md5HashOfFileAtPath:[PATH_OF_VIDEO stringByAppendingPathComponent:self.videoModel.fileName]];
    request.ext = @"mp4";
    request.action = @"qiniuc";
    request.filename = self.videoModel.fileName;
    request.filesize = [NSString stringWithFormat:@"%llu",fileSize];
    YXSaveHomeWorkRequestModel *model = [[YXSaveHomeWorkRequestModel alloc] init];
    model.categoryIds = [self getCategoryIds];
    model.title = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Title)][1];
    model.chapter = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Menu)][0];
    model.des = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Topic)][1];
    model.projectid = self.videoModel.pid;
    model.requireid = self.videoModel.requireId;
    model.typeId = @"1004";
    model.hwid = self.videoModel.homeworkid;
    model.shareType = @"0";
    model.status = @"-1";
    request.reserve = model.toJSONString;
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[YXSaveHomeWorkRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (!error) {
            YXSaveHomeWorkRequestItem *item = retItem;
            self.videoModel.homeworkid = item.resid;
            self.videoModel.uploadPercent = 0.0;
            self.videoModel.isUploadSuccess = NO;
            NSString *filePath = [PATH_OF_VIDEO stringByAppendingPathComponent:self.videoModel.fileName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                self.videoModel.lessonStatus = YXVideoLessonStatus_UploadComplete;
            }
            else{
               self.videoModel.lessonStatus = YXVideoLessonStatus_Finish;
            }
            YXHomeworkInfoRequestItem_Body_Detail *detail = [[YXHomeworkInfoRequestItem_Body_Detail alloc] init];
            detail.title = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Title)][1];
            detail.segmentName = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_SchoolSection)][1];
            detail.gradeName = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Grade)][1];
            detail.studyName = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Subject)][1];
            detail.chapterName = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Menu)][1];
            detail.versionName = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Version)][1];
            detail.keyword =  self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Topic)][1];
            self.videoModel.detail = detail;
            [YXVideoRecordManager saveVideoArrayWithModel:self.videoModel];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showToast:@"视频作业上传失败"];
        }
    }];
    _saveRequest = request;
}

- (void)requestForHomeworkInfo{
    if (_homeworkRequest) {
        [_homeworkRequest stopRequest];
    }
    WEAK_SELF
    YXWriteHomeworkRequest *request = [[YXWriteHomeworkRequest alloc] init];
    request.projectid = self.videoModel.pid;
    request.hwid = self.videoModel.homeworkid;
    [request startRequestWithRetClass:[YXWriteHomeworkRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            [self showToast:@"目录信息获取失败"];
        }else{
            YXWriteHomeworkRequestItem *item = retItem;
            self.homeworkItem = item;
            [self saveWorkhomeInfo:item.body];
            [self -> _tableView reloadData];
            if (!isEmpty(self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Grade)][1])) {
              [self requestForChapterList];
            };
        }
    }];
    _homeworkRequest = request;
}

- (void)requestForUpdVideoHomework{
    if (_uploadInfoRequest) {
        [_uploadInfoRequest stopRequest];
    }
    [self startLoading];
    WEAK_SELF
    YXUpdVideoHomeworkRequest *request = [[YXUpdVideoHomeworkRequest alloc] init];
    request.title = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Title)][1];
    request.pid = self.videoModel.pid;
    request.requireid = self.videoModel.requireId;
    request.hwid = self.videoModel.homeworkid;
    request.content = [self formatUploadVideoHomeworkContent];
    [request startRequestWithRetClass:[YXUpdVideoHomeworkRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (!error) {
            YXUpdVideoHomeworkRequestItem *item = retItem;
            self.videoModel.homeworkid = item.data.hwid;
            self.videoModel.uploadPercent = 0.0;
            self.videoModel.isUploadSuccess = NO;
            self.videoModel.lessonStatus = YXVideoLessonStatus_Finish;
            YXHomeworkInfoRequestItem_Body_Detail *detail = [[YXHomeworkInfoRequestItem_Body_Detail alloc] init];
            detail.title = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Title)][1];
            detail.segmentName = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_SchoolSection)][1];
            detail.gradeName = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Grade)][1];
            detail.studyName = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Subject)][1];
            detail.chapterName = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Menu)][1];
            detail.versionName = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Version)][1];
            detail.keyword =  self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Topic)][1];
            self.videoModel.detail = detail;
            [YXVideoRecordManager saveVideoArrayWithModel:self.videoModel];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showToast:@"修改作业信息失败"];
        }
    }];
    _uploadInfoRequest = request;
}

#pragma mark - upload video
- (void)uploadVideoForQiNiu{
    if (_getQiNiuTokenRequest) {
        [_getQiNiuTokenRequest stopRequest];
    }
    YXGetQiNiuTokenRequest *request = [[YXGetQiNiuTokenRequest alloc] init];
    WEAK_SELF
    [request  startRequestWithRetClass:[YXGetQiNiuTokenRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            [self showToast:@"网络异常,请稍后重试"];
        }else{
            YXGetQiNiuTokenRequestItem *item = retItem;
            DDLogDebug(@"%@",item.uploadToken);
            self ->_uploadRequest = [[YXQiNiuVideoUpload alloc] initWithFileName:self.videoModel.fileName qiNiuToken:item.uploadToken];
            self ->_uploadRequest.delegate = self;
            self ->_bgView.hidden = NO;
            [self ->_uploadRequest  startUpload];
        }
    }];
    _getQiNiuTokenRequest = request;
    
}
#pragma mark -qiniu delegate
- (void)uploadProgress:(float)progress{
    dispatch_async(dispatch_get_main_queue(), ^{
        _progressView.progress = progress;
    });
    
    
}
- (void)uploadCompleteWithHash:(NSString *)hashStr {
    dispatch_async(dispatch_get_main_queue(), ^{
        _bgView.hidden = YES;
        self.videoModel.isUploadSuccess = YES;
        self.videoModel.uploadPercent = 1;
        [YXVideoRecordManager saveVideoArrayWithModel:self.videoModel];
        [self requestSaveHomework:hashStr];
    });
}
#pragma mark - format data
- (void)schoolSectionWithData{
    [_listMutableDictionary setObject:_listItem.data forKey:@(YXWriteHomeworkListStatus_SchoolSection)];
}


#pragma mark - button Action
- (void)buttonActionForSave:(UIButton *)sender{
    if (sender.selected) {
        [self yx_hideKeyboard];
        if (self.isChangeHomeworkInfo) {
            [self requestForUpdVideoHomework];
        }else{
          [self uploadVideoForQiNiu];
        }
    }else{
        if (![self saveInfoHomeWorkShowToast:YES]) {
            YXAlertAction *knowAction = [[YXAlertAction alloc] init];
            knowAction.title = @"确定";
            knowAction.style = YXAlertActionStyleAlone;
            YXAlertCustomView *alertView = [YXAlertCustomView alertViewWithTitle:@"字段不能为空哦,请补充完整" image:@"失败icon" actions:@[knowAction]];
            [alertView showAlertView:nil];
        }
    }
}

@end
