//
//  MasterHomeworkSetDetailViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkSetDetailViewController_17.h"
#import "MasterHomeworkSetDetailTableHeaderView_17.h"
#import "MasterHomeworkSetDetailRequest_17.h"
#import "MasterHomeworkSetAffixCell_17.h"
#import "MasterHomeworkSetCommentCell_17.h"
#import "MasterHomeworkSetRemarkListRequest_17.h"
#import "MasterHomeworkSetCommentHeaderView_17.h"
#import "MasterHomeworkSetDeleteRemarkRequest_17.h"
@interface MasterHomeworkSetDetailViewController_17 ()
<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MasterHomeworkSetDetailTableHeaderView_17 *headerView;
@property (nonatomic, strong) MasterHomeworkSetDetailRequest_17 *detailRequest;
@property (nonatomic, strong) MasterHomeworkSetDetailItem_Body *detailItem;
@property (nonatomic, strong) MasterHomeworkSetRemarkListRequest_17 *remarkRequest;

@property (nonatomic, strong) MasterHomeworkSetDeleteRemarkRequest_17 *deleteRequest;
@property (nonatomic, strong) NSMutableArray *remarkMutableArray;
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;

@property (nonatomic, strong) YXFileItemBase *fileItem;
@property (nonatomic, assign) NSInteger startPage;
@property (nonatomic, strong) YXEmptyView *supportView;

@end

@implementation MasterHomeworkSetDetailViewController_17
- (void)dealloc {
    DDLogDebug(@"======>>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.remarkMutableArray = [[NSMutableArray alloc] init];
    self.startPage = 1;
    if (!self.isSupportBool) {
        self.supportView = [[YXEmptyView alloc] init];
        self.supportView.title = @"作业类型暂不支持,请通过电脑查看";
        self.supportView.imageName = @"无内容";
        [self.view addSubview:self.supportView];
        [self.supportView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        return;
    }
    [self setupUI];
    [self setupLayout];
    [YXPromtController startLoadingInView:self.parentViewController.view];
    [self requestForHomeworkDetail];
    [self requestForHomeworkRemark];
    
}
#pragma mark - set
- (void)setDetailItem:(MasterHomeworkSetDetailItem_Body *)detailItem {
    _detailItem = detailItem;
    self.headerView.body = _detailItem;
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 227.0f + self.headerView.summaryHeight);
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.hidden = NO;
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}
#pragma mark - setup UI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[MasterHomeworkSetCommentCell_17 class] forCellReuseIdentifier:@"MasterHomeworkSetCommentCell_17"];
    [self.tableView registerClass:[MasterHomeworkSetAffixCell_17 class] forCellReuseIdentifier:@"MasterHomeworkSetAffixCell_17"];
    [self.tableView registerClass:[MasterHomeworkSetCommentHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"MasterHomeworkSetCommentHeaderView_17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    self.headerView = [[MasterHomeworkSetDetailTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 500.0f)];
    self.tableView.hidden = YES;
    self.tableView.tableHeaderView = self.headerView;
    WEAK_SELF
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        STRONG_SELF
        self.startPage = 1;
        [self requestForHomeworkDetail];
        [self requestForHomeworkRemark];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        STRONG_SELF
        self.startPage ++;
        [self requestForHomeworkRemark];
    }];
    self.tableView.mj_footer.hidden = YES;
    self.errorView = [[YXErrorView alloc] init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [YXPromtController startLoadingInView:self.parentViewController.view];
        [self requestForHomeworkDetail];
    };
    self.dataErrorView = [[DataErrorView alloc] init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [YXPromtController startLoadingInView:self.parentViewController.view];
        [self requestForHomeworkDetail];
    };
}

- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.view.mas_top);
    }];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:@"MasterHomeworkSetAffixCell_17" configuration:^(MasterHomeworkSetAffixCell_17 *cell) {
            cell.affix = self.detailItem.template.affixs[indexPath.row];
        }];
    }else {
        return [tableView fd_heightForCellWithIdentifier:@"MasterHomeworkSetCommentCell_17" configuration:^(MasterHomeworkSetCommentCell_17 *cell) {
            cell.remark = self.remarkMutableArray[indexPath.row];
            
        }];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    footerView.contentView.backgroundColor = [UIColor whiteColor];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.detailItem.template.affixs.count > 0) {
            return 23.0f;
        }else {
            return 0.001f;
        }
    }else {
        if (self.remarkMutableArray.count > 0) {
            return 40.0f;
        }else {
            return 0.001f;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        YXSectionHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
        headerView.contentView.backgroundColor = [UIColor whiteColor];
        return headerView;
    }else {
        MasterHomeworkSetCommentHeaderView_17 *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MasterHomeworkSetCommentHeaderView_17"];
        headerView.contentView.backgroundColor = [UIColor whiteColor];
        return headerView;
    }
}
#pragma mark - UITableViewDataSorce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.detailItem.template.affixs.count;
    }else {
        return self.remarkMutableArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MasterHomeworkSetAffixCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterHomeworkSetAffixCell_17" forIndexPath:indexPath];
        cell.affix = self.detailItem.template.affixs[indexPath.row];
        return cell;
    }else {
        MasterHomeworkSetCommentCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterHomeworkSetCommentCell_17" forIndexPath:indexPath];
        cell.remark = self.remarkMutableArray[indexPath.row];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        MasterHomeworkSetDetailItem_Template_Affix *affix = self.detailItem.template.affixs[indexPath.row];
        YXFileType type = [YXAttachmentTypeHelper fileTypeWithTypeName:affix.resType];
        if(type == YXFileTypeUnknown) {
            [self showToast:@"暂不支持该格式文件预览"];
            return;
        }
        YXFileItemBase *fileItem = [FileBrowserFactory browserWithFileType:type];
        fileItem.name = affix.resName;
        fileItem.url = affix.previewUrl;
        fileItem.baseViewController = self;
        fileItem.reportTitle = @"作品集附件浏览页面";
        [fileItem browseFile];
        self.fileItem = fileItem;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  @"删除";
}
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        MasterHomeworkSetRemarkListItem_Body_Remark *remark = self.remarkMutableArray[indexPath.row];
        if (remark.allowDel.boolValue) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        MasterHomeworkSetRemarkListItem_Body_Remark *remark = self.remarkMutableArray[indexPath.row];
        if (remark.allowDel.boolValue) {
            return UITableViewCellEditingStyleDelete;
        }else {
            return UITableViewCellEditingStyleNone;
        }
    }else {
        return UITableViewCellEditingStyleNone;
    }
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        MasterHomeworkSetRemarkListItem_Body_Remark *remark = self.remarkMutableArray[indexPath.row];
        if (remark.allowDel.boolValue) {
            WEAK_SELF
            UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                STRONG_SELF
                [self requestForDeleteRemark:indexPath.row];
            }];
            return @[deleteRoWAction];
        }else {
            return nil;
        }
    }else {
        return nil;
    }
}
#pragma mark - request
- (void)requestForHomeworkDetail {
    MasterHomeworkSetDetailRequest_17 *request = [[MasterHomeworkSetDetailRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.homeworkId = self.homeworkId;
    WEAK_SELF
    [request startRequestWithRetClass:[MasterHomeworkSetDetailItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [YXPromtController stopLoadingInView:self.parentViewController.view];
        [self.tableView.mj_header endRefreshing];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        self.detailItem = ((MasterHomeworkSetDetailItem *)retItem).body;
    }];
    self.detailRequest = request;
}
- (void)requestForHomeworkRemark{
    [self.remarkRequest stopRequest];
    MasterHomeworkSetRemarkListRequest_17 *request = [[MasterHomeworkSetRemarkListRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.homeworkSetId = self.homeworkSetId;
    request.page = [NSString stringWithFormat:@"%ld",(long)self.startPage];
    request.pageSize = @"20";
    WEAK_SELF
    [request startRequestWithRetClass:[MasterHomeworkSetRemarkListItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [YXPromtController stopLoadingInView:self.parentViewController.view];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self setPullupViewHidden:YES];
        if (error) {
            self.startPage--;
            [self showToast:error.localizedDescription];
        }else {
            if (self.startPage == 1) {
                [self.remarkMutableArray removeAllObjects];
            }
            MasterHomeworkSetRemarkListItem *item = retItem;
            [self.remarkMutableArray addObjectsFromArray:item.body.remarks];
            if (self.detailItem != nil) {
                [self.tableView reloadData];
            }
            [self setPullupViewHidden:[self.remarkMutableArray count] >= item.body.total.integerValue];
        }
    }];
    self.remarkRequest = request;
}
- (void)setPullupViewHidden:(BOOL)hidden {
    self.tableView.mj_footer.hidden = hidden;
}
- (void)requestForDeleteRemark:(NSInteger)integer {
    MasterHomeworkSetRemarkListItem_Body_Remark *remark = self.remarkMutableArray[integer];
    MasterHomeworkSetDeleteRemarkRequest_17 *request = [[MasterHomeworkSetDeleteRemarkRequest_17 alloc] init];
    request.remarkId = remark.rId;
    [YXPromtController startLoadingInView:self.parentViewController.view];
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [YXPromtController stopLoadingInView:self.parentViewController.view];
        if (error) {
            [self showToast:error.localizedDescription];
        }else {
            [self showToast:@"删除成功"];
            [self.remarkMutableArray removeObjectAtIndex:integer];
            [self.tableView reloadData];
        }
    }];
    self.deleteRequest = request;
}
- (void)reloadMasterHomeworkSetRemark {
    self.startPage  = 1;
    [YXPromtController stopLoadingInView:self.parentViewController.view];
    [self requestForHomeworkRemark];
}
@end
