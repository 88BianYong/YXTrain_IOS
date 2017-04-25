//
//  NoticeAndBriefDetailViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "NoticeAndBriefDetailViewController.h"
#import "NoticeAndBriefDetailRequest.h"
#import "NoticeAndBriefDetailCell.h"
#import "NoticeAndBriefDetailTableHeaderView.h"
#import "NoticeAndBriefDetailHeaderView.h"

@interface NoticeAndBriefDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NoticeAndBriefDetailRequest *detailRequest;

@property (nonatomic, strong) NoticeAndBriefDetailRequestItem_Body *itemBody;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NoticeAndBriefDetailTableHeaderView *headerView;

@end

@implementation NoticeAndBriefDetailViewController
- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleString;
    [self setupUI];
    [self setupLayout];
    [self requestForNoticeAndBriefDetail];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 150.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[NoticeAndBriefDetailHeaderView class] forHeaderFooterViewReuseIdentifier:@"NoticeAndBriefDetailHeaderView"];
    [self.tableView registerClass:[NoticeAndBriefDetailCell class] forCellReuseIdentifier:@"NoticeAndBriefDetailCell"];
    self.headerView = [[NoticeAndBriefDetailTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 335 + kTableViewHeaderFixedHeight)];
    WEAK_SELF
    [self.headerView setNoticeAndBriefDetailHtmlOpenAndCloseBlock:^(BOOL isStatus) {
        STRONG_SELF
        if (isStatus) {
            [UIView animateWithDuration:0.3 animations:^{
                self.headerView.frame = CGRectMake(0, 0, kScreenWidth, kTableViewHeaderFixedHeight + self.headerView.changeHeight);
                self.tableView.tableHeaderView = self.headerView;
                [self.headerView relayoutHtmlText];
            }];
        }else {
            [self.tableView setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, kTableViewHeaderFixedHeight + kTableViewHeaderHtmlPlaceholdeHeight);
            self.tableView.tableHeaderView = self.headerView;
            [self.headerView relayoutHtmlText];
        }
    }];
    [self.headerView setNoticeAndBriefDetailHtmlHeightChangeBlock:^(CGFloat htmlHeight, CGFloat labelHeight) {
        STRONG_SELF
        if (htmlHeight < self.headerView.htmlViewDefaultHeight) {
            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, kTableViewHeaderFixedHeight - kTableViewHeaderOpenAndCloseHeight + htmlHeight + labelHeight + 20.0f);
        }else {
            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, kTableViewHeaderFixedHeight + kTableViewHeaderHtmlPlaceholdeHeight + labelHeight);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.tableHeaderView = self.headerView;
            [self.headerView relayoutHtmlText];
        });
    }];
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self requestForNoticeAndBriefDetail];
    };
    self.dataErrorView = [[DataErrorView alloc]init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self requestForNoticeAndBriefDetail];
    };
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"NoticeAndBriefDetailCell" configuration:^(NoticeAndBriefDetailCell *cell) {
        cell.affix = self.itemBody.affix[indexPath.row];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 95.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NoticeAndBriefDetailHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"NoticeAndBriefDetailHeaderView"];
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NoticeAndBriefDetailRequestItem_Body_Affix *affix = self.itemBody.affix[indexPath.row];
    YXFileType type = [YXAttachmentTypeHelper fileTypeWithTypeName:affix.res_type];
    if(type == YXFileTypeUnknown) {
        [self showToast:@"暂不支持该格式文件预览"];
        return;
    }
    YXFileItemBase *fileItem = [FileBrowserFactory browserWithFileType:type];
    fileItem.name = affix.resname;
    fileItem.url = affix.previewurl;
    fileItem.baseViewController = self;
    [fileItem browseFile];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.itemBody.affix.count > 0 ? 1 : 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return MIN(self.itemBody.affix.count,3);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeAndBriefDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeAndBriefDetailCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.affix = self.itemBody.affix[indexPath.row];
    return cell;
}
#pragma mark - request
- (void)requestForNoticeAndBriefDetail{
    NoticeAndBriefDetailRequest *request = [[NoticeAndBriefDetailRequest alloc] init];
    request.projectId = [YXTrainManager sharedInstance].currentProject.pid;
    request.nbID = self.nbIdString;
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[NoticeAndBriefDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        NoticeAndBriefDetailRequestItem *item = retItem;
        self.itemBody = item.body;
        self.headerView.body = self.itemBody;
        self.tableView.tableHeaderView = self.headerView;
        [self.tableView reloadData];
        self.tableView.hidden = NO;
    }];
    self.detailRequest = request;
}
@end
