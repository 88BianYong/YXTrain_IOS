//
//  YXMyDatumViewController.m
//  TrainApp
//
//  Created by 李五民 on 16/6/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXMyDatumViewController.h"
#import "YXMyDatumFetcher.h"
#import "YXMyDatumCell.h"
#import "PersistentUrlDownloader.h"
#import "YXResourceCollectionRequest.h"
#import "YXDatumDelSourseRequest.h"
#import "YXAttachmentTypeHelper.h"
static  NSString *const trackPageName = @"我的资源页面";
@interface YXMyDatumViewController ()<YXMyDatumCellDelegate>

@property (nonatomic, strong) YXMyDatumFetcher *myDatumFetcher;
@property (nonatomic, strong) PersistentUrlDownloader *downloader;
@property (nonatomic, strong) YXResourceCollectionRequest *collectionRequest;
@property (nonatomic, strong) YXDatumCellModel *currentDownloadingModel;
@property (nonatomic, strong) YXDatumDelSourseRequest *delSourceRequest;
@property (nonatomic, strong) YXFileItemBase *fileItem;
@end

@implementation YXMyDatumViewController

- (void)viewDidLoad {
    self.bIsGroupedTableViewStyle = YES;
    [self setupDataFetcher];
    [super viewDidLoad];
    self.emptyView.imageName = @"没有收藏资源";
    self.emptyView.title = @"您还没有收藏的资源";
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YXMyDatumCell class] forCellReuseIdentifier:@"YXMyDatumCell"];
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 5)];
    tableViewHeaderView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:YXFavorSuccessNotification object:nil] subscribeNext:^(NSNotification *x) {
        @strongify(self);
        if (!self) return;
        [self firstPageFetch];
    }];
    
    self.tableView.tableHeaderView = tableViewHeaderView;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.showsVerticalScrollIndicator = YES;
    [YXDataStatisticsManger trackPage:trackPageName withStatus:YES];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tableView.showsVerticalScrollIndicator = NO;
    [YXDataStatisticsManger trackPage:trackPageName withStatus:NO];
    self.navigationController.navigationBar.shadowImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupDataFetcher{
    self.myDatumFetcher = [[YXMyDatumFetcher alloc]init];
    self.myDatumFetcher.pagesize = 20;
    self.dataFetcher = self.myDatumFetcher;
}

- (void)cancelDownload{
    // 如果是第一页则不取消，否则取消下载
    BOOL firstPageDownloading = FALSE;
    NSInteger count = [self.dataArray count];
    if (count > 20) {
        count = 20;
    }
    for (int i=0; i<count; i++) {
        YXDatumCellModel *model = self.dataArray[i];
        if (model.downloadState == DownloadStatusDownloading) {
            firstPageDownloading = TRUE;
            break;
        }
    }
    if (!firstPageDownloading && self.downloader.state == DownloadStatusDownloading) {
        [self.downloader stop];
        [self.downloader clear];
    }
}

- (void)tableViewWillRefresh{
    [self cancelDownload];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXMyDatumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXMyDatumCell" forIndexPath:indexPath];
    cell.canOpenDatumToast = ^{
        [self showToast:@"音视频不支持下载"];
    };
    cell.cellModel = self.dataArray[indexPath.row];
    if (indexPath.row == self.dataArray.count - 1) {
        [cell hiddenBottomView:YES];
    } else {
        [cell hiddenBottomView:NO];
    }
    cell.delegate = self;
    // 对于第一页数据记录下载状态
    if (indexPath.row < 20) {
        if ([cell.cellModel.aid isEqualToString:self.currentDownloadingModel.aid]
            &&cell.cellModel.downloadState != DownloadStatusDownloading
            &&self.currentDownloadingModel.downloadState == DownloadStatusDownloading) {
            cell.cellModel.downloadState = DownloadStatusDownloading;
            cell.cellModel.downloadedSize = self.downloader.downloadedSizeByte;
            [self setupObserversWithCellModel:cell.cellModel];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"YXMyDatumCell" configuration:^(YXMyDatumCell *cell) {
        cell.cellModel = self.dataArray[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXDatumCellModel *data = self.dataArray[indexPath.row];
    if (data.downloadState == DownloadStatusDownloading) {
        return;
    }
    YXFileType type = [YXAttachmentTypeHelper fileTypeWithTypeName:data.type];
    if(type == YXFileTypeUnknown) {
        [self showToast:@"暂不支持该格式文件预览"];
        return;
    }
    YXFileItemBase *fileItem = [FileBrowserFactory browserWithFileType:type];
    fileItem.name = data.title;
    fileItem.url = data.url;
    fileItem.baseViewController = self;
    if (data.downloadState == DownloadStatusFinished) { // 没下载的在线预览
        fileItem.isLocal = YES;
        fileItem.url = [PersistentUrlDownloader localPathForUrl:data.url];
    }
    [fileItem browseFile];
    self.fileItem = fileItem;
    [YXDataStatisticsManger trackEvent:@"资源" label:@"预览资源" parameters:nil];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    YXDatumCellModel *model = self.dataArray[indexPath.row];
    //    if ([model.uid isEqualToString:[LSTSharedInstance sharedInstance].userManger.userModel.uid]) {  // 我的上传
    //        if (self.delSourceRequest) {//11,29产品要求,现在项目没有上传的功能~
    //            [self.delSourceRequest stopRequest];
    //        }
    //        self.delSourceRequest = [[YXDatumDelSourseRequest alloc] init];
    //        self.delSourceRequest.resid = model.aid;
    //        @weakify(self);
    //        [self startLoading];
    //        [self.delSourceRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
    //            @strongify(self);
    //            [self stopLoading];
    //            if (error) {
    //                [self showToast:error.localizedDescription];
    //                return;
    //            }
    //            [self tableView:tableView handleDeleteDatumforIndexPath:indexPath withResponseItem:retItem];
    //        }];
    //    }else
    {  // 我的收藏
        if (self.collectionRequest) {
            [self.collectionRequest stopRequest];
        }
        self.collectionRequest = [[YXResourceCollectionRequest alloc] init];
        self.collectionRequest.aid = model.aid;
        self.collectionRequest.type = model.type;
        self.collectionRequest.iscollection = @"1";
        @weakify(self);
        [self startLoading];
        [self.collectionRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            @strongify(self);
            [self stopLoading];
            if (error) {
                [self showToast:error.localizedDescription];
            }
            else{
                [self tableView:tableView handleDeleteDatumforIndexPath:indexPath withResponseItem:retItem];
            }//7 22 测试需要结果 郑小龙
        }];
    }
}

- (void)tableView:(UITableView *)tableView handleDeleteDatumforIndexPath:(NSIndexPath *)indexPath withResponseItem:(HttpBaseRequestItem *)retItem{
    YXDatumCellModel *model = self.dataArray[indexPath.row];
    if (retItem) {
        // 如果当前项正在下载则需要先停止
        if (model.downloadState == DownloadStatusDownloading) {
            [self.downloader stop];
        }
        [PersistentUrlDownloader removeFile:model.url];
        
        model.isFavor = FALSE;
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        if ([self.dataArray count] == 0) {
            [self.contentView addSubview:self.emptyView];
            self.emptyView.frame = self.contentView.bounds;
        }
    } else {
        [self.emptyView removeFromSuperview];
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [tableView endUpdates];
        [self showToast:@"删除失败"];
    }
}

#pragma mark - YXMyDatumCellDelegate
- (void)myDatumCellDownloadButtonClicked:(YXMyDatumCell *)myDatumCell{
    YXDatumCellModel *model = myDatumCell.cellModel;
    if (model.downloadState != DownloadStatusDownloading) { // 当前点击是未下载
        if (self.downloader.state == DownloadStatusDownloading) { // 当有任务下载时不能下载
            [self showToast:@"已有任务正在下载中哦"];
            return;
        }else{
            // 先检查网络
            Reachability *r = [Reachability reachabilityForInternetConnection];
            if (![r isReachable]) {
                [self showToast:@"网络异常,请稍候尝试"];
                return;
            }
            self.downloader = [[PersistentUrlDownloader alloc]init];
            [self.downloader setModel:model.url];
            [self setupObserversWithCellModel:model];
            [self.downloader start];
            self.currentDownloadingModel = model;
            [YXDataStatisticsManger trackEvent:@"资源" label:@"下载资源" parameters:nil];
        }
    }else{
        [self.downloader stop];
        [self.downloader clear];
    }
}
- (void)setupObserversWithCellModel:(YXDatumCellModel *)model{
    @weakify(self);
    [RACObserve(self.downloader, state) subscribeNext:^(id x) {
        @strongify(self);
        if (!self) {
            return;
        }
        model.downloadState = self.downloader.state;
    }];
    [RACObserve(self.downloader, downloadedSizeByte) subscribeNext:^(id x) {
        @strongify(self);
        if (!self) {
            return;
        }
        model.downloadedSize = self.downloader.downloadedSizeByte;
    }];
}




/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
