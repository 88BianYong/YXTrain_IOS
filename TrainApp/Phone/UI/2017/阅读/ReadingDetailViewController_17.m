//
//  ReadingDetailViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ReadingDetailViewController_17.h"
#import "ReadingDetailTableHeaderView_17.h"
#import "ReadingDetailAnnexCell_17.h"
#import "ReadingDetailHeaderView_17.h"
#import "ReadingSubmitStatusRequest_17.h"
#import "FileReadingManager_17.h"
@interface ReadingDetailViewController_17 ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ReadingDetailTableHeaderView_17 *headerView;
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) dispatch_source_t sourceTimer;
@property (nonatomic, strong) UIButton *readButton;

@property (nonatomic, strong) ReadingSubmitStatusRequest_17 *submitRequest;
@property (nonatomic, strong) YXFileItemBase *fileItem;

@end

@implementation ReadingDetailViewController_17
- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
    if (self.sourceTimer) {
        dispatch_source_cancel(self.sourceTimer);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.reading.name;
    [self setupUI];
    [self setupLayout];
    BLOCK_EXEC(self.readingDetailFinishCompleteBlock);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - set
- (void)setReading:(ReadingListRequest_17Item_Objs *)reading {
    _reading = reading;
}
#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f2f4f7"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 150.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[ReadingDetailHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"ReadingDetailHeaderView_17"];
    [self.tableView registerClass:[ReadingDetailAnnexCell_17 class] forCellReuseIdentifier:@"ReadingDetailAnnexCell_17"];
    self.headerView = [[ReadingDetailTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 335)];
    self.headerView.contentString = self.reading.content;
    WEAK_SELF
    self.headerView.readingDetailHeaderHeightChangeBlock = ^(CGFloat height) {
        STRONG_SELF
        self.headerView.frame = CGRectMake(0, 0, kScreenWidth, height);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.tableHeaderView = self.headerView;
            [self.headerView relayoutHtmlText];
        });
    };
    self.tableView.tableHeaderView = self.headerView;
    if (!self.reading.isFinish.boolValue) {
        self.readButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.readButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.readButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"dfe2e6"]] forState:UIControlStateDisabled];
        [self.readButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateNormal];
        self.readButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [[self.readButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG_SELF
            [self requestForReadingSubmitStatus];
        }];
        [self.view addSubview:self.readButton];
        if ([FileReadingManager_17 hasReadingWithFileName:self.reading.name readingID:self.reading.objID]) {
            self.readButton.enabled = YES;
            [self.readButton setTitle:@"我已阅读文档内容" forState:UIControlStateNormal];
        }else {
            self.readButton.enabled = NO;
            [self readDocumentTime:self.readButton time:10];
        }
    }

}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom).offset(!self.reading.isFinish.boolValue ? -49.0f : 0);
    }];
    
    [self.readButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_offset(49.0f);
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"ReadingDetailAnnexCell_17" configuration:^(ReadingDetailAnnexCell_17 *cell) {
        cell.affix = self.reading.affix;
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ReadingDetailHeaderView_17 *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ReadingDetailHeaderView_17"];
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXFileType type = [YXAttachmentTypeHelper fileTypeWithTypeName:self.reading.affix.res_type];
    if(type == YXFileTypeUnknown) {
        [self showToast:@"暂不支持该格式文件预览"];
        return;
    }
    YXFileItemBase *fileItem = [FileBrowserFactory browserWithFileType:type];
    fileItem.name = self.reading.affix.resName;
    fileItem.url = self.reading.affix.previewUrl;
    fileItem.baseViewController = self;
    [fileItem browseFile];
    self.fileItem = fileItem;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.reading.affix == nil ? 0 : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.reading.affix == nil ? 0 : 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReadingDetailAnnexCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"ReadingDetailAnnexCell_17" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.affix = self.reading.affix;
    return cell;
}
- (void)readDocumentTime:(UIButton *)sender time:(NSInteger)intTime {
    __block NSInteger timeout = intTime;
    WEAK_SELF
    timeout -- ;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.sourceTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.sourceTimer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
    dispatch_source_set_event_handler(self.sourceTimer, ^{
        STRONG_SELF
        if (timeout <= 0) {
            dispatch_source_cancel(self.sourceTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setTitle:@"我已阅读文档内容" forState:UIControlStateNormal];
                sender.enabled = YES;
                [FileReadingManager_17 saveReadingWithFileName:self.reading.name readingID:self.reading.objID];
            });
        }
        else {
            NSString *timeString = [NSString stringWithFormat:@"(%ld)我已阅读文档内容",(long)timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setTitle:timeString forState:UIControlStateNormal];
                sender.enabled = NO;
            });
            timeout -- ;
        }
    });
    dispatch_resume(self.sourceTimer);
}
- (void)requestForReadingSubmitStatus {
    ReadingSubmitStatusRequest_17 *request = [[ReadingSubmitStatusRequest_17 alloc] init];
    request.stageID = self.stageString;
    request.contentID = self.reading.objID;
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = YES;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        [self showToast:@"已阅读"];
        BLOCK_EXEC(self.readingDetailFinishCompleteBlock);
        self.reading.isFinish = @"1";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
    self.submitRequest = request;
    
}
@end
