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
#import "YXGetQiNiuTokenRequest.h"
#import "YXQiNiuVideoUpload.h"
#import "YXVideoRecordManager.h"
#import "YXHomeworkInfoNoRecordCell.h"
@interface YXHomeworkInfoViewController ()
<
  UITableViewDelegate,
  UITableViewDataSource
>
{
    UITableView *_tableView;
    
    YXHomeworkInfoRequest *_infoRequest;
    YXQiNiuVideoUpload *_uploadRequest;
    YXGetQiNiuTokenRequest *_getQiNiuTokenRequest;
    
    
    YXHomeworkInfoRequestItem *_infoItem;
    
}
@property (nonatomic ,strong)YXHomeworkInfoHeaderView *headerView;
@property (nonatomic, assign) YXVideoLessonStatus   lessonStatus;

@end

@implementation YXHomeworkInfoViewController

- (void)setLessonStatus:(YXVideoLessonStatus)lessonStatus{
    _lessonStatus = lessonStatus;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.title = self.titleString;
    self.lessonStatus = YXVideoLessonStatus_NoRecord;
    [self setupUI];
    [self layoutInterface];
    [self requestForHomeworkInfo];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (YXHomeworkInfoHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[YXHomeworkInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 336.0f)];
    }
    return _headerView;
}

#pragma mark - setupUI
- (void)setupUI{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[YXHomeworkInfoNoRecordCell class] forCellReuseIdentifier:@"YXHomeworkInfoNoRecordCell"];
    [self.view addSubview:_tableView];
}

- (void)layoutInterface{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.lessonStatus == YXVideoLessonStatus_NoRecord || self.lessonStatus == YXVideoLessonStatus_AlreadyRecord) {
        return MAX(kScreenHeight - 64.0f - 336.0f, 150.0f);
    }
    return 0.0f;
};

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_infoItem.body.type.integerValue == 2 || _infoItem.body.type.integerValue == 3) {
        return 1;
    }else{
      return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.lessonStatus == YXVideoLessonStatus_NoRecord || self.lessonStatus == YXVideoLessonStatus_AlreadyRecord) {
        YXHomeworkInfoNoRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeworkInfoNoRecordCell" forIndexPath:indexPath];
        WEAK_SELF
        cell.noRecordHandler = ^(YXHomeworkInfoNoRecordCellType type){
            STRONG_SELF
            YXVideoRecordViewController *VC = [[YXVideoRecordViewController alloc] init];
            VC.videoModel = self ->_infoItem.body;
            [[self visibleViewController] presentViewController:VC animated:YES completion:^{
                
            }];
        };
        return cell;
    }
    return nil;
}

#pragma mark - request
- (void)requestForHomeworkInfo{
    YXHomeworkInfoRequest *request = [[YXHomeworkInfoRequest alloc] init];
    request.pid = [YXTrainManager sharedInstance].currentProject.pid;
    request.requireid = self.requireid;
    request.hwid = self.hwid;
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[YXHomeworkInfoRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            
        }else{
            YXHomeworkInfoRequestItem *item = retItem;
            if (item) {
                item.body.uid = [YXUserManager sharedManager].userModel.uid;
                item.body.pid = [YXTrainManager sharedInstance].currentProject.pid;
                self ->_infoItem = item;
                [self findVideoHomeworkInformation:self ->_infoItem];
            }
        }
    }];
    
    _infoRequest = request;
}

#pragma mark - upload video
- (void)uploadVideoForQiNiu{
    WEAK_SELF
    _getQiNiuTokenRequest = [[YXGetQiNiuTokenRequest alloc] init];
    [_getQiNiuTokenRequest  startRequestWithRetClass:[YXGetQiNiuTokenRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        YXGetQiNiuTokenRequestItem *item = retItem;
        DDLogDebug(@"%@",item.uploadToken);
        _uploadRequest = [[YXQiNiuVideoUpload alloc] initWithFileName:@"1129632018079.mp4" qiNiuToken:item.uploadToken];
        [_uploadRequest  startUpload];
    }];
}
- (void)findVideoHomeworkInformation:(YXHomeworkInfoRequestItem *)item{
    NSArray *saveArray = [YXVideoRecordManager getVideoArrayWithModel];
    [saveArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YXHomeworkInfoRequestItem_Body *model = obj;
        if ([model.filePath yx_isValidString] && [model.uid isEqualToString:[YXUserManager sharedManager].userModel.uid] && [model.pid isEqualToString:item.body.pid]) {
            NSString *filePath = [PATH_OF_VIDEO stringByAppendingPathComponent:model.filePath];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                self.lessonStatus = model.lessonStatus;
            }
        }
    }];
    _tableView.tableHeaderView = self.headerView;
    self.headerView.body = _infoItem.body;
    [_tableView reloadData];
}

@end
